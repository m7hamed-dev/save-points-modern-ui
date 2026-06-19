import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_animation_type.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_enums.dart';

/// Configuration for dialog appearance and behavior
class DialogConfig {
  /// Default design style: solid (filled) or outlined (light bg + border).
  ContentDesignStyle defaultDesignStyle = .solid;

  /// Default confirm button text
  String defaultConfirmText = 'OK';

  /// Default cancel button text
  String defaultCancelText = 'Cancel';

  /// Show cancel button by default
  bool defaultShowCancelButton = false;

  /// Barrier dismissible by default
  bool defaultBarrierDismissible = true;

  /// Barrier label
  String barrierLabel = 'Close dialog';

  /// Barrier color
  Color barrierColor = Colors.black.withValues(alpha: 0.5);

  /// Transition duration
  Duration transitionDuration = const Duration(milliseconds: 350);

  /// Default animation type
  DialogAnimationType defaultAnimation = DialogAnimationType.fadeSlide;

  /// Default icon colors for different types (optional)
  Map<SnackbarType, Color>? defaultIconColors;

  /// Default background color (null = auto-calculate based on theme)
  Color? defaultBackgroundColor;

  /// Default confirm button color (null = use theme primary)
  Color? defaultConfirmButtonColor;

  /// Default cancel button color
  Color defaultCancelButtonColor = Colors.grey;

  /// Apply theme settings
  void applyTheme(Brightness brightness) {
    // Can be extended for theme-specific overrides
  }
}
