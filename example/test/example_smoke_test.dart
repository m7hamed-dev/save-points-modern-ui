import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Smoke tests for the example app.
///
/// The example is the first thing a developer runs, so it is worth proving
/// that it actually works rather than merely that it compiles: these drive
/// the real buttons and assert on what appears.
///
/// They use `pumpAndSettle()` throughout, which is the point. The demo used
/// to loop a rotating gradient behind the page and a breathing header icon
/// forever, so the frame queue never went quiet: every wait had to be a
/// hand-counted `pump(duration)` and no test could assert the app had come to
/// rest at all. Both animations now play once and settle.
void main() {
  testWidgets('the example boots and settles', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('🎭 Dialogs'), findsOneWidget);
    expect(find.text('🍞 Snackbars'), findsOneWidget);
    expect(find.text('📱 Bottom Sheets'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a dialog example opens and closes', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final button = find.text('Dialog Solid');
    await tester.scrollUntilVisible(button, 200);
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Solid Style'), findsOneWidget);

    // Close it the way a user would: the confirm button.
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Solid Style'), findsNothing);
  });

  testWidgets('a dialog example closes on a tap outside', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final button = find.text('Dialog Solid');
    await tester.scrollUntilVisible(button, 200);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.text('Solid Style'), findsOneWidget);

    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.text('Solid Style'), findsNothing);
  });

  testWidgets('a snackbar example appears and expires', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final button = find.text('Top Position');
    await tester.scrollUntilVisible(button, 200);
    await tester.tap(button);

    // The top snackbar is an overlay inserted in a post-frame callback.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byType(SnackBar), findsWidgets);

    // It goes away on its own, and the tree goes quiet with it.
    await tester.pumpAndSettle(const Duration(seconds: 10));
    expect(find.byType(SnackBar), findsNothing);
  });
}
