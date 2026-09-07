import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/sp_style.dart';

/// Elevation is part of the design style, not of the component: every
/// surface resolves it through [SpStyles] so a style casts the same shadow
/// wherever it is used. These three classes used to each carry their own
/// switch, which is how they drifted apart.
class SnackbarShadows {
  /// Layered elevation for the snackbar surface.
  static List<BoxShadow> getShadows([
    ContentDesignStyle style = ContentDesignStyle.solid,
    Color? accentColor,
    bool isDark = false,
  ]) =>
      SpStyles.of(style, accentColor ?? const Color(0xFF6366F1), isDark)
          .shadows;
}
