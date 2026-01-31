import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_enums.dart';

/// Snackbar constants
class SnackbarConstants {
  /// Default position: show snackbar at top of screen
  static const SnackbarPosition defaultPosition = SnackbarPosition.top;

  static const double borderRadius = 16.0;
  static const double iconSize = 24.0;
  static const double iconContainerSize = 40.0;
  static const double iconSpacing = 12.0;
  static const double titleFontSize = 16.0;
  static const double subtitleFontSize = 14.0;
  static const double titleLineHeight = 1.25;
  static const double subtitleLineHeight = 1.4;
  static const double subtitleLetterSpacing = 0.15;
  static const double progressBarHeight = 3.0;
  static const double progressBarBorderRadius = 2.0;
  static const double horizontalPadding = 16.0;
  static const double verticalPadding = 16.0;
  static const double maxWidth = 500.0;
  /// Minimum width when shown at bottom so the snackbar doesn't look too small
  static const double minWidthBottom = 320.0;
  /// Minimum touch target size for accessibility (Material 48dp)
  static const double minTouchTargetSize = 48.0;
}
