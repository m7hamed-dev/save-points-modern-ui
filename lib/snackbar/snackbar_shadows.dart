import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';

/// Snackbar shadows configuration
class SnackbarShadows {
  static List<BoxShadow> getShadows([ContentDesignStyle style = ContentDesignStyle.solid]) {
    if (style == ContentDesignStyle.outlined) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
    }
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.3),
        blurRadius: 20,
        offset: const Offset(0, 8),
        spreadRadius: -5,
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ];
  }
}
