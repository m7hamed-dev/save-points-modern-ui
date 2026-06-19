import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';

/// Bottom sheet constants — geometry/spacing flow from the shared design
/// tokens so the sheet matches the dialog and snackbar.
class BottomsheetConstants {
  static const Duration transitionDuration = SpMotion.medium;
  static const double borderRadius = SpRadius.lg;
  static const double topBorderRadius = SpRadius.sheetTop;
  static const double handleHeight = 5.0;
  static const double handleWidth = 44.0;
  static const double handleBorderRadius = 2.5;
  static const EdgeInsets padding = .all(SpSpacing.xxl);
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(
    horizontal: SpSpacing.xxl,
  );
  static const double maxHeight = 0.9; // 90% of screen height
  static const double minHeight = 200.0;
  static const double handleSpacing = SpSpacing.md;
  static const double titleSpacing = SpSpacing.lg;
  static const double contentSpacing = SpSpacing.xl;
}
