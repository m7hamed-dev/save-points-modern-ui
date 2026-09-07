import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';

/// Everything a [ContentDesignStyle] decides about a surface, resolved once.
///
/// Dialogs, snackbars and bottom sheets used to each answer these questions
/// themselves — 64 style branches spread across three colour-config files and
/// three shadow files. They drifted: the same `colorHeader` rendered with a
/// 110dp header band on a dialog and 90dp on a snackbar, a 14dp close chip
/// here and 12dp there. One resolver means a style looks like itself wherever
/// it is used, and a new style is written once instead of three times.
@immutable
class SpStyleSpec {
  const SpStyleSpec({
    required this.fill,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.shadows,
    this.fillGradient,
    this.borderColor,
    this.borderWidth = 0,
    this.borderGradient,
    this.radiusScale = 1.0,
    this.blurSigma = 0,
  });

  /// Opaque or translucent surface colour.
  final Color fill;

  /// Optional wash painted across the surface instead of a flat [fill].
  final Gradient? fillGradient;

  /// Title / primary text that sits on this surface.
  final Color onSurface;

  /// Body / secondary text.
  final Color onSurfaceMuted;

  final List<BoxShadow> shadows;

  final Color? borderColor;
  final double borderWidth;

  /// A stroke that cannot be expressed as a [Border]; the container paints it
  /// as an outer layer behind the surface.
  final Gradient? borderGradient;

  /// Multiplies the component's own corner radius. Brutalism wants tight
  /// corners, clay wants generous ones.
  final double radiusScale;

  /// Backdrop blur behind the surface; 0 means none.
  final double blurSigma;

  bool get hasBorder => borderColor != null && borderWidth > 0;
}

/// Resolves a [ContentDesignStyle] into a concrete [SpStyleSpec].
abstract final class SpStyles {
  /// [accent] is the intent colour (success green, error red, the caller's
  /// own colour…). [surfaceOverride] wins over the style's own fill.
  static SpStyleSpec of(
    ContentDesignStyle style,
    Color accent,
    bool isDark, {
    Color? surfaceOverride,
  }) {
    final spec = _resolve(style, accent, isDark);
    if (surfaceOverride == null) return spec;
    return SpStyleSpec(
      fill: surfaceOverride,

      onSurface: spec.onSurface,
      onSurfaceMuted: spec.onSurfaceMuted,
      shadows: spec.shadows,
      borderColor: spec.borderColor,
      borderWidth: spec.borderWidth,
      borderGradient: spec.borderGradient,
      radiusScale: spec.radiusScale,
      blurSigma: spec.blurSigma,
    );
  }

