/// Bold & expressive design tokens — the single source of truth shared by the
/// snackbar, dialog and bottom sheet so they all speak one visual language.
///
/// The language is *bold & expressive*: vivid intent colors, gradient surfaces,
/// large display typography, generous rounding and layered colored-glow
/// elevation. Every component reads its radius, spacing, type, color and shadow
/// from here instead of hard-coding values, which is what makes the family feel
/// like one design system rather than three.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Semantic intent shared across all components.
enum SpIntent { success, error, warning, info, neutral }

/// Unified corner-radius scale. Bold & expressive leans large.
abstract final class SpRadius {
  /// Chips, small controls.
  static const double sm = 14.0;

  /// Buttons, inner cards.
  static const double md = 18.0;

  /// Snackbars, sheets bottom corners.
  static const double lg = 24.0;

  /// Dialogs, the hero surface rounding.
  static const double xl = 28.0;

  /// Top corners of a bottom sheet.
  static const double sheetTop = 28.0;

  /// Fully rounded (pills, handles, icon chips).
  static const double pill = 999.0;
}

/// Unified 4-based spacing scale.
abstract final class SpSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
}

/// Unified display-leaning type scale.
///
/// Sizes/weights/tracking are tuned for an expressive, confident voice:
/// tight negative tracking on large titles, comfortable line-height on body.
abstract final class SpType {
  // Hero display title (dialog / sheet / colorHeader card).
  static const double displaySize = 24.0;
  static const FontWeight displayWeight = FontWeight.w800;
  static const double displayTracking = -0.4;
  static const double displayHeight = 1.15;

  // Section / compact title (snackbar).
  static const double titleSize = 17.0;
  static const FontWeight titleWeight = FontWeight.w700;
  static const double titleTracking = -0.2;
  static const double titleHeight = 1.25;

  // Body / supporting text.
  static const double bodySize = 15.0;
  static const FontWeight bodyWeight = FontWeight.w500;
  static const double bodyTracking = 0.0;
  static const double bodyHeight = 1.45;

  // Action labels.
  static const double labelSize = 15.0;
  static const FontWeight labelWeight = FontWeight.w700;
  static const double labelTracking = 0.2;
}

/// Spring-flavoured motion. Bold & expressive uses overshoot on entrance.
abstract final class SpMotion {
  static const Duration fast = Duration(milliseconds: 220);
  static const Duration medium = Duration(milliseconds: 340);
  static const Duration slow = Duration(milliseconds: 460);

  /// Confident overshoot for surfaces entering.
  static const Curve enter = Curves.easeOutBack;

  /// Crisp, quick exit.
  static const Curve exit = Curves.easeInCubic;

  /// Bouncy emphasis for icons/badges.
  static const Curve emphasized = Curves.elasticOut;

  /// Smooth standard easing.
  static const Curve standard = Curves.easeOutCubic;
}

/// Neutral surface + text colors for the content areas of each component.
abstract final class SpSurface {
  static Color background(bool isDark) =>
      isDark ? const Color(0xFF151B26) : Colors.white;

  /// Slightly raised neutral (e.g. colorHeader content area).
  static Color elevated(bool isDark) =>
      isDark ? const Color(0xFF1B2330) : const Color(0xFFFBFCFE);

  static Color onSurface(bool isDark) =>
      isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);

  /// Secondary/body text.
  ///
  /// The light value is deliberately darker than a typical "muted grey": at
  /// slate-500 it measured 3.93:1 on the `tonal` surface, under the 4.5:1
  /// WCAG AA floor for body copy.
  static Color onSurfaceMuted(bool isDark) =>
      isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);

  /// Body text for the translucent `glass` surface.
  ///
  /// Glass composites over whatever is behind the barrier, so it cannot rely
  /// on the usual muted tone — that measured 2.50:1. This trades a little of
  /// the muting for a readable floor.
  static Color onSurfaceMutedOnGlass(bool isDark) =>
      isDark ? const Color(0xFFCBD5E1) : const Color(0xFF1E293B);

  static Color hairline(bool isDark) => isDark
      ? Colors.white.withValues(alpha: 0.08)
      : Colors.black.withValues(alpha: 0.06);

  static Color handle(bool isDark) => isDark
      ? Colors.white.withValues(alpha: 0.28)
      : Colors.black.withValues(alpha: 0.16);

  // ---- glass (frosted) variant ----------------------------------------

  /// Translucent fill that sits in front of a [BackdropFilter] blur.
  ///
  /// Deliberately thin. At the alpha this used to carry the fill was opaque
  /// enough to hide its own blur, so `glass` rendered as a plain white card
  /// and was indistinguishable from `solid` and `minimal`.
  static Color glassFill(bool isDark) => isDark
      ? const Color(0xFF151B26).withValues(alpha: 0.46)
      : Colors.white.withValues(alpha: 0.42);

  /// Hairline highlight border that gives frosted glass its edge.
  static Color glassBorder(bool isDark) => isDark
      ? Colors.white.withValues(alpha: 0.28)
      : Colors.white.withValues(alpha: 0.90);

  /// Blur strength for the glass variant's backdrop.
  static const double glassBlur = 22.0;

  // ---- neon variant ---------------------------------------------------

  /// Deep, near-black surface that makes a neon accent border glow.
  static Color neonSurface(bool isDark) =>
      isDark ? const Color(0xFF0B1020) : const Color(0xFF111827);

  /// Foreground used on the dark neon surface.
  static const Color neonText = Color(0xFFF8FAFC);
  static Color neonTextMuted(Color accent) => accent.withValues(alpha: 0.85);
}

