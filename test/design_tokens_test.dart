import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/save_points_snackbar_dialog_bottomsheet.dart';

/// Unit tests for the shared design-token layer that guarantees the three
/// components speak one visual language.
void main() {
  group('ContentDesignStyle', () {
    test('exposes every documented style', () {
      expect(ContentDesignStyle.values, hasLength(12));
      expect(
          ContentDesignStyle.values,
          containsAll(<ContentDesignStyle>[
            ContentDesignStyle.solid,
            ContentDesignStyle.outlined,
            ContentDesignStyle.tonal,
            ContentDesignStyle.colorHeader,
            ContentDesignStyle.leftAccent,
            ContentDesignStyle.glass,
            ContentDesignStyle.neon,
            ContentDesignStyle.minimal,
            ContentDesignStyle.brutalist,
            ContentDesignStyle.gradientBorder,
            ContentDesignStyle.aurora,
            ContentDesignStyle.soft,
          ]));
    });
  });

  group('SpIntent', () {
    test('covers the five semantic intents', () {
      expect(SpIntent.values, hasLength(5));
      expect(
          SpIntent.values,
          containsAll(<SpIntent>[
            SpIntent.success,
            SpIntent.error,
            SpIntent.warning,
            SpIntent.info,
            SpIntent.neutral,
          ]));
    });
  });

  group('SpRadius / SpSpacing scales', () {
    test('radius scale is strictly ascending', () {
      expect(SpRadius.sm, lessThan(SpRadius.md));
      expect(SpRadius.md, lessThan(SpRadius.lg));
      expect(SpRadius.lg, lessThan(SpRadius.xl));
    });

    test('spacing scale is strictly ascending', () {
      expect(SpSpacing.xs, lessThan(SpSpacing.sm));
      expect(SpSpacing.sm, lessThan(SpSpacing.md));
      expect(SpSpacing.md, lessThan(SpSpacing.lg));
      expect(SpSpacing.lg, lessThan(SpSpacing.xl));
      expect(SpSpacing.xl, lessThan(SpSpacing.xxl));
      expect(SpSpacing.xxl, lessThan(SpSpacing.xxxl));
    });
  });

  group('SpPalette', () {
    test('returns an accent for every intent in both themes', () {
      for (final intent in SpIntent.values) {
        expect(SpPalette.of(intent, false), isA<SpAccent>());
        expect(SpPalette.of(intent, true), isA<SpAccent>());
      }
    });

    test('light and dark accents differ for each intent', () {
      for (final intent in SpIntent.values) {
        final light = SpPalette.of(intent, false);
        final dark = SpPalette.of(intent, true);
        expect(light.base, isNot(equals(dark.base)),
            reason: '$intent should adapt its base color to theme');
      }
    });

    test('gradient getter produces a two-stop diagonal gradient', () {
      final accent = SpPalette.of(SpIntent.success, false);
      expect(accent.gradient.colors, hasLength(2));
      expect(accent.gradient.begin, Alignment.topLeft);
      expect(accent.gradient.end, Alignment.bottomRight);
    });

    test('gradientFrom derives a two-stop gradient from any base color', () {
      final g = SpPalette.gradientFrom(const Color(0xFF3366FF));
      expect(g.colors, hasLength(2));
      expect(g.colors.first, isNot(equals(g.colors.last)));
    });
  });
}
