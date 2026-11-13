import 'package:material_ui/material_ui.dart';
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

  group('showCustom resolves defaults from an in-scope theme', () {
    /// Opens `showCustom` from inside a [SavePointsTheme] carrying [data] and
    /// returns the route it pushed, so its resolved barrier settings can be
    /// read back directly.
    Future<ModalRoute<dynamic>> openUnder(
      WidgetTester tester,
      SavePointsThemeData data, {
      bool? barrierDismissible,
      double? blur,
    }) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        MaterialApp(
          home: SavePointsTheme(
            data: data,
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

      SavePointsDialog.showCustom<void>(
        context: ctx,
        headerTitle: 'Header',
        barrierDismissible: barrierDismissible,
        blur: blur,
        child: const Text('body'),
      );
      await tester.pumpAndSettle();
      expect(find.text('Header'), findsOneWidget);
      return ModalRoute.of(tester.element(find.text('Header')))!;
    }

    testWidgets('a theme blur of 0 opts the barrier out', (tester) async {
      await openUnder(tester, const SavePointsThemeData(blur: 0));
      expect(
        find.byType(BackdropFilter),
        findsNothing,
        reason: 'showCustom used to ignore the theme and blur anyway',
      );
    });

    testWidgets('the built-in default still blurs without a theme blur', (
      tester,
    ) async {
      await openUnder(tester, const SavePointsThemeData());
      expect(find.byType(BackdropFilter), findsWidgets);
    });

    testWidgets('an explicit blur still beats the theme', (tester) async {
      await openUnder(tester, const SavePointsThemeData(blur: 20), blur: 0);
      expect(find.byType(BackdropFilter), findsNothing);
    });

    testWidgets('the theme supplies barrierDismissible', (tester) async {
      final route = await openUnder(
        tester,
        const SavePointsThemeData(barrierDismissible: false),
      );
      expect(
        route.barrierDismissible,
        isFalse,
        reason: 'showCustom used to hard-code true and ignore the theme',
      );
    });

    testWidgets('a theme barrierDismissible of true is passed through', (
      tester,
    ) async {
      final route = await openUnder(
        tester,
        const SavePointsThemeData(barrierDismissible: true),
      );
      expect(route.barrierDismissible, isTrue);
    });

    testWidgets('an explicit barrierDismissible beats the theme', (
      tester,
    ) async {
      final route = await openUnder(
        tester,
        const SavePointsThemeData(barrierDismissible: false),
        barrierDismissible: true,
      );
      expect(route.barrierDismissible, isTrue);
    });

    testWidgets('with no theme the default is still dismissible', (
      tester,
    ) async {
      final route = await openUnder(tester, const SavePointsThemeData());
      expect(route.barrierDismissible, isTrue);
    });
  });
}