/// The vivid accent + gradient + tonal fill for a single intent.
@immutable
class SpAccent {
  const SpAccent({
    required this.base,
    required this.gradientStart,
    required this.gradientEnd,
    required this.tonalFill,
    required this.onAccent,
  });

  /// The signature solid accent (icon tint, glow, accent bar).
  final Color base;

  /// Bold gradient — used for solid backgrounds, header bands, buttons, chips.
  final Color gradientStart;
  final Color gradientEnd;

  /// Soft tinted background for the tonal variant.
  final Color tonalFill;

  /// Foreground color that sits on top of [base]/gradient.
  final Color onAccent;

  /// Diagonal bold gradient (top-left → bottom-right).
  LinearGradient get gradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [gradientStart, gradientEnd],
      );
}

/// Vivid, expressive palette per intent for light and dark themes.
abstract final class SpPalette {
  static SpAccent of(SpIntent intent, bool isDark) =>
      isDark ? _dark[intent]! : _light[intent]!;

  static const Map<SpIntent, SpAccent> _light = {
    SpIntent.success: SpAccent(
      base: Color(0xFF10B981),
      gradientStart: Color(0xFF34D399),
      gradientEnd: Color(0xFF059669),
      tonalFill: Color(0xFFDCFCE7),
      onAccent: Colors.white,
    ),
    SpIntent.error: SpAccent(
      base: Color(0xFFEF4444),
      gradientStart: Color(0xFFFB7185),
      gradientEnd: Color(0xFFDC2626),
      tonalFill: Color(0xFFFEE2E2),
      onAccent: Colors.white,
    ),
    SpIntent.warning: SpAccent(
      base: Color(0xFFF59E0B),
      gradientStart: Color(0xFFFBBF24),
      gradientEnd: Color(0xFFD97706),
      tonalFill: Color(0xFFFEF3C7),
      onAccent: Colors.white,
    ),
    SpIntent.info: SpAccent(
      base: Color(0xFF6366F1),
      gradientStart: Color(0xFF818CF8),
      gradientEnd: Color(0xFF4F46E5),
      tonalFill: Color(0xFFE0E7FF),
      onAccent: Colors.white,
    ),
    SpIntent.neutral: SpAccent(
      base: Color(0xFF334155),
      gradientStart: Color(0xFF475569),
      gradientEnd: Color(0xFF1E293B),
      tonalFill: Color(0xFFF1F5F9),
      onAccent: Colors.white,
    ),
  };

  static const Map<SpIntent, SpAccent> _dark = {
    SpIntent.success: SpAccent(
      base: Color(0xFF34D399),
      gradientStart: Color(0xFF10B981),
      gradientEnd: Color(0xFF047857),
      tonalFill: Color(0xFF064E3B),
      onAccent: Colors.white,
    ),
    SpIntent.error: SpAccent(
      base: Color(0xFFF87171),
      gradientStart: Color(0xFFEF4444),
      gradientEnd: Color(0xFFB91C1C),
      tonalFill: Color(0xFF7F1D1D),
      onAccent: Colors.white,
    ),
    SpIntent.warning: SpAccent(
      base: Color(0xFFFBBF24),
      gradientStart: Color(0xFFF59E0B),
      gradientEnd: Color(0xFFB45309),
      tonalFill: Color(0xFF78350F),
      onAccent: Colors.white,
    ),
    SpIntent.info: SpAccent(
      base: Color(0xFF818CF8),
      gradientStart: Color(0xFF6366F1),
      gradientEnd: Color(0xFF4338CA),
      tonalFill: Color(0xFF312E81),
      onAccent: Colors.white,
    ),
    SpIntent.neutral: SpAccent(
      base: Color(0xFF94A3B8),
      gradientStart: Color(0xFF475569),
      gradientEnd: Color(0xFF1E293B),
      tonalFill: Color(0xFF1E293B),
      onAccent: Colors.white,
    ),
  };

