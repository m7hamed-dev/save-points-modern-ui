import 'package:material_ui/material_ui.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/sp_style.dart';

/// Elevation is part of the design style, not of the component: every
/// surface resolves it through [SpStyles] so a style casts the same shadow
/// wherever it is used. These three classes used to each carry their own
/// switch, which is how they drifted apart.
class DialogShadows {
  /// Layered elevation for the Dialog surface.
  static List<BoxShadow> getShadows(
    bool isDark, {
    bool isOutlined = false,
    ContentDesignStyle? designStyle,
    Color? accentColor,
  }) {
    final style = designStyle ??
        (isOutlined ? ContentDesignStyle.outlined : ContentDesignStyle.solid);
    return SpStyles.of(style, accentColor ?? const Color(0xFF6366F1), isDark)
        .shadows;
  }
}
