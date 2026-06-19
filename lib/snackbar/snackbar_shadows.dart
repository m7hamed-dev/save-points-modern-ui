import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';

/// Snackbar elevation — bold, colored-glow depth driven by [SpShadows].
class SnackbarShadows {
  /// Returns layered shadows for the given [style].
  ///
  /// When [accentColor] is provided the elevation includes a tinted glow in
  /// that color (the signature bold look); otherwise a neutral ambient
  /// elevation is used. [isDark] deepens the ambient layer.
  static List<BoxShadow> getShadows([
    ContentDesignStyle style = ContentDesignStyle.solid,
    Color? accentColor,
    bool isDark = false,
  ]) {
    // Bolder styles float higher.
    final level = switch (style) {
      ContentDesignStyle.colorHeader || ContentDesignStyle.solid => 1.0,
      ContentDesignStyle.tonal => 0.85,
      ContentDesignStyle.outlined || ContentDesignStyle.leftAccent => 0.7,
    };

    if (accentColor != null) {
      return SpShadows.glow(color: accentColor, isDark: isDark, level: level);
    }
    return SpShadows.ambient(isDark: isDark, level: level);
  }
}
