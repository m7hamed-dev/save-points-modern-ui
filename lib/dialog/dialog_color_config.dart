import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';

/// Professional dialog color configuration with enhanced palettes
class DialogColorConfig {
  final Color iconColor;
  final Color backgroundColor;
  final Color confirmColor;
  final Color cancelColor;
  final ContentDesignStyle designStyle;
  final Color? borderColor;

  /// Stroke width for [borderColor] (null = let the container choose).
  final double? borderWidth;
  final Color titleColor;
  final Color messageColor;
  final Color headerColor;
  final Color headerColorEnd;
  final Color buttonColor;
  final Color buttonTextColor;
  final Color iconBackgroundColor;

  DialogColorConfig({
    required ThemeData theme,
    required bool isDark,
    Color? iconColor,
    Color? backgroundColor,
    Color? confirmButtonColor,
    Color? cancelButtonColor,
    ContentDesignStyle? designStyle,
  }) : designStyle = designStyle ?? ContentDesignStyle.solid,
       iconColor =
           iconColor ??
           (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
       backgroundColor = _computeBackgroundColor(
         backgroundColor: backgroundColor,
         designStyle: designStyle ?? ContentDesignStyle.solid,
         isDark: isDark,
         iconColor: iconColor ??
             (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
       ),
       confirmColor =
           confirmButtonColor ??
           (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
       cancelColor =
           cancelButtonColor ??
           (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
       borderColor = _computeBorderColor(
         designStyle: designStyle ?? ContentDesignStyle.solid,
         iconColor: iconColor,
         theme: theme,
         isDark: isDark,
       ),
       borderWidth = _computeBorderWidth(designStyle ?? ContentDesignStyle.solid),
       titleColor = _computeTitleColor(
         designStyle: designStyle ?? ContentDesignStyle.solid,
         isDark: isDark,
       ),
       messageColor = _computeMessageColor(
         designStyle: designStyle ?? ContentDesignStyle.solid,
         isDark: isDark,
       ),
       headerColor = _computeHeaderColor(
         iconColor:
             iconColor ??
             (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
         isDark: isDark,
       ),
       headerColorEnd = _computeHeaderColorEnd(
         iconColor:
             iconColor ??
             (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
         isDark: isDark,
       ),
       buttonColor =
           iconColor ??
           (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
       buttonTextColor = Colors.white,
       iconBackgroundColor = isDark ? const Color(0xFF1F2937) : Colors.white;

  static Color _computeBackgroundColor({
    required Color? backgroundColor,
    required ContentDesignStyle designStyle,
    required bool isDark,
    Color? iconColor,
  }) {
    if (backgroundColor != null) return backgroundColor;

    switch (designStyle) {
      case ContentDesignStyle.outlined:
      case ContentDesignStyle.leftAccent:
      case ContentDesignStyle.solid:
      case ContentDesignStyle.minimal:
        return SpSurface.background(isDark);
      case ContentDesignStyle.colorHeader:
        return SpSurface.elevated(isDark);
      case ContentDesignStyle.glass:
        return SpSurface.glassFill(isDark);
      case ContentDesignStyle.neon:
        return SpSurface.neonSurface(isDark);
      case ContentDesignStyle.tonal:
        return iconColor != null
            ? SpPalette.tonalFrom(iconColor, isDark)
            : SpSurface.background(isDark);
    }
  }

  static Color? _computeBorderColor({
    required ContentDesignStyle designStyle,
    required Color? iconColor,
    required ThemeData theme,
    required bool isDark,
  }) {
    final baseColor =
        iconColor ??
        (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary);
    switch (designStyle) {
      case ContentDesignStyle.outlined:
        return baseColor.withValues(alpha: isDark ? 0.5 : 0.3);
      case ContentDesignStyle.neon:
        return baseColor;
      case ContentDesignStyle.glass:
        return SpSurface.glassBorder(isDark);
      case ContentDesignStyle.minimal:
        return SpSurface.hairline(isDark);
      case ContentDesignStyle.solid:
      case ContentDesignStyle.tonal:
      case ContentDesignStyle.colorHeader:
      case ContentDesignStyle.leftAccent:
        // leftAccent uses a left bar; tonal/solid/colorHeader have no border.
        return null;
    }
  }

  static double? _computeBorderWidth(ContentDesignStyle designStyle) {
    switch (designStyle) {
      case ContentDesignStyle.outlined:
      case ContentDesignStyle.neon:
        return 2.0;
      case ContentDesignStyle.glass:
        return 1.5;
      case ContentDesignStyle.minimal:
        return 1.0;
      case ContentDesignStyle.solid:
      case ContentDesignStyle.tonal:
      case ContentDesignStyle.colorHeader:
      case ContentDesignStyle.leftAccent:
        return null;
    }
  }

  static Color _computeTitleColor({
    required ContentDesignStyle designStyle,
    required bool isDark,
  }) =>
      designStyle == ContentDesignStyle.neon
          ? SpSurface.neonText
          : SpSurface.onSurface(isDark);

  static Color _computeMessageColor({
    required ContentDesignStyle designStyle,
    required bool isDark,
  }) =>
      designStyle == ContentDesignStyle.neon
          ? Colors.white.withValues(alpha: 0.7)
          : SpSurface.onSurfaceMuted(isDark);

  /// Bold gradient header band — the vivid accent gradient derived from the
  /// icon color. White header content sits on top of this.
  static Color _computeHeaderColor({
    required Color iconColor,
    required bool isDark,
  }) =>
      SpPalette.gradientFrom(iconColor).colors.first;

  static Color _computeHeaderColorEnd({
    required Color iconColor,
    required bool isDark,
  }) =>
      SpPalette.gradientFrom(iconColor).colors.last;
}
