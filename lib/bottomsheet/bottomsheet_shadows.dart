import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';

/// Bottom sheet elevation — bold, colored-glow depth that casts *upward*.
class BottomsheetShadows {
  const BottomsheetShadows();

  /// Returns layered upward shadows for the sheet surface.
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

    // Sheets sit at the bottom edge, so the elevation rises upward.
    const up = Offset(0, -1);

    if (style == ContentDesignStyle.minimal) return SpShadows.flat;
    if (style == ContentDesignStyle.neon) {
      return accentColor != null
          ? SpShadows.neon(color: accentColor, direction: up)
          : SpShadows.ambient(isDark: isDark, direction: up);
    }

    final level = switch (style) {
      ContentDesignStyle.colorHeader || ContentDesignStyle.solid => 1.0,
      ContentDesignStyle.tonal || ContentDesignStyle.glass => 0.85,
      ContentDesignStyle.outlined || ContentDesignStyle.leftAccent => 0.7,
      ContentDesignStyle.minimal || ContentDesignStyle.neon => 1.0,
    };

    if (accentColor != null) {
      return SpShadows.glow(
        color: accentColor,
        isDark: isDark,
        level: level,
        direction: up,
      );
    }
    return SpShadows.ambient(isDark: isDark, level: level, direction: up);
  }
}
