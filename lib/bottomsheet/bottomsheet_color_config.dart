import 'package:material_ui/material_ui.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/sp_style.dart';

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
  })  : designStyle = designStyle ?? ContentDesignStyle.colorHeader,
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
          designStyle: designStyle ?? ContentDesignStyle.colorHeader,
          icon: icon,
          theme: theme,
          isDark: isDark,
        ),
        borderWidth =
            _computeBorderWidth(designStyle ?? ContentDesignStyle.colorHeader),
        headerColor = _computeHeaderColor(
          icon: icon ??
              (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
          isDark: isDark,
        ),
        headerColorEnd = _computeHeaderColorEnd(
          icon: icon ??
              (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
          isDark: isDark,
        ),
        buttonColor = icon ??
            (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
        buttonTextColor = SpContrast.onColor(
          icon ??
              (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary),
        ),
        iconBackgroundColor = isDark ? const Color(0xFF1F2937) : Colors.white;

  static Color _accent(Color? icon, ThemeData theme, bool isDark) =>
      icon ?? (isDark ? const Color(0xFF60A5FA) : theme.colorScheme.primary);

  static Color _computeBackgroundColor({
    required Color? background,
    required ContentDesignStyle designStyle,
    required bool isDark,
  }) =>
      background ??
      SpStyles.of(designStyle, const Color(0xFF6366F1), isDark).fill;

  static Color _computeTextColor({
    required Color? text,
    required ContentDesignStyle designStyle,
    required bool isDark,
  }) =>
      text ??
      SpStyles.of(designStyle, const Color(0xFF6366F1), isDark).onSurface;

  static Color _computeIconColor({
    required Color? icon,
    required ContentDesignStyle designStyle,
    required ThemeData theme,
    required bool isDark,
  }) =>
      _accent(icon, theme, isDark);

  static Color? _computeBorderColor({
    required ContentDesignStyle designStyle,
    required Color? icon,
    required ThemeData theme,
    required bool isDark,
  }) {
    final spec = SpStyles.of(designStyle, _accent(icon, theme, isDark), isDark);
    return spec.hasBorder ? spec.borderColor : null;
  }

  static double? _computeBorderWidth(ContentDesignStyle designStyle) {
    // Width never depends on the accent, so any accent resolves it.
    final spec = SpStyles.of(designStyle, const Color(0xFF6366F1), false);
    return spec.borderWidth > 0 ? spec.borderWidth : null;
  }

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
