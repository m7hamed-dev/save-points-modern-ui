import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';

/// Bottom sheet color configuration
class BottomsheetColorConfig {
  final Color backgroundColor;
  final Color handleColor;
  final Color textColor;
  final Color iconColor;
  final ContentDesignStyle designStyle;
  final Color? borderColor;
  final Color headerColor;
  final Color buttonColor;
  final Color buttonTextColor;

  BottomsheetColorConfig({
    required ThemeData theme,
    required bool isDark,
    Color? background,
    Color? handle,
    Color? text,
    Color? icon,
    ContentDesignStyle? designStyle,
  })  : designStyle = designStyle ?? ContentDesignStyle.solid,
        backgroundColor = _computeBackgroundColor(
          background: background,
          designStyle: designStyle ?? ContentDesignStyle.solid,
          isDark: isDark,
        ),
        handleColor =
            handle ??
            (isDark
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.2)),
        textColor = _computeTextColor(
          text: text,
          designStyle: designStyle ?? ContentDesignStyle.solid,
          isDark: isDark,
        ),
        iconColor = _computeIconColor(
          icon: icon,
          designStyle: designStyle ?? ContentDesignStyle.solid,
          theme: theme,
          isDark: isDark,
        ),
        borderColor =
            (designStyle ?? ContentDesignStyle.solid) == ContentDesignStyle.outlined
                ? theme.colorScheme.primary
                : null,
        headerColor = _computeHeaderColor(
          icon: icon ?? (isDark ? Colors.white70 : theme.colorScheme.primary),
        ),
        buttonColor = isDark ? Colors.grey[800]! : const Color(0xFF2D2D2D),
        buttonTextColor = Colors.white;

  static Color _computeBackgroundColor({
    required Color? background,
    required ContentDesignStyle designStyle,
    required bool isDark,
  }) {
    if (background != null) return background;

    switch (designStyle) {
      case ContentDesignStyle.outlined:
      case ContentDesignStyle.colorHeader:
        return isDark ? const Color(0xFF1E1E1E) : Colors.white;
      case ContentDesignStyle.solid:
        return isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
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
        return isDark ? Colors.white : Colors.black87;
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
        return theme.colorScheme.primary;
      case ContentDesignStyle.solid:
        return isDark ? Colors.white70 : Colors.black54;
    }
  }

  static Color _computeHeaderColor({required Color icon}) {
    // Create a light pastel version based on icon color
    final hsl = HSLColor.fromColor(icon);
    return hsl.withSaturation(0.3).withLightness(0.92).toColor();
  }
}
