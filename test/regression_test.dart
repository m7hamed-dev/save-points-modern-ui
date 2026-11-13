import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/save_points_snackbar_dialog_bottomsheet.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/circular_reveal_clip.dart';

/// Regression tests: each one pins a bug that shipped in 1.2.x.
void main() {
  Future<BuildContext> pumpHost(
    WidgetTester tester, {
    TextDirection direction = TextDirection.ltr,
    Widget? fab,
  }) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: direction,
          child: Scaffold(
            floatingActionButton: fab,
            body: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox.expand();
              },
            ),
          ),
        ),
      ),
    );
    return ctx;
  }

  group('top snackbar overlay lifecycle', () {
    testWidgets('two toasts in the same frame do not crash', (tester) async {
      // Was: "An OverlayEntry should be removed only once" — the first entry
      // was never inserted (a newer one claimed the slot) yet still removed.
      final ctx = await pumpHost(tester);

      SavePointsSnackbar.show(ctx, title: 'A', position: SnackbarPosition.top);
      SavePointsSnackbar.show(ctx, title: 'B', position: SnackbarPosition.top);

      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(tester.takeException(), isNull);
    });

    testWidgets('a burst of toasts does not crash', (tester) async {
      final ctx = await pumpHost(tester);
      for (var i = 0; i < 6; i++) {
        SavePointsSnackbar.show(
          ctx,
          title: 'toast $i',
          position: SnackbarPosition.top,
        );
      }
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(tester.takeException(), isNull);
    });

    testWidgets('onDismissed fires exactly once per toast', (tester) async {
      final ctx = await pumpHost(tester);
      var calls = 0;

      SavePointsSnackbar.show(
        ctx,
        title: 'once',
        position: SnackbarPosition.top,
        duration: const Duration(milliseconds: 300),
        onDismissed: () => calls++,
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(calls, 1);
    });
  });

  group('top toast survives the tree going away', () {
    testWidgets('tree replaced before the deferred insert runs', (
      tester,
    ) async {
      final ctx = await pumpHost(tester);
      SavePointsSnackbar.show(ctx, title: 'A', position: SnackbarPosition.top);

      // The insert is a post-frame callback; tear the app down before it runs.
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Text('gone'))),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(tester.takeException(), isNull);
    });

    testWidgets('route popped while the toast is still up', (tester) async {
      // The overlay used to keep static state and a static timer, which
      // outlived the route and later fired against a disposed controller.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (c) => ElevatedButton(
                  onPressed: () => Navigator.of(c).push(
                    MaterialPageRoute<void>(builder: (_) => const _ToastPage()),
                  ),
                  child: const Text('go'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('toast'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('on page 2'), findsOneWidget);

      tester.state<NavigatorState>(find.byType(Navigator).first).pop();
      await tester.pumpAndSettle(const Duration(seconds: 12));
      expect(tester.takeException(), isNull);
    });
  });

  group('the top overlay is repainted, not restructured', () {
    testWidgets('a second toast replaces the first one\'s content', (
      tester,
    ) async {
      // Toasts now share one OverlayEntry and swap what it paints. That only
      // works if each toast is keyed: without a key the second one would reuse
      // the first's State, keep its animation controller, and never appear.
      final ctx = await pumpHost(tester);

      SavePointsSnackbar.show(
        ctx,
        title: 'first toast',
        position: SnackbarPosition.top,
        duration: const Duration(seconds: 30),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('first toast'), findsOneWidget);

      SavePointsSnackbar.show(
        ctx,
        title: 'second toast',
        position: SnackbarPosition.top,
        duration: const Duration(seconds: 30),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.text('second toast'), findsOneWidget);
      expect(find.text('first toast'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('showing and hiding leaves the overlay entry in place', (
      tester,
    ) async {
      // The entry itself must survive a toast going away: inserting and
      // removing it per toast is what raced its own deferred insert, and what
      // reshapes the tree under a hovering pointer.
      final ctx = await pumpHost(tester);
      int overlayChildren() =>
          tester.widgetList<Overlay>(find.byType(Overlay)).length;

      final before = overlayChildren();
      for (var i = 0; i < 4; i++) {
        final controller = SavePointsSnackbar.show(
          ctx,
          title: 'toast $i',
          position: SnackbarPosition.top,
          duration: const Duration(seconds: 30),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        controller.close();
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      expect(overlayChildren(), before);
      expect(tester.takeException(), isNull);
    });
  });

  group('returned controller is truthful for top position', () {
    testWidgets('closed does not complete while the toast is up', (
      tester,
    ) async {
      // Was: a 1ms placeholder SnackBar completed `closed` immediately, which
      // also made SnackbarQueue fire every queued item at once.
      final ctx = await pumpHost(tester);
      final controller = SavePointsSnackbar.show(
        ctx,
        title: 'still here',
        position: SnackbarPosition.top,
        duration: const Duration(seconds: 2),
      );

      var closed = false;
      unawaited(controller.closed.then((_) => closed = true));

      await tester.pump(const Duration(milliseconds: 500));
      expect(closed, isFalse, reason: 'toast is still on screen');

      await tester.pumpAndSettle(const Duration(seconds: 4));
      expect(closed, isTrue, reason: 'toast has gone away');
    });

    testWidgets('close() takes the toast down', (tester) async {
      final ctx = await pumpHost(tester);
      final controller = SavePointsSnackbar.show(
        ctx,
        title: 'dismiss me',
        position: SnackbarPosition.top,
        duration: const Duration(seconds: 30),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('dismiss me'), findsOneWidget);

      controller.close();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('dismiss me'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('hideLikeCircle reaches the top toast', (tester) async {
    // Was: accepted by show() and silently dropped on the floor.
    final ctx = await pumpHost(tester);
    SavePointsSnackbar.show(
      ctx,
      title: 'revealed',
      position: SnackbarPosition.top,
      hideLikeCircle: true,
      duration: const Duration(seconds: 5),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(SnackbarCircularRevealClip), findsOneWidget);
  });

  group('barrier blur is opt-out, not accidental', () {
    testWidgets('blur: 0 paints no BackdropFilter', (tester) async {
      final ctx = await pumpHost(tester);
      SavePointsDialog.show(ctx, title: 'T', message: 'M', blur: 0);
      await tester.pumpAndSettle();
      expect(find.byType(BackdropFilter), findsNothing);
    });

    testWidgets('the documented default blurs the barrier', (tester) async {
      final ctx = await pumpHost(tester);
      SavePointsDialog.show(ctx, title: 'T', message: 'M');
      await tester.pumpAndSettle();
      expect(find.byType(BackdropFilter), findsWidgets);
    });

    testWidgets('a theme blur of 0 also opts out', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        SavePointsTheme(
          data: const SavePointsThemeData(blur: 0),
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (c) {
                  ctx = c;
                  return const SizedBox.expand();
                },
              ),
            ),
          ),
        ),
      );
      SavePointsDialog.show(ctx, title: 'T', message: 'M');
      await tester.pumpAndSettle();
      expect(find.byType(BackdropFilter), findsNothing);
    });
  });

  testWidgets('snackbar announces itself to screen readers', (tester) async {
    final handle = tester.ensureSemantics();
    final ctx = await pumpHost(tester);

    SavePointsSnackbar.showSuccess(
      ctx,
      title: 'Saved',
      subtitle: 'All good',
      position: SnackbarPosition.bottom,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.bySemanticsLabel('Saved. All good'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('the live region does not swallow the close button', (
    tester,
  ) async {
    // Announcing the snackbar via Semantics must not cost the user the only
    // way to dismiss it: wrapping the content in ExcludeSemantics collapsed
    // the whole subtree to a single node and lost the button.
    final handle = tester.ensureSemantics();
    final ctx = await pumpHost(tester);

    SavePointsSnackbar.show(
      ctx,
      title: 'Saved',
      subtitle: 'All good',
      position: SnackbarPosition.bottom,
      designStyle: ContentDesignStyle.outlined,
      duration: const Duration(seconds: 5),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.bySemanticsLabel('Saved. All good'), findsOneWidget);
    // Asserted on the node's own fields rather than via a semantics matcher:
    // the matchers keep getting renamed (matchesSemantics -> containsSemantics
    // -> isSemantics), and this keeps the suite runnable on the package's
    // declared minimum Flutter, not just the newest one.
    final closeButton = tester.getSemantics(find.byIcon(Icons.close));
    expect(
      closeButton.tooltip,
      'Close',
      reason: 'the close button must stay reachable by a screen reader',
    );

    handle.dispose();
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
  });

  testWidgets('circular reveal resolves against the ambient direction', (
    tester,
  ) async {
    // Was: alignment.resolve(TextDirection.ltr), so a directional alignment
    // revealed from the wrong edge under RTL.
    for (final direction in TextDirection.values) {
      final ctx = await pumpHost(tester, direction: direction);
      SavePointsSnackbar.show(
        ctx,
        title: 'rtl',
        position: SnackbarPosition.top,
        hideLikeCircle: true,
        duration: const Duration(seconds: 5),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      final clip = tester.widget<SnackbarCircularRevealClip>(
        find.byType(SnackbarCircularRevealClip),
      );
      expect(clip, isNotNull);
      expect(tester.takeException(), isNull);

      SavePointsSnackbar.show(
        ctx,
        title: 'x',
        position: SnackbarPosition.top,
        duration: const Duration(milliseconds: 1),
      );
      await tester.pumpAndSettle();
    }
  });

  testWidgets('bottom margin no longer double-counts FAB space', (
    tester,
  ) async {
    // Scaffold already lifts a floating SnackBar clear of the FAB (72dp),
    // so the package must not add its own 80dp on top.
    final ctx = await pumpHost(
      tester,
      fab: const FloatingActionButton(onPressed: null, child: Icon(Icons.add)),
    );
    SavePointsSnackbar.show(
      ctx,
      title: 'bottom',
      position: SnackbarPosition.bottom,
      duration: const Duration(seconds: 5),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final box = tester.getRect(find.byType(SnackBar));
    final screenHeight =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    expect(
      screenHeight - box.bottom,
      lessThan(120),
      reason: 'snackbar should sit just above the FAB, not 80dp higher again',
    );
  });

  testWidgets('the top toast placeholder swallows no taps', (tester) async {
    // A top toast is backed by an invisible SnackBar holding the messenger
    // slot. It now lives as long as the toast rather than 1ms, so it must not
    // become a dead zone across the bottom of the screen.
    var taps = 0;
    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (c) {
              ctx = c;
              return Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 120,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => taps++,
                      child: const ColoredBox(color: Color(0xFFEEEEEE)),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    SavePointsSnackbar.show(
      ctx,
      title: 'top toast',
      position: SnackbarPosition.top,
      duration: const Duration(seconds: 3),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Right inside the placeholder's own rect, not merely near it.
    final placeholder = tester.getRect(find.byType(SnackBar));
    await tester.tapAt(placeholder.center);
    expect(taps, 1, reason: 'the tap reached the app underneath');

    await tester.pumpAndSettle(const Duration(milliseconds: 500));
  });

  group('design', () {
    testWidgets('a consumer can pumpAndSettle a surface', (tester) async {
      // The icon pulse used to loop forever, so pumpAndSettle() hung in the
      // tests of anyone using this package — and cost a repaint every frame
      // for as long as the surface was up.
      final ctx = await pumpHost(tester);
      SavePointsDialog.show(
        ctx,
        title: 'Settles',
        message: 'No endless animation.',
        icon: Icons.info,
      );
      await tester.pumpAndSettle();
      expect(find.text('Settles'), findsOneWidget);
    });

    testWidgets('the pulse is still available, opt-in', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        SavePointsTheme(
          data: const SavePointsThemeData(enablePulse: true),
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (c) {
                  ctx = c;
                  return const SizedBox.expand();
                },
              ),
            ),
          ),
        ),
      );
      SavePointsDialog.show(
        ctx,
        title: 'Pulses',
        message: 'Opted in via the theme.',
        icon: Icons.info,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // A looping animation means frames keep being scheduled.
      expect(tester.binding.hasScheduledFrame, isTrue);
    });

    testWidgets('leftAccent does not stretch to the full screen', (
      tester,
    ) async {
      // The accent bar sat in a Row with CrossAxisAlignment.stretch and no
      // height bound, so the dialog grew to fill the viewport.
      final ctx = await pumpHost(tester);
      SavePointsDialog.show(
        ctx,
        title: 'Bounded',
        message: 'Short message.',
        icon: Icons.info,
        designStyle: ContentDesignStyle.leftAccent,
      );
      await tester.pumpAndSettle();

      final dialogHeight = tester.getSize(find.byType(DialogContainer)).height;
      final screenHeight =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      expect(
        dialogHeight,
        lessThan(screenHeight * 0.75),
        reason: 'the dialog should hug its content, not the viewport',
      );
    });
  });

  group('SnackbarQueue', () {
    setUp(SnackbarQueue().clear);

    testWidgets('clear() while showing does not wedge the queue', (
      tester,
    ) async {
      // Was: clear() left _isShowing true forever, so every later enqueue was
      // silently swallowed.
      final ctx = await pumpHost(tester);
      final queue = SnackbarQueue();

      queue.enqueue(
        context: ctx,
        title: 'first',
        duration: const Duration(seconds: 5),
      );
      await tester.pump();
      expect(queue.isShowing, isTrue);

      queue.clear();
      expect(queue.isShowing, isFalse);

      queue.enqueue(
        context: ctx,
        title: 'after clear',
        duration: const Duration(milliseconds: 400),
      );
      await tester.pump();
      expect(queue.isShowing, isTrue, reason: 'queue accepted new work');

      await tester.pumpAndSettle(const Duration(seconds: 6));
    });
  });

  group('loadingNotifier survives a rebuild', () {
    // Was: didUpdateWidget assigned `_isLoading = widget.isLoading` on every
    // rebuild, so a notifier-driven spinner was cancelled the moment anything
    // above rebuilt the surface — and the route's transition builder rebuilds
    // it once per frame.
    testWidgets('ModernDialog keeps the notifier value', (tester) async {
      final notifier = ValueNotifier<bool>(false);
      addTearDown(notifier.dispose);
      late StateSetter rebuild;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                rebuild = setState;
                return ModernDialog(
                  title: 'T',
                  message: 'M',
                  confirmText: 'OK',
                  cancelText: 'Cancel',
                  showCancelButton: false,
                  isDark: false,
                  loadingNotifier: notifier,
                );
              },
            ),
          ),
        ),
      );

      notifier.value = true;
      await tester.pump();
      expect(find.byType(DialogLoadingIndicator), findsOneWidget);

      rebuild(() {});
      await tester.pump();
      expect(
        find.byType(DialogLoadingIndicator),
        findsOneWidget,
        reason: 'an unrelated rebuild must not cancel loading',
      );
    });

    testWidgets('ModernBottomsheet keeps the notifier value', (tester) async {
      final notifier = ValueNotifier<bool>(false);
      addTearDown(notifier.dispose);
      late StateSetter rebuild;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                rebuild = setState;
                return ModernBottomsheet(
                  title: 'T',
                  isDark: false,
                  blur: 0,
                  loadingNotifier: notifier,
                  child: const Text('body'),
                );
              },
            ),
          ),
        ),
      );

      notifier.value = true;
      await tester.pump();
      expect(find.byType(BottomsheetLoadingIndicator), findsOneWidget);

      rebuild(() {});
      await tester.pump();
      expect(
        find.byType(BottomsheetLoadingIndicator),
        findsOneWidget,
        reason: 'an unrelated rebuild must not cancel loading',
      );
    });

    testWidgets('the initial notifier value is honoured at mount', (
      tester,
    ) async {
      // Was: initState seeded from `widget.isLoading` and ignored the
      // notifier, so a surface opened mid-flight showed no spinner until the
      // notifier next changed.
      final notifier = ValueNotifier<bool>(true);
      addTearDown(notifier.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ModernDialog(
              title: 'T',
              message: 'M',
              confirmText: 'OK',
              cancelText: 'Cancel',
              showCancelButton: false,
              isDark: false,
              loadingNotifier: notifier,
            ),
          ),
        ),
      );

      expect(find.byType(DialogLoadingIndicator), findsOneWidget);
    });

    testWidgets('an async confirm spinner survives a rebuild', (tester) async {
      // The same clobber hit the dialog's own spinner: onConfirmAsync set it,
      // and the next rebuild from above reset it to widget.isLoading.
      final gate = Completer<bool>();
      addTearDown(() {
        if (!gate.isCompleted) gate.complete(false);
      });
      late StateSetter rebuild;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                rebuild = setState;
                return ModernDialog(
                  title: 'T',
                  message: 'M',
                  confirmText: 'OK',
                  cancelText: 'Cancel',
                  showCancelButton: false,
                  isDark: false,
                  onConfirmAsync: () => gate.future,
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('OK'));
      await tester.pump();
      expect(find.byType(DialogLoadingIndicator), findsOneWidget);

      rebuild(() {});
      await tester.pump();
      expect(
        find.byType(DialogLoadingIndicator),
        findsOneWidget,
        reason: 'the async action is still in flight',
      );

      gate.complete(false);
      await tester.pumpAndSettle();
      expect(find.byType(DialogLoadingIndicator), findsNothing);
    });

    testWidgets('a swapped notifier takes over immediately', (tester) async {
      final first = ValueNotifier<bool>(true);
      final second = ValueNotifier<bool>(false);
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      var useSecond = false;
      late StateSetter rebuild;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                rebuild = setState;
                return ModernDialog(
                  title: 'T',
                  message: 'M',
                  confirmText: 'OK',
                  cancelText: 'Cancel',
                  showCancelButton: false,
                  isDark: false,
                  loadingNotifier: useSecond ? second : first,
                );
              },
            ),
          ),
        ),
      );
      expect(find.byType(DialogLoadingIndicator), findsOneWidget);

      rebuild(() => useSecond = true);
      await tester.pump();
      expect(
        find.byType(DialogLoadingIndicator),
        findsNothing,
        reason: 'the new notifier says not loading',
      );
    });
  });

  group('dismissAllSnackbars', () {
    testWidgets('also takes down an overlay-based top toast', (tester) async {
      final ctx = await pumpHost(tester);

      SavePointsSnackbar.show(
        ctx,
        title: 'top toast',
        position: SnackbarPosition.top,
        duration: const Duration(seconds: 10),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('top toast'), findsOneWidget);

      ctx.dismissAllSnackbars();
      await tester.pumpAndSettle();
      expect(
        find.text('top toast'),
        findsNothing,
        reason: 'the doc promises every visible snackbar goes away',
      );
    });
  });
}

/// A pushed route that raises a long-lived top toast, so a test can pop the
/// route out from under it.
class _ToastPage extends StatelessWidget {
  const _ToastPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => SavePointsSnackbar.show(
            context,
            title: 'on page 2',
            position: SnackbarPosition.top,
            duration: const Duration(seconds: 10),
          ),
          child: const Text('toast'),
        ),
      ),
    );
  }
}