  /// Build a vivid two-stop gradient from any base color (for caller-supplied
  /// custom colors, e.g. a dialog driven by `colorScheme.primary`).
  static LinearGradient gradientFrom(Color base) {
    final hsl = HSLColor.fromColor(base);
    final start = hsl
        .withLightness((hsl.lightness + 0.08).clamp(0.0, 1.0))
        .withSaturation((hsl.saturation + 0.05).clamp(0.0, 1.0))
        .toColor();
    final end = hsl
        .withLightness((hsl.lightness - 0.12).clamp(0.0, 1.0))
        .withSaturation((hsl.saturation + 0.08).clamp(0.0, 1.0))
        .toColor();
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [start, end],
    );
  }

  /// Soft tonal fill derived from any base color.
  static Color tonalFrom(Color base, bool isDark) {
    final hsl = HSLColor.fromColor(base);
    return isDark
        ? hsl.withSaturation(0.45).withLightness(0.16).toColor()
        : hsl.withSaturation(0.55).withLightness(0.94).toColor();
  }
}

/// Foreground colours chosen by measured contrast rather than by assumption.
abstract final class SpContrast {
  /// Relative luminance per WCAG 2.1.
  static double luminance(Color c) {
    double channel(double v) => v <= 0.03928
        ? v / 12.92
        : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * channel(c.r) +
        0.7152 * channel(c.g) +
        0.0722 * channel(c.b);
  }

  /// Contrast ratio between two opaque colours.
  static double ratio(Color a, Color b) {
    final la = luminance(a), lb = luminance(b);
    return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
  }

  /// The label colour that reads best on [background].
  ///
  /// White-on-accent is the usual house style, but it fails outright on the
  /// lighter accents this package uses in dark mode — white on the dark-theme
  /// blue measured 2.54:1. Picking by measurement also keeps caller-supplied
  /// button colours legible.
  static Color onColor(Color background) {
    const dark = Color(0xFF0B1220);
    return ratio(Colors.white, background) >= ratio(dark, background)
        ? Colors.white
        : dark;
  }
}

/// Layered, colored-glow elevation — the signature of the bold look.
///
/// Instead of flat black drop shadows, surfaces cast a soft ambient black
/// shadow *and* a tinted glow in their own accent color, which reads as
/// premium and vibrant.
abstract final class SpShadows {
  /// Elevation with an accent glow. [level] 0..1 scales intensity.
  static List<BoxShadow> glow({
    required Color color,
    required bool isDark,
    double level = 1.0,
    Offset direction = const Offset(0, 1),
  }) {
    final ambient = isDark ? 0.45 : 0.18;
    // The halo is the whole point of this elevation; at 0.22 over a light
    // background it was invisible, which flattened `solid` into `minimal`.
    final glowAlpha = isDark ? 0.34 : 0.34;
    final dy = direction.dy;
    final dx = direction.dx;
    return [
      // Tight contact shadow.
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.06 * level),
        offset: Offset(dx * 1, dy * 2),
        blurRadius: 4 * level,
      ),
      // Ambient depth.
      BoxShadow(
        color: Colors.black.withValues(alpha: ambient * 0.5 * level),
        offset: Offset(dx * 8, dy * 12),
        blurRadius: 28 * level,
        spreadRadius: -6 * level,
      ),
      // Colored glow halo.
      BoxShadow(
        color: color.withValues(alpha: glowAlpha * level),
        offset: Offset(dx * 4, dy * 16),
        blurRadius: 36 * level,
        spreadRadius: -10 * level,
      ),
    ];
  }

  /// Neutral ambient elevation (no color tint) for content surfaces.
  static List<BoxShadow> ambient({
    required bool isDark,
    double level = 1.0,
    Offset direction = const Offset(0, 1),
  }) {
    final dy = direction.dy;
    final dx = direction.dx;
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: (isDark ? 0.20 : 0.05) * level),
        offset: Offset(dx * 1, dy * 2),
        blurRadius: 6 * level,
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: (isDark ? 0.35 : 0.08) * level),
        offset: Offset(dx * 8, dy * 16),
        blurRadius: 32 * level,
        spreadRadius: -8 * level,
      ),
    ];
  }

  /// Intense double-glow halo for the neon variant — a tight inner ring plus a
  /// wide diffuse bloom in the accent color.
  static List<BoxShadow> neon({
    required Color color,
    Offset direction = const Offset(0, 1),
  }) {
    final dy = direction.dy;
    final dx = direction.dx;
    return [
      // Tight inner ring, right up against the border.
      BoxShadow(
        color: color.withValues(alpha: 0.75),
        blurRadius: 14,
      ),
      // Wide diffuse bloom — this is what reads as "neon" from a distance.
      BoxShadow(
        color: color.withValues(alpha: 0.45),
        offset: Offset(dx * 2, dy * 8),
        blurRadius: 48,
        spreadRadius: 2,
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.4),
        offset: Offset(dx * 6, dy * 14),
        blurRadius: 28,
        spreadRadius: -10,
      ),
    ];
  }

  /// Flat — no elevation (the minimal variant).
  static const List<BoxShadow> flat = <BoxShadow>[];
}
