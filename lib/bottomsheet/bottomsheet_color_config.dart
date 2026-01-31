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

  BottomsheetColorConfig({
    required ThemeData theme,
    required bool isDark,
    Color? background,
    Color? handle,
    Color? text,
    Color? icon,
    ContentDesignStyle? designStyle,
  })  : designStyle = designStyle ?? ContentDesignStyle.solid,
        backgroundColor =
            background ??
            ((designStyle ?? ContentDesignStyle.solid) == ContentDesignStyle.outlined
                ? (isDark ? const Color(0xFF1E1E1E) : Colors.white)
                : (isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF))),
        handleColor =
            handle ??
            (isDark
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.2)),
        textColor =
            text ??
            ((designStyle ?? ContentDesignStyle.solid) == ContentDesignStyle.outlined
                ? (isDark ? Colors.white : Colors.black87)
                : (isDark ? Colors.white : Colors.black87)),
        iconColor =
            icon ??
            ((designStyle ?? ContentDesignStyle.solid) == ContentDesignStyle.outlined
                ? (theme.colorScheme.primary)
                : (isDark ? Colors.white70 : Colors.black54)),
        borderColor =
            (designStyle ?? ContentDesignStyle.solid) == ContentDesignStyle.outlined
                ? theme.colorScheme.primary
                : null;
}
