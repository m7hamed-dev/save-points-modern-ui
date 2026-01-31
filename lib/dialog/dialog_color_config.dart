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
        backgroundColor =
            backgroundColor ??
            ((designStyle ?? ContentDesignStyle.solid) == ContentDesignStyle.outlined
                ? Colors.white
                : (isDark
                    ? Colors.grey[900]!.withValues(alpha: 0.95)
                    : Colors.white.withValues(alpha: 0.95))),
        confirmColor =
            confirmButtonColor ??
            (isDark ? Colors.blueAccent : theme.colorScheme.primary),
        cancelColor = cancelButtonColor ?? Colors.grey,
        borderColor = (designStyle ?? ContentDesignStyle.solid) == ContentDesignStyle.outlined
            ? (isDark ? Colors.blueAccent : theme.colorScheme.primary)
            : null,
        titleColor = (designStyle ?? ContentDesignStyle.solid) == ContentDesignStyle.outlined
            ? Colors.grey[900]!
            : (isDark ? Colors.white : Colors.grey[900]!),
        messageColor = (designStyle ?? ContentDesignStyle.solid) == ContentDesignStyle.outlined
            ? Colors.grey[700]!
            : (isDark ? Colors.grey[400]! : Colors.grey[700]!);
}