  static SpStyleSpec _resolve(
    ContentDesignStyle style,
    Color accent,
    bool isDark,
  ) {
    final surface = SpSurface.background(isDark);
    final ink = SpSurface.onSurface(isDark);
    final inkMuted = SpSurface.onSurfaceMuted(isDark);

    switch (style) {
      case ContentDesignStyle.solid:
        return SpStyleSpec(
          fill: surface,
          onSurface: ink,
          onSurfaceMuted: inkMuted,
          shadows: SpShadows.glow(color: accent, isDark: isDark),
        );

      case ContentDesignStyle.outlined:
        return SpStyleSpec(
          fill: surface,
          onSurface: ink,
          onSurfaceMuted: inkMuted,
          borderColor: accent.withValues(alpha: isDark ? 0.62 : 0.55),
          borderWidth: 2,
          shadows: SpShadows.glow(color: accent, isDark: isDark, level: 0.7),
        );

      case ContentDesignStyle.colorHeader:
        return SpStyleSpec(
          fill: SpSurface.elevated(isDark),
          onSurface: ink,
          onSurfaceMuted: inkMuted,
          shadows: SpShadows.glow(color: accent, isDark: isDark),
        );

      case ContentDesignStyle.leftAccent:
        return SpStyleSpec(
          fill: surface,
          onSurface: ink,
          onSurfaceMuted: inkMuted,
          shadows: SpShadows.glow(color: accent, isDark: isDark, level: 0.7),
        );

      case ContentDesignStyle.tonal:
        return SpStyleSpec(
          fill: SpPalette.tonalFrom(accent, isDark),
          onSurface: ink,
          onSurfaceMuted: inkMuted,
          shadows: SpShadows.glow(color: accent, isDark: isDark, level: 0.85),
        );

      case ContentDesignStyle.glass:
        return SpStyleSpec(
          fill: SpSurface.glassFill(isDark),
          onSurface: ink,
          onSurfaceMuted: SpSurface.onSurfaceMutedOnGlass(isDark),
          borderColor: SpSurface.glassBorder(isDark),
          borderWidth: 1.5,
          blurSigma: SpSurface.glassBlur,
          shadows: SpShadows.glow(color: accent, isDark: isDark, level: 0.85),
        );

      case ContentDesignStyle.neon:
        return SpStyleSpec(
          fill: SpSurface.neonSurface(isDark),
          onSurface: SpSurface.neonText,
          onSurfaceMuted: Colors.white.withValues(alpha: 0.7),
          borderColor: accent,
          borderWidth: 2,
          shadows: SpShadows.neon(color: accent),
        );

      case ContentDesignStyle.minimal:
        return SpStyleSpec(
          fill: surface,
          onSurface: ink,
          onSurfaceMuted: inkMuted,
          borderColor: SpSurface.hairline(isDark),
          borderWidth: 1,
          shadows: SpShadows.flat,
        );

      // ---- new -------------------------------------------------------

      case ContentDesignStyle.brutalist:
        // Flat punchy fill, a hard ink border and an offset shadow with no
        // blur at all — the point is that nothing is soft.
        return SpStyleSpec(
          fill: SpPalette.tonalFrom(accent, isDark),
          onSurface: isDark ? Colors.white : const Color(0xFF0B1220),
          onSurfaceMuted: isDark
              ? Colors.white.withValues(alpha: 0.78)
              : const Color(0xFF1E293B),
          borderColor: isDark ? Colors.white : const Color(0xFF0B1220),
          borderWidth: 3,
          radiusScale: 0.18,
          shadows: [
            // No blur at all: the shadow is a solid displaced copy of the
            // shape, which is the whole grammar of the style.
            BoxShadow(
              color: isDark ? Colors.white : const Color(0xFF0B1220),
              offset: const Offset(7, 7),
            ),
          ],
        );

      case ContentDesignStyle.gradientBorder:
        return SpStyleSpec(
          fill: surface,
          onSurface: ink,
          onSurfaceMuted: inkMuted,
          borderGradient: SpPalette.gradientFrom(accent),
          borderWidth: 3.5,
          shadows: SpShadows.glow(color: accent, isDark: isDark, level: 0.8),
        );

      case ContentDesignStyle.aurora:
        // A wash of the accent bleeding across the surface rather than a flat
        // tint: three stops, so the light looks like it has a direction.
        final g = SpPalette.gradientFrom(accent);
        return SpStyleSpec(
          fill: surface,
          fillGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              g.colors.first.withValues(alpha: isDark ? 0.42 : 0.26),
              surface.withValues(alpha: isDark ? 0.92 : 0.96),
              g.colors.last.withValues(alpha: isDark ? 0.34 : 0.20),
            ],
            stops: const [0.0, 0.55, 1.0],
          ),
          onSurface: ink,
          onSurfaceMuted: inkMuted,
          borderColor: accent.withValues(alpha: isDark ? 0.30 : 0.22),
          borderWidth: 1,
          shadows: SpShadows.glow(color: accent, isDark: isDark, level: 0.9),
        );

      case ContentDesignStyle.soft:
        // Claymorphism: light from the top-left, so a pale highlight above and
        // a tinted shadow below, on a pastel fill with generous rounding.
        final clay = SpPalette.tonalFrom(accent, isDark);
        return SpStyleSpec(
          fill: clay,
          onSurface: ink,
          onSurfaceMuted: inkMuted,
          radiusScale: 1.5,
          shadows: [
            // Light from the top-left: a pale rim above, a saturated pool of
            // the accent below. That pairing is what reads as moulded.
            BoxShadow(
              color: Colors.white.withValues(alpha: isDark ? 0.10 : 0.95),
              offset: const Offset(-8, -8),
              blurRadius: 18,
              spreadRadius: -2,
            ),
            BoxShadow(
              color: accent.withValues(alpha: isDark ? 0.48 : 0.42),
              offset: const Offset(10, 14),
              blurRadius: 30,
              spreadRadius: -6,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.40 : 0.10),
              offset: const Offset(2, 8),
              blurRadius: 16,
              spreadRadius: -4,
            ),
          ],
        );
    }
  }
}
