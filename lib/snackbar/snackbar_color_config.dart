import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_config.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_enums.dart';

/// Bold & expressive snackbar colors, driven by the shared [SpPalette] tokens.
///
/// The default `solid` style is a *vivid gradient* card with white content and
/// a same-hue colored glow; the other styles (outlined / tonal / leftAccent /
/// colorHeader) share the same vivid accent so the family stays cohesive.
class SnackbarColorConfig {
  final Color backgroundColor;
  final Color iconColor;
  final IconData defaultIcon;
  final Gradient? gradient;
  final Color titleColor;
  final Color subtitleColor;
  final Color borderColor;
  final ContentDesignStyle designStyle;
  final Color headerColor;
  final Color headerColorEnd;
  final Color buttonColor;
  final Color buttonTextColor;

  factory SnackbarColorConfig({
    required ThemeData theme,
    required bool isDark,
    Color? background,
    Gradient? gradient,
    Color? iconColor,
    required SnackbarType type,
    required SnackbarConfig config,
    ContentDesignStyle? designStyle,
  }) {
    final style = designStyle ?? config.defaultDesignStyle;
    final accent = SpPalette.of(_intentOf(type), isDark);
    final resolvedIcon =
        iconColor ?? config.getIconColor(type) ?? accent.base;
    final isSolid = style == ContentDesignStyle.solid;
    final isNeon = style == ContentDesignStyle.neon;

    // The vivid gradient is the signature of the bold default.
    final Gradient? resolvedGradient = gradient ??
        (isSolid && background == null ? accent.gradient : null);

    return SnackbarColorConfig._(
      designStyle: style,
      backgroundColor: _computeBackgroundColor(
        background: background,
        gradient: resolvedGradient,
        style: style,
        isDark: isDark,
        accent: accent,
      ),
      gradient: resolvedGradient,
      iconColor: resolvedIcon,
      defaultIcon: config.getDefaultIcon(type) ?? _getDefaultIcon(type),
      titleColor: isNeon
          ? SpSurface.neonText
          : (isSolid ? Colors.white : SpSurface.onSurface(isDark)),
      subtitleColor: isNeon
          ? SpSurface.neonTextMuted(resolvedIcon)
          : (isSolid
              ? Colors.white.withValues(alpha: 0.85)
              : SpSurface.onSurfaceMuted(isDark)),
      borderColor: resolvedIcon,
      headerColor: accent.gradientStart,
      headerColorEnd: accent.gradientEnd,
      buttonColor: accent.base,
      buttonTextColor: accent.onAccent,
    );
  }

  SnackbarColorConfig._({
    required this.designStyle,
    required this.backgroundColor,
    required this.gradient,
    required this.iconColor,
    required this.defaultIcon,
    required this.titleColor,
    required this.subtitleColor,
    required this.borderColor,
    required this.headerColor,
    required this.headerColorEnd,
    required this.buttonColor,
    required this.buttonTextColor,
  });

  static SpIntent _intentOf(SnackbarType type) => switch (type) {
        SnackbarType.success => SpIntent.success,
        SnackbarType.error => SpIntent.error,
        SnackbarType.warning => SpIntent.warning,
        SnackbarType.info => SpIntent.info,
      };

  static Color _computeBackgroundColor({
    required Color? background,
    required Gradient? gradient,
    required ContentDesignStyle style,
    required bool isDark,
    required SpAccent accent,
  }) {
    if (background != null) return background;
    if (gradient != null) return Colors.transparent;

    switch (style) {
      case ContentDesignStyle.outlined:
      case ContentDesignStyle.leftAccent:
      case ContentDesignStyle.minimal:
        return SpSurface.background(isDark);
      case ContentDesignStyle.colorHeader:
        return SpSurface.elevated(isDark);
      case ContentDesignStyle.tonal:
        return accent.tonalFill;
      case ContentDesignStyle.glass:
        return SpSurface.glassFill(isDark);
      case ContentDesignStyle.neon:
        return SpSurface.neonSurface(isDark);
      case ContentDesignStyle.solid:
        // Solid without a gradient (caller forced a flat look).
        return accent.base;
    }
  }

  /// Modern Material 3 rounded icons for a softer, contemporary look.
  static IconData _getDefaultIcon(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return Icons.check_circle_rounded;
      case SnackbarType.error:
        return Icons.error_rounded;
      case SnackbarType.warning:
        return Icons.warning_amber_rounded;
      case SnackbarType.info:
        return Icons.info_rounded;
    }
  }
}
