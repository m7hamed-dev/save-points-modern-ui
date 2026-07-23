import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/save_points_snackbar_dialog_bottomsheet.dart';

/// Widget tests that pump the three public `show()` entry points and assert
/// they render their content and honour their input contracts.
void main() {
  /// Pumps a minimal app whose single button runs [onPressed] with a valid
  /// [BuildContext] under a [Scaffold].
  Future<void> pumpHost(
    WidgetTester tester,
    void Function(BuildContext context) onPressed, {
    ThemeMode themeMode = ThemeMode.light,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        themeMode: themeMode,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => onPressed(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('SavePointsDialog.show', () {
    testWidgets('renders title and message', (tester) async {
      await pumpHost(tester, (context) {
        SavePointsDialog.show(
          context,
          title: 'Delete item',
          message: 'This cannot be undone.',
        );
      });

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Delete item'), findsOneWidget);
      expect(find.text('This cannot be undone.'), findsOneWidget);
    });

    testWidgets('asserts on empty title', (tester) async {
      await pumpHost(tester, (context) {
        expect(
          () => SavePointsDialog.show(context, title: '', message: 'x'),
          throwsAssertionError,
        );
      });
      await tester.tap(find.text('open'));
      await tester.pump();
    });

    testWidgets('renders across all eight design styles', (tester) async {
      for (final style in ContentDesignStyle.values) {
        await pumpHost(tester, (context) {
          SavePointsDialog.show(
            context,
            title: 'Style ${style.name}',
            message: 'body',
            designStyle: style,
          );
        });
        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();
        expect(find.text('Style ${style.name}'), findsOneWidget,
            reason: 'dialog should render with $style');
        // Dismiss by popping so the next iteration starts clean.
        final navigator = tester.state<NavigatorState>(find.byType(Navigator));
        navigator.pop();
        await tester.pumpAndSettle();
      }
    });
  });

  group('SavePointsSnackbar', () {
    testWidgets('showSuccess renders the title', (tester) async {
      await pumpHost(tester, (context) {
        SavePointsSnackbar.showSuccess(
          context,
          title: 'Saved',
          duration: const Duration(milliseconds: 500),
        );
      });
      await tester.tap(find.text('open'));
      await tester.pump(); // start the entrance animation
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Saved'), findsOneWidget);

      // Let the auto-dismiss timer fire and the exit animation finish so no
      // Timer outlives the test.
      await tester.pumpAndSettle(const Duration(seconds: 1));
    });

    testWidgets('show asserts on empty title', (tester) async {
      await pumpHost(tester, (context) {
        expect(
          () => SavePointsSnackbar.show(context, title: ''),
          throwsAssertionError,
        );
      });
      await tester.tap(find.text('open'));
      await tester.pump();
    });
  });

  group('SavePointsBottomsheet.show', () {
    testWidgets('renders the provided child', (tester) async {
      await pumpHost(tester, (context) {
        SavePointsBottomsheet.show(
          context: context,
          title: 'Options',
          child: const Text('sheet body'),
        );
      });
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('sheet body'), findsOneWidget);
    });
  });

  group('context extensions', () {
    testWidgets('showSuccessSnackbar renders through the extension',
        (tester) async {
      await pumpHost(tester, (context) {
        context.showSuccessSnackbar(
          title: 'Via extension',
          duration: const Duration(milliseconds: 500),
        );
      });
      await tester.tap(find.text('open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Via extension'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 1));
    });
  });
}
