import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/save_points_snackbar_dialog_bottomsheet.dart';

/// Tests for the scoped [SavePointsTheme] defaults provider.
void main() {
  group('SavePointsThemeData', () {
    test('supports value equality and hashing', () {
      const a = SavePointsThemeData(
        designStyle: ContentDesignStyle.glass,
        blur: 20,
      );
      const b = SavePointsThemeData(
        designStyle: ContentDesignStyle.glass,
        blur: 20,
      );
      const c = SavePointsThemeData(designStyle: ContentDesignStyle.neon);

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
    });

    test('copyWith overrides only the given fields', () {
      const base = SavePointsThemeData(
        designStyle: ContentDesignStyle.glass,
        blur: 10,
        snackbarPosition: SnackbarPosition.top,
      );
      final updated = base.copyWith(blur: 30);

      expect(updated.blur, 30);
      expect(updated.designStyle, ContentDesignStyle.glass);
      expect(updated.snackbarPosition, SnackbarPosition.top);
    });
  });

  group('SavePointsTheme.maybeOf', () {
    testWidgets('returns null when no theme is in scope', (tester) async {
      SavePointsThemeData? captured;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              captured = SavePointsTheme.maybeOf(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(captured, isNull);
    });

    testWidgets('resolves the nearest theme, honouring nested overrides',
        (tester) async {
      SavePointsThemeData? outer;
      SavePointsThemeData? inner;

      await tester.pumpWidget(
        MaterialApp(
          home: SavePointsTheme(
            data: const SavePointsThemeData(
              designStyle: ContentDesignStyle.glass,
            ),
            child: Builder(
              builder: (context) {
                outer = SavePointsTheme.maybeOf(context);
                return SavePointsTheme(
                  data: const SavePointsThemeData(
                    designStyle: ContentDesignStyle.neon,
                  ),
                  child: Builder(
                    builder: (context) {
                      inner = SavePointsTheme.maybeOf(context);
                      return const SizedBox();
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(outer?.designStyle, ContentDesignStyle.glass);
      expect(inner?.designStyle, ContentDesignStyle.neon);
    });
  });

  group('components resolve defaults from an in-scope theme', () {
    testWidgets('dialog renders under a theme that sets the design style',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SavePointsTheme(
            data: const SavePointsThemeData(
              designStyle: ContentDesignStyle.glass,
              blur: 18,
            ),
            child: Scaffold(
              body: Builder(
                builder: (context) => Center(
                  child: ElevatedButton(
                    onPressed: () => SavePointsDialog.show(
                      context,
                      title: 'Themed',
                      message: 'body',
                    ),
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Themed'), findsOneWidget);
    });
  });
}
