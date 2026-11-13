import 'package:example/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

/// Smoke tests for the example app.
///
/// The example is the first thing a developer runs, so it is worth proving
/// that it actually works rather than merely that it compiles: these drive
/// the real buttons and assert on what appears.
///
/// Note the bounded `pump(duration)` calls instead of `pumpAndSettle()`: the
/// demo deliberately loops a rotating gradient behind the page and a breathing
/// header icon, so the frame queue never goes quiet and `pumpAndSettle` would
/// time out. That is the example's own flourish, not the package's — every
/// surface the package itself puts on screen does settle, which
/// `test/quality_test.dart` in the package pins.
void main() {
  /// Boots the app and lets the entrance animations play out, without ever
  /// waiting for the tree to go idle.
  Future<void> boot(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
  }

  testWidgets('the example boots and renders its sections', (tester) async {
    await boot(tester);

    expect(find.text('🎭 Dialogs'), findsOneWidget);
    expect(find.text('🍞 Snackbars'), findsOneWidget);
    expect(find.text('📱 Bottom Sheets'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a dialog example opens and closes', (tester) async {
    await boot(tester);

    final button = find.text('Dialog Solid');
    await tester.scrollUntilVisible(button, 200);
    await tester.tap(button);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Solid Style'), findsOneWidget);

    // Close it the way a user would: the confirm button.
    await tester.tap(find.text('OK'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Solid Style'), findsNothing);
  });

  testWidgets('a snackbar example appears', (tester) async {
    await boot(tester);

    final button = find.text('Top Position');
    await tester.scrollUntilVisible(button, 200);
    await tester.tap(button);

    // The top snackbar is an overlay inserted in a post-frame callback.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(SnackBar), findsWidgets);

    // Let it expire so the test ends with nothing pending.
    await tester.pump(const Duration(seconds: 6));
  });
}
