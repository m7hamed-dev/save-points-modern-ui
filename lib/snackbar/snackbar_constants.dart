import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_enums.dart';

/// Snackbar constants — values flow from the shared [SpRadius]/[SpSpacing]/
/// [SpType] design tokens so the snackbar stays in lockstep with the dialog
/// and bottom sheet.
class SnackbarConstants {
  /// Default position: show snackbar at top of screen
  static const SnackbarPosition defaultPosition = SnackbarPosition.top;

  static const double borderRadius = SpRadius.lg;
  static const double iconSize = 24.0;
  static const double iconContainerSize = 44.0;
  static const double iconSpacing = SpSpacing.md;
  static const double titleFontSize = SpType.titleSize;
  static const double subtitleFontSize = SpType.bodySize;
  static const double titleLineHeight = SpType.titleHeight;
  static const double subtitleLineHeight = SpType.bodyHeight;
  static const double subtitleLetterSpacing = SpType.bodyTracking;
  static const double progressBarHeight = 3.0;
  static const double progressBarBorderRadius = 2.0;
  static const double horizontalPadding = SpSpacing.lg;
  static const double verticalPadding = SpSpacing.lg;
  static const double maxWidth = 500.0;

  /// Minimum width when shown at bottom so the snackbar doesn't look too small
  static const double minWidthBottom = 320.0;

  /// Minimum touch target size for accessibility (Material 48dp)
  static const double minTouchTargetSize = 48.0;
}
