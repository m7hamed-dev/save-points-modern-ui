import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';

/// Dialog elevation — bold, colored-glow depth driven by [SpShadows].
class DialogShadows {
  /// Returns layered shadows for the dialog surface.
  ///
  /// When [accentColor] is provided the elevation includes a tinted glow in
  /// that color; otherwise a neutral ambient elevation is used.
  static List<BoxShadow> getShadows(
    bool isDark, {
    bool isOutlined = false,
    ContentDesignStyle? designStyle,
    Color? accentColor,
  }) {
    final style =
        designStyle ??
        (isOutlined ? ContentDesignStyle.outlined : ContentDesignStyle.solid);

    if (style == ContentDesignStyle.minimal) return SpShadows.flat;
    if (style == ContentDesignStyle.neon) {
      return accentColor != null
          ? SpShadows.neon(color: accentColor)
          : SpShadows.ambient(isDark: isDark);
    }

    final level = switch (style) {
      ContentDesignStyle.colorHeader || ContentDesignStyle.solid => 1.0,
      ContentDesignStyle.tonal || ContentDesignStyle.glass => 0.85,
      ContentDesignStyle.outlined || ContentDesignStyle.leftAccent => 0.7,
      ContentDesignStyle.minimal || ContentDesignStyle.neon => 1.0,
    };

    if (accentColor != null) {
      return SpShadows.glow(color: accentColor, isDark: isDark, level: level);
    }
    return SpShadows.ambient(isDark: isDark, level: level);
  }
}
