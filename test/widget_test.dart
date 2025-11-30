import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:savepoints_modern_ui/savepoints_modern_ui.dart';

void main() {
  testWidgets('SavePointsDialog smoke test', (WidgetTester tester) async {
    // Build a MaterialApp with Scaffold to provide context
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              // Test that SavePointsDialog can be called
              WidgetsBinding.instance.addPostFrameCallback((_) {
                SavePointsDialog.show(
                  context,
                  title: 'Test Dialog',
                  message: 'This is a test dialog',
                );
              });
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    
    // Verify dialog is shown
    expect(find.text('Test Dialog'), findsOneWidget);
  });

  testWidgets('SavePointsSnackbar smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                SavePointsSnackbar.show(
                  context,
                  title: 'Test Snackbar',
                );
              });
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    
    // Verify snackbar is shown
    expect(find.text('Test Snackbar'), findsOneWidget);
  });
}
