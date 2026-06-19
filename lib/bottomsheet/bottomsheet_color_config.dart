import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';

/// Professional bottom sheet color configuration with enhanced palettes
class BottomsheetColorConfig {
  final Color backgroundColor;
  final Color handleColor;
  final Color textColor;
  final Color subtitleColor;
  final Color iconColor;
  final ContentDesignStyle designStyle;
  final Color? borderColor;

  /// Stroke width for [borderColor] (null = let the container choose).
  final double? borderWidth;
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
  }) : designStyle = designStyle ?? ContentDesignStyle.colorHeader,
       backgroundColor = _computeBackgroundColor(
         background: background,
         designStyle: designStyle ?? ContentDesignStyle.colorHeader,
         isDark: isDark,
       ),
       handleColor = handle ?? SpSurface.handle(isDark),
       textColor = _computeTextColor(
         text: text,
         designStyle: designStyle ?? ContentDesignStyle.colorHeader,
         isDark: isDark,
       ),
       subtitleColor = SpSurface.onSurfaceMuted(isDark),
       iconColor = _computeIconColor(
         icon: icon,
         designStyle: designStyle ?? ContentDesignStyle.colorHeader,
         theme: theme,
         isDark: isDark,
       ),
       borderColor = _computeBorderColor(
         designStyle: designStyle ?? .colorHeader,
         icon: icon,
         theme: theme,
         isDark: isDark,
       ),
       borderWidth = _computeBorderWidth(designStyle ?? .colorHeader),
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
       buttonColor =
           icon ??
           (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
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
      case ContentDesignStyle.leftAccent:
      case ContentDesignStyle.tonal:
      case ContentDesignStyle.solid:
      case ContentDesignStyle.minimal:
        return SpSurface.background(isDark);
      case ContentDesignStyle.colorHeader:
        return SpSurface.elevated(isDark);
      case ContentDesignStyle.glass:
        return SpSurface.glassFill(isDark);
      case ContentDesignStyle.neon:
        return SpSurface.neonSurface(isDark);
    }
  }

  static Color _computeTextColor({
    required Color? text,
    required ContentDesignStyle designStyle,
    required bool isDark,
  }) {
    if (text != null) return text;
    return designStyle == ContentDesignStyle.neon
        ? SpSurface.neonText
        : SpSurface.onSurface(isDark);
  }

  static Color _computeIconColor({
    required Color? icon,
    required ContentDesignStyle designStyle,
    required ThemeData theme,
    required bool isDark,
  }) {
    if (icon != null) return icon;

    switch (designStyle) {
      case .outlined:
      case .colorHeader:
      case .leftAccent:
      case .tonal:
      case .glass:
      case .neon:
      case .minimal:
        return isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary;
      case .solid:
        return isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    }
  }

  static Color? _computeBorderColor({
    required ContentDesignStyle designStyle,
    required Color? icon,
    required ThemeData theme,
    required bool isDark,
  }) {
    final baseColor =
        icon ?? (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary);
    switch (designStyle) {
      case ContentDesignStyle.outlined:
        return baseColor.withValues(alpha: isDark ? 0.4 : 0.25);
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
        // leftAccent uses a left bar; tonal/solid have no border.
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

  /// Bold gradient header band — the vivid accent gradient derived from the
  /// icon color. White header content (handle, close, icon chip) sits on top.
  static Color _computeHeaderColor({
    required Color icon,
    required bool isDark,
  }) =>
      SpPalette.gradientFrom(icon).colors.first;

  static Color _computeHeaderColorEnd({
    required Color icon,
    required bool isDark,
  }) =>
      SpPalette.gradientFrom(icon).colors.last;
}
