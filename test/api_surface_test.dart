import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/save_points_snackbar_dialog_bottomsheet.dart';

/// Backward-compatibility guard.
///
/// Every call below is written the way 1.2.1 documented it. If a later
/// release renames a symbol, reorders a positional argument, makes an
/// optional parameter required, or narrows a return type, this file stops
/// compiling — which is the point. Add to it, never loosen it.
void main() {
  Future<BuildContext> pumpHost(WidgetTester tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox.expand();
            },
          ),
        ),
      ),
    );
    return ctx;
  }

  group('a single import exposes the whole API', () {
    test('the entry point matches the package name', () {
      // Nothing to assert at runtime: this file imports only
      // package:save_points_snackbar_dialog_bottomsheet/
      // save_points_snackbar_dialog_bottomsheet.dart, so every symbol it
      // names below is reachable from that one import.
      expect(ContentDesignStyle.values, hasLength(12));
    });
  });

  group('SavePointsSnackbar static surface', () {
    testWidgets('show returns a ScaffoldFeatureController', (tester) async {
      final ctx = await pumpHost(tester);

      final ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
          controller = SavePointsSnackbar.show(
        ctx,
        title: 'title',
        subtitle: 'subtitle',
        type: SnackbarType.info,
        position: SnackbarPosition.bottom,
        duration: const Duration(milliseconds: 300),
      );

      expect(controller, isNotNull);
      await tester.pumpAndSettle(const Duration(seconds: 1));
    });

    testWidgets('every typed helper exists and is callable', (tester) async {
      final ctx = await pumpHost(tester);

      for (final show in <ScaffoldFeatureController<SnackBar,
              SnackBarClosedReason> Function()>[
        () => SavePointsSnackbar.showSuccess(ctx, title: 's'),
        () => SavePointsSnackbar.showError(ctx, title: 'e'),
        () => SavePointsSnackbar.showWarning(ctx, title: 'w'),
        // Added in 1.3.0 to match the other three.
        () => SavePointsSnackbar.showInfo(ctx, title: 'i'),
      ]) {
        expect(show(), isNotNull);
        await tester.pump();
      }

      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    testWidgets('showInfo really produces the info type', (tester) async {
      final ctx = await pumpHost(tester);

      SavePointsSnackbar.showInfo(
        ctx,
        title: 'info title',
        duration: const Duration(milliseconds: 300),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('info title'), findsOneWidget);
      // The info icon is the configured default for SnackbarType.info.
      expect(
        find.byIcon(
          SnackDiaBottomConfig().snackbar.typeConfigs[SnackbarType.info]!
              .defaultIcon,
        ),
        findsOneWidget,
      );

      await tester.pumpAndSettle(const Duration(seconds: 1));
    });
  });

  group('SavePointsDialog static surface', () {
    testWidgets('show takes context positionally', (tester) async {
      final ctx = await pumpHost(tester);

      final Future<bool?> result = SavePointsDialog.show(
        ctx,
        title: 'title',
        message: 'message',
        confirmText: 'OK',
        cancelText: 'Cancel',
        showCancelButton: true,
      );
      await tester.pumpAndSettle();

      expect(find.text('title'), findsOneWidget);
      Navigator.of(ctx).pop(false);
      await tester.pumpAndSettle();
      expect(await result, isFalse);
    });

    testWidgets('showCustom takes context as a named argument', (
      tester,
    ) async {
      final ctx = await pumpHost(tester);

      final Future<String?> result = SavePointsDialog.showCustom<String>(
        context: ctx,
        headerTitle: 'header',
        child: const Text('body'),
      );
      await tester.pumpAndSettle();

      expect(find.text('header'), findsOneWidget);
      Navigator.of(ctx).pop('done');
      await tester.pumpAndSettle();
      expect(await result, 'done');
    });
  });

  group('SavePointsBottomsheet static surface', () {
    testWidgets('show is generic and takes context as a named argument', (
      tester,
    ) async {
      final ctx = await pumpHost(tester);

      final Future<int?> result = SavePointsBottomsheet.show<int>(
        context: ctx,
        title: 'sheet',
        child: const Text('body'),
        blur: 0,
      );
      await tester.pumpAndSettle();

      expect(find.text('sheet'), findsOneWidget);
      Navigator.of(ctx).pop(7);
      await tester.pumpAndSettle();
      expect(await result, 7);
    });
  });

  group('BuildContext extensions', () {
    testWidgets('snackbar helpers hand back their controller', (tester) async {
      final ctx = await pumpHost(tester);

      final controller = ctx.showSuccessSnackbar(
        title: 'from the extension',
        duration: const Duration(seconds: 5),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('from the extension'), findsOneWidget);

      // The point of returning it: closing early.
      controller.close();
      await tester.pumpAndSettle();
      expect(find.text('from the extension'), findsNothing);
    });

    testWidgets('the other helpers still exist', (tester) async {
      final ctx = await pumpHost(tester);

      ctx.showErrorSnackbar(title: 'e');
      await tester.pump();
      ctx.showWarningSnackbar(title: 'w');
      await tester.pump();
      ctx.showInfoSnackbar(title: 'i');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('i'), findsOneWidget);

      ctx.dismissAllSnackbars();
      await tester.pumpAndSettle();

      expect(find.text('i'), findsNothing);
    });
  });

  group('configuration and queue surface', () {
    tearDown(() {
      SnackDiaBottomConfig().reset();
      SnackbarQueue().clear();
    });

    test('the config singleton still resolves and resets', () {
      final config = SnackDiaBottomConfig();
      expect(identical(config, SnackDiaBottomConfig()), isTrue);

      config.snackbar.defaultDuration = const Duration(seconds: 9);
      config.reset();
      expect(config.snackbar.defaultDuration, const Duration(seconds: 3));

      // Still present, still harmless.
      config.applyTheme(Brightness.dark);
    });

    test('the queue exposes its documented members', () {
      final queue = SnackbarQueue();
      expect(identical(queue, SnackbarQueue()), isTrue);
      expect(queue.isEmpty, isTrue);
      expect(queue.length, 0);
      expect(queue.isShowing, isFalse);
      queue.clear();
    });
  });

  group('design layer stays public', () {
    test('SpStyles resolves every style', () {
      for (final style in ContentDesignStyle.values) {
        final spec = SpStyles.of(style, const Color(0xFF6366F1), false);
        expect(spec.onSurface.a, 1.0, reason: '$style has opaque text');
      }
    });

    test('the shared header band exposes its metrics', () {
      expect(ColorHeaderBand.defaultHeight, greaterThan(0));
      expect(ColorHeaderBand.overhang, greaterThan(0));
    });
  });

  group('deprecated members are still there', () {
    test('SavePointsConstants survives for callers that still read it', () {
      expect(SavePointsConstants.spacingL, 16.0);
      expect(SavePointsConstants.borderRadiusL, 16.0);
    });

    test('SavePointsBottomsheet.defaultDesignStyle still assignable', () {
      SavePointsBottomsheet.defaultDesignStyle = ContentDesignStyle.glass;
      expect(
        SavePointsBottomsheet.defaultDesignStyle,
        ContentDesignStyle.glass,
      );
      SavePointsBottomsheet.defaultDesignStyle = null;
    });
  });
}
