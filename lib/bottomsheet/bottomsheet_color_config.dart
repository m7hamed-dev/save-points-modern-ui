import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';

/// Professional bottom sheet color configuration with enhanced palettes
class BottomsheetColorConfig {
  final Color backgroundColor;
  final Color handleColor;
  final Color textColor;
  final Color subtitleColor;
  final Color iconColor;
  final ContentDesignStyle designStyle;
  final Color? borderColor;
  final Color headerColor;
  final Color headerColorEnd;
  final Color buttonColor;
  final Color buttonTextColor;
  final Color iconBackgroundColor;

  BottomsheetColorConfig({
    required ThemeData theme,
    required bool isDark,
    Color? background,
    Color? handle,
    Color? text,
    Color? icon,
    ContentDesignStyle? designStyle,
  }) : designStyle = designStyle ?? ContentDesignStyle.solid,
       backgroundColor = _computeBackgroundColor(
         background: background,
         designStyle: designStyle ?? ContentDesignStyle.solid,
         isDark: isDark,
       ),
       handleColor =
           handle ??
           (isDark
               ? Colors.white.withValues(alpha: 0.25)
               : Colors.black.withValues(alpha: 0.15)),
       textColor = _computeTextColor(
         text: text,
         designStyle: designStyle ?? ContentDesignStyle.solid,
         isDark: isDark,
       ),
       subtitleColor = isDark
           ? const Color(0xFF9CA3AF)
           : const Color(0xFF6B7280),
       iconColor = _computeIconColor(
         icon: icon,
         designStyle: designStyle ?? ContentDesignStyle.solid,
         theme: theme,
         isDark: isDark,
       ),
       borderColor = _computeBorderColor(
         designStyle: designStyle ?? ContentDesignStyle.solid,
         icon: icon,
         theme: theme,
         isDark: isDark,
       ),
       headerColor = _computeHeaderColor(
         icon:
             icon ??
             (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
         isDark: isDark,
       ),
       headerColorEnd = _computeHeaderColorEnd(
         icon:
             icon ??
             (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
         isDark: isDark,
       ),
       buttonColor = isDark ? const Color(0xFF374151) : const Color(0xFF1F2937),
       buttonTextColor = Colors.white,
       iconBackgroundColor = isDark ? const Color(0xFF1F2937) : Colors.white;

  static Color _computeBackgroundColor({
    required Color? background,
    required ContentDesignStyle designStyle,
    required bool isDark,
  }) {
    if (background != null) return background;

    switch (designStyle) {
      case ContentDesignStyle.outlined:
        return isDark ? const Color(0xFF1F2937) : Colors.white;
      case ContentDesignStyle.colorHeader:
        return isDark ? const Color(0xFF111827) : const Color(0xFFFAFAFA);
      case ContentDesignStyle.solid:
        return isDark ? const Color(0xFF1F2937) : Colors.white;
    }
  }

  static Color _computeTextColor({
    required Color? text,
    required ContentDesignStyle designStyle,
    required bool isDark,
  }) {
    if (text != null) return text;

    switch (designStyle) {
      case ContentDesignStyle.outlined:
      case ContentDesignStyle.colorHeader:
      case ContentDesignStyle.solid:
        return isDark ? const Color(0xFFF9FAFB) : const Color(0xFF111827);
    }
  }

  static Color _computeIconColor({
    required Color? icon,
    required ContentDesignStyle designStyle,
    required ThemeData theme,
    required bool isDark,
  }) {
    if (icon != null) return icon;

    switch (designStyle) {
      case ContentDesignStyle.outlined:
      case ContentDesignStyle.colorHeader:
        return isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary;
      case ContentDesignStyle.solid:
        return isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    }
  }

  static Color? _computeBorderColor({
    required ContentDesignStyle designStyle,
    required Color? icon,
    required ThemeData theme,
    required bool isDark,
  }) {
    if (designStyle == ContentDesignStyle.outlined) {
      final baseColor =
          icon ??
          (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary);
      return baseColor.withValues(alpha: isDark ? 0.4 : 0.25);
    }
    return null;
  }

  static Color _computeHeaderColor({
    required Color icon,
    required bool isDark,
  }) {
    final hsl = HSLColor.fromColor(icon);
    if (isDark) {
      return hsl.withSaturation(0.4).withLightness(0.15).toColor();
    }
    return hsl.withSaturation(0.35).withLightness(0.94).toColor();
  }

  static Color _computeHeaderColorEnd({
    required Color icon,
    required bool isDark,
  }) {
    final hsl = HSLColor.fromColor(icon);
    if (isDark) {
      return hsl.withSaturation(0.3).withLightness(0.08).toColor();
    }
    return hsl.withSaturation(0.2).withLightness(0.98).toColor();
  }
}
