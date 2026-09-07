import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/sp_style.dart';

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
  })  : designStyle = designStyle ?? ContentDesignStyle.solid,
        iconColor = iconColor ??
            (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
        backgroundColor = _computeBackgroundColor(
          backgroundColor: backgroundColor,
          designStyle: designStyle ?? ContentDesignStyle.solid,
          isDark: isDark,
          iconColor: iconColor ??
              (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
        ),
        confirmColor = confirmButtonColor ??
            (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
        cancelColor = cancelButtonColor ??
            (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
        borderColor = _computeBorderColor(
          designStyle: designStyle ?? ContentDesignStyle.solid,
          iconColor: iconColor,
          theme: theme,
          isDark: isDark,
        ),
        borderWidth =
            _computeBorderWidth(designStyle ?? ContentDesignStyle.solid),
        titleColor = _computeTitleColor(
          designStyle: designStyle ?? ContentDesignStyle.solid,
          isDark: isDark,
        ),
        messageColor = _computeMessageColor(
          designStyle: designStyle ?? ContentDesignStyle.solid,
          isDark: isDark,
        ),
        headerColor = _computeHeaderColor(
          iconColor: iconColor ??
              (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
          isDark: isDark,
        ),
        headerColorEnd = _computeHeaderColorEnd(
          iconColor: iconColor ??
              (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
          isDark: isDark,
        ),
        buttonColor = iconColor ??
            (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
        buttonTextColor = SpContrast.onColor(
          confirmButtonColor ??
              (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
        ),
        iconBackgroundColor = isDark ? const Color(0xFF1F2937) : Colors.white;

  static Color _computeBackgroundColor({
    required Color? backgroundColor,
    required ContentDesignStyle designStyle,
    required bool isDark,
    Color? iconColor,
  }) =>
      backgroundColor ??
      SpStyles.of(designStyle, iconColor ?? const Color(0xFF6366F1), isDark)
          .fill;

  static Color? _computeBorderColor({
    required ContentDesignStyle designStyle,
    required Color? iconColor,
    required ThemeData theme,
    required bool isDark,
  }) {
    final accent = iconColor ??
        (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary);
    final spec = SpStyles.of(designStyle, accent, isDark);
    return spec.hasBorder ? spec.borderColor : null;
  }

  static double? _computeBorderWidth(ContentDesignStyle designStyle) {
    // Resolved against a placeholder accent: width never depends on colour.
    final spec = SpStyles.of(designStyle, const Color(0xFF6366F1), false);
    return spec.borderWidth > 0 ? spec.borderWidth : null;
  }

  static Color _computeTitleColor({
    required ContentDesignStyle designStyle,
    required bool isDark,
  }) =>
      SpStyles.of(designStyle, const Color(0xFF6366F1), isDark).onSurface;

  static Color _computeMessageColor({
    required ContentDesignStyle designStyle,
    required bool isDark,
  }) =>
      SpStyles.of(designStyle, const Color(0xFF6366F1), isDark).onSurfaceMuted;

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
