import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/save_points_snackbar_dialog_bottomsheet.dart';

/// Design- and performance-quality guarantees, asserted rather than assumed.
void main() {
  /// Flattens a translucent colour onto an opaque one — what the eye sees.
  Color over(Color fg, Color bg) => Color.from(
        alpha: 1.0,
        red: fg.r * fg.a + bg.r * (1 - fg.a),
        green: fg.g * fg.a + bg.g * (1 - fg.a),
        blue: fg.b * fg.a + bg.b * (1 - fg.a),
      );

  group('contrast meets WCAG AA', () {
    // 4.5:1 is the AA floor for body text; titles are large enough for 3:1 but
    // are held to the same bar here, since they all clear it comfortably.
    const floor = 4.5;

    for (final dark in [false, true]) {
      final label = dark ? 'dark' : 'light';
      // A mid-tone page behind the dimmed barrier: the worst realistic case
      // for the translucent styles, which composite over whatever is there.
      final behind = over(
        const Color(0x40000000),
        dark ? const Color(0xFF14243B) : const Color(0xFFBFD7F5),
      );

      for (final style in ContentDesignStyle.values) {
        test('$label / ${style.name}', () {
          final cfg = DialogColorConfig(
            theme: ThemeData(
              brightness: dark ? Brightness.dark : Brightness.light,
              useMaterial3: true,
            ),
            isDark: dark,
            designStyle: style,
          );
          final surface = over(cfg.backgroundColor, behind);

          expect(
            SpContrast.ratio(cfg.titleColor, surface),
            greaterThanOrEqualTo(floor),
            reason: 'title on ${style.name}',
          );
          expect(
            SpContrast.ratio(cfg.messageColor, surface),
            greaterThanOrEqualTo(floor),
            reason: 'body on ${style.name}',
          );
          expect(
            SpContrast.ratio(cfg.buttonTextColor, cfg.buttonColor),
            greaterThanOrEqualTo(floor),
            reason: 'button label on ${style.name}',
          );
        });
      }
    }
  });

  group('nothing animates once a surface has settled', () {
    Future<BuildContext> host(WidgetTester tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (c) {
                ctx = c;
                return const SizedBox.expand();
              },
            ),
          ),
        ),
      );
      return ctx;
    }

    testWidgets('dialog', (tester) async {
      final ctx = await host(tester);
      SavePointsDialog.show(ctx, title: 'T', message: 'M', icon: Icons.info);
      await tester.pumpAndSettle();
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('snackbar', (tester) async {
      final ctx = await host(tester);
      SavePointsSnackbar.showSuccess(
        ctx,
        title: 'Saved',
        position: SnackbarPosition.bottom,
        duration: const Duration(minutes: 5),
      );
      await tester.pumpAndSettle();
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('bottom sheet', (tester) async {
      final ctx = await host(tester);
      SavePointsBottomsheet.show<void>(
        context: ctx,
        title: 'Share',
        icon: Icons.ios_share,
        child: const Text('body'),
      );
      await tester.pumpAndSettle();
      expect(tester.binding.hasScheduledFrame, isFalse);
    });
  });

  testWidgets('the barrier fades without a full-screen saveLayer', (
    tester,
  ) async {
    // Animating an Opacity over the BackdropFilter cost a screen-sized
    // saveLayer on every frame of the entrance, on top of the one the blur
    // already needs. The barrier ramps its blur sigma instead.
    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (c) {
              ctx = c;
              return const SizedBox.expand();
            },
          ),
        ),
      ),
    );
    SavePointsDialog.show(ctx, title: 'T', message: 'M', icon: Icons.info);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));

    expect(find.byType(Opacity), findsNothing);
    expect(find.byType(BackdropFilter), findsWidgets);
  });

  group('layout survives large text', () {
    for (final scale in [1.5, 2.0]) {
      testWidgets('dialog and snackbar at ${scale}x', (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        late BuildContext ctx;
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: Scaffold(
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
          title: 'Delete this file permanently?',
          message: 'This removes the file from every device you are signed in '
              'on. You cannot undo this action.',
          confirmText: 'Delete',
          cancelText: 'Cancel',
          showCancelButton: true,
          icon: Icons.delete_outline,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  });
}
