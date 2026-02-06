import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';

/// Professional dialog color configuration with enhanced palettes
class DialogColorConfig {
  final Color iconColor;
  final Color backgroundColor;
  final Color confirmColor;
  final Color cancelColor;
  final ContentDesignStyle designStyle;
  final Color? borderColor;
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
       buttonColor = isDark ? const Color(0xFF374151) : const Color(0xFF1F2937),
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
        return isDark ? const Color(0xFF1F2937) : Colors.white;
      case ContentDesignStyle.colorHeader:
        return isDark ? const Color(0xFF111827) : const Color(0xFFFAFAFA);
      case ContentDesignStyle.tonal:
        if (iconColor != null) {
          final hsl = HSLColor.fromColor(iconColor);
          return isDark
              ? hsl.withSaturation(0.2).withLightness(0.18).toColor()
              : hsl.withSaturation(0.25).withLightness(0.95).toColor();
        }
        return isDark
            ? const Color(0xFF1F2937).withValues(alpha: 0.98)
            : Colors.white.withValues(alpha: 0.98);
      case ContentDesignStyle.solid:
        return isDark
            ? const Color(0xFF1F2937).withValues(alpha: 0.98)
            : Colors.white.withValues(alpha: 0.98);
    }
  }

  static Color? _computeBorderColor({
    required ContentDesignStyle designStyle,
    required Color? iconColor,
    required ThemeData theme,
    required bool isDark,
  }) {
    if (designStyle == ContentDesignStyle.outlined) {
      final baseColor =
          iconColor ??
          (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary);
      return baseColor.withValues(alpha: isDark ? 0.5 : 0.3);
    }
    // leftAccent uses a left bar, not full border; tonal has no border
    return null;
  }

  static Color _computeTitleColor({
    required ContentDesignStyle designStyle,
    required bool isDark,
  }) {
    switch (designStyle) {
      case ContentDesignStyle.outlined:
      case ContentDesignStyle.colorHeader:
      case ContentDesignStyle.leftAccent:
      case ContentDesignStyle.tonal:
      case ContentDesignStyle.solid:
        return isDark ? const Color(0xFFF9FAFB) : const Color(0xFF111827);
    }
  }

  static Color _computeMessageColor({
    required ContentDesignStyle designStyle,
    required bool isDark,
  }) {
    switch (designStyle) {
      case ContentDesignStyle.outlined:
      case ContentDesignStyle.colorHeader:
      case ContentDesignStyle.leftAccent:
      case ContentDesignStyle.tonal:
      case ContentDesignStyle.solid:
        return isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    }
  }

  static Color _computeHeaderColor({
    required Color iconColor,
    required bool isDark,
  }) {
    final hsl = HSLColor.fromColor(iconColor);
    if (isDark) {
      // Darker, more saturated header for dark mode
      return hsl.withSaturation(0.4).withLightness(0.15).toColor();
    }
    // Light, pastel header for light mode
    return hsl.withSaturation(0.35).withLightness(0.94).toColor();
  }

  static Color _computeHeaderColorEnd({
    required Color iconColor,
    required bool isDark,
  }) {
    final hsl = HSLColor.fromColor(iconColor);
    if (isDark) {
      return hsl.withSaturation(0.3).withLightness(0.08).toColor();
    }
    return hsl.withSaturation(0.2).withLightness(0.98).toColor();
  }
}
