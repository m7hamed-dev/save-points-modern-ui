import 'package:flutter/material.dart';

/// Shared constants used across the package
class SavePointsConstants {
  // Animation durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 20.0;
  static const double spacingXXL = 24.0;
  static const double spacingXXXL = 32.0;

  // Border radius
  static const double borderRadiusS = 8.0;
  static const double borderRadiusM = 12.0;
  static const double borderRadiusL = 16.0;
  static const double borderRadiusXL = 24.0;
  static const double borderRadiusXXL = 28.0;

  // Opacity values
  static const double opacityLow = 0.3;
  static const double opacityMedium = 0.5;
  static const double opacityHigh = 0.7;
  static const double opacityFull = 1.0;

  // Elevation
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // Icon sizes
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;

  // Screen breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;

  // Max widths
  static const double maxContentWidth = 500.0;
  static const double maxDialogWidth = 400.0;

  // Default durations
  static const Duration defaultSnackbarDuration = Duration(seconds: 4);
  static const Duration defaultDialogDuration = Duration(milliseconds: 350);

  // Barrier
  static const Color defaultBarrierColor = Colors.black;
  static const double defaultBarrierOpacity = 0.5;

  // Private constructor to prevent instantiation
  SavePointsConstants._();
}

