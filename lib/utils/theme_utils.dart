import 'package:flutter/material.dart';

/// Utility functions for theme-related operations
class ThemeUtils {
  /// Determines if the current theme is dark
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Gets the current theme
  static ThemeData getTheme(BuildContext context) {
    return Theme.of(context);
  }

  /// Gets the current color scheme
  static ColorScheme getColorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  /// Gets a color that adapts to the theme
  static Color getAdaptiveColor(
    BuildContext context, {
    required Color lightColor,
    required Color darkColor,
  }) {
    return isDark(context) ? darkColor : lightColor;
  }

  /// Gets a color with opacity that adapts to theme
  static Color getAdaptiveColorWithOpacity(
    BuildContext context, {
    required Color lightColor,
    required Color darkColor,
    required double opacity,
  }) {
    final baseColor = isDark(context) ? darkColor : lightColor;
    return baseColor.withValues(alpha: opacity);
  }
}

