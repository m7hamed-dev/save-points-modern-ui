import 'package:flutter/material.dart';

/// Dialog constants
class DialogConstants {
  static const transitionDuration = Duration(milliseconds: 350);
  static const defaultConfirmText = 'OK';
  static const defaultCancelText = 'Cancel';
  static const borderRadius = 28.0;
  static const buttonBorderRadius = 16.0;
  static const iconSize = 48.0;
  static const iconPadding = 16.0;
  static const dialogMargin = EdgeInsets.symmetric(horizontal: 24);
  static const dialogPadding = .all(28);
  static const buttonPadding = EdgeInsets.symmetric(
    vertical: 16,
    horizontal: 24,
  );

  /// Minimum button height for accessibility (Material 48dp)
  static const buttonMinHeight = 48.0;
  static const buttonSpacing = 12.0;
  static const contentSpacingAfterIcon = 20.0;
  static const contentSpacingAfterTitle = 12.0;
  static const contentSpacingAfterMessage = 32.0;
  static const maxDialogWidth = 400.0;
}
