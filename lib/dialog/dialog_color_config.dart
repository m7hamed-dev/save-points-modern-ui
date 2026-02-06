import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';

/// Dialog color configuration
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
  final Color buttonColor;
  final Color buttonTextColor;

  DialogColorConfig({
    required ThemeData theme,
    required bool isDark,
    Color? iconColor,
    Color? backgroundColor,
    Color? confirmButtonColor,
    Color? cancelButtonColor,
    ContentDesignStyle? designStyle,
  })  : designStyle = designStyle ?? ContentDesignStyle.solid,
        iconColor =
            iconColor ??
            (isDark ? Colors.blueAccent : theme.colorScheme.primary),
        backgroundColor = _computeBackgroundColor(
          backgroundColor: backgroundColor,
          designStyle: designStyle ?? ContentDesignStyle.solid,
          isDark: isDark,
        ),
        confirmColor =
            confirmButtonColor ??
            (isDark ? Colors.blueAccent : theme.colorScheme.primary),
        cancelColor = cancelButtonColor ?? Colors.grey,
        borderColor = (designStyle ?? ContentDesignStyle.solid) == ContentDesignStyle.outlined
            ? (isDark ? Colors.blueAccent : theme.colorScheme.primary)
            : null,
        titleColor = _computeTitleColor(
          designStyle: designStyle ?? ContentDesignStyle.solid,
          isDark: isDark,
        ),
        messageColor = _computeMessageColor(
          designStyle: designStyle ?? ContentDesignStyle.solid,
          isDark: isDark,
        ),
        headerColor = _computeHeaderColor(
          iconColor: iconColor ?? (isDark ? Colors.blueAccent : theme.colorScheme.primary),
        ),
        buttonColor = isDark ? Colors.grey[800]! : const Color(0xFF2D2D2D),
        buttonTextColor = Colors.white;

  static Color _computeBackgroundColor({
    required Color? backgroundColor,
    required ContentDesignStyle designStyle,
    required bool isDark,
  }) {
    if (backgroundColor != null) return backgroundColor;

    switch (designStyle) {
      case ContentDesignStyle.outlined:
      case ContentDesignStyle.colorHeader:
        return isDark ? Colors.grey[900]! : Colors.white;
      case ContentDesignStyle.solid:
        return isDark
            ? Colors.grey[900]!.withValues(alpha: 0.95)
            : Colors.white.withValues(alpha: 0.95);
    }
  }

  static Color _computeTitleColor({
    required ContentDesignStyle designStyle,
    required bool isDark,
  }) {
    switch (designStyle) {
      case ContentDesignStyle.outlined:
      case ContentDesignStyle.colorHeader:
      case ContentDesignStyle.solid:
        return isDark ? Colors.white : Colors.grey[900]!;
    }
  }

  static Color _computeMessageColor({
    required ContentDesignStyle designStyle,
    required bool isDark,
  }) {
    switch (designStyle) {
      case ContentDesignStyle.outlined:
      case ContentDesignStyle.colorHeader:
      case ContentDesignStyle.solid:
        return isDark ? Colors.grey[400]! : Colors.grey[700]!;
    }
  }

  static Color _computeHeaderColor({required Color iconColor}) {
    // Create a light pastel version based on icon color
    final hsl = HSLColor.fromColor(iconColor);
    return hsl.withSaturation(0.3).withLightness(0.92).toColor();
  }
}
