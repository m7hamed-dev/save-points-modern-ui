import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';

/// Dialog constants — geometry/spacing flow from the shared design tokens.
class DialogConstants {
  static const transitionDuration = SpMotion.medium;
  static const defaultConfirmText = 'OK';
  static const defaultCancelText = 'Cancel';
  static const borderRadius = SpRadius.xl;
  static const buttonBorderRadius = SpRadius.md;
  static const iconSize = 48.0;
  static const iconPadding = SpSpacing.lg;
  static const dialogMargin = EdgeInsets.symmetric(horizontal: SpSpacing.xxl);
  static const dialogPadding = EdgeInsets.all(SpSpacing.xxl);
  static const buttonPadding = EdgeInsets.symmetric(
    vertical: SpSpacing.lg,
    horizontal: SpSpacing.xxl,
  );

  /// Minimum button height for accessibility (Material 48dp)
  static const buttonMinHeight = 48.0;
  static const buttonSpacing = SpSpacing.md;
  static const contentSpacingAfterIcon = SpSpacing.xl;
  static const contentSpacingAfterTitle = SpSpacing.md;
  static const contentSpacingAfterMessage = SpSpacing.xxxl;
  static const maxDialogWidth = 400.0;
}
