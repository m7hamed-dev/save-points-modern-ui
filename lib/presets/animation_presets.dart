import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_animation_direction.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_animation_direction.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_animation_direction.dart';

/// Predefined animation configurations for common use cases
class AnimationPresets {
  /// Smooth fade animation
  static const fade = AnimationConfig(
    dialogStart: .fade,
    dialogEnd: .fade,
    snackbarStart: .fade,
    snackbarEnd: .fade,
    bottomsheetStart: .fade,
    bottomsheetEnd: .fade,
  );

  /// Slide from bottom (default for bottom sheets)
  static const slideFromBottom = AnimationConfig(
    dialogStart: .fromBottom,
    dialogEnd: .fromBottom,
    snackbarStart: .fromBottom,
    snackbarEnd: .fromBottom,
    bottomsheetStart: .fromBottom,
    bottomsheetEnd: .fromBottom,
  );

  /// Slide from top
  static const slideFromTop = AnimationConfig(
    dialogStart: .fromTop,
    dialogEnd: .fromTop,
    snackbarStart: .fromTop,
    snackbarEnd: .fromTop,
    bottomsheetStart: BottomsheetAnimationDirection
        .fromBottom, // Bottom sheets always from bottom
    bottomsheetEnd: .fromBottom,
  );

  /// Slide from left
  static const slideFromLeft = AnimationConfig(
    dialogStart: .fromLeft,
    dialogEnd: .fromLeft,
    snackbarStart: .fromLeft,
    snackbarEnd: .fromLeft,
    bottomsheetStart: .fromLeft,
    bottomsheetEnd: .fromLeft,
  );

  /// Slide from right
  static const slideFromRight = AnimationConfig(
    dialogStart: .fromRight,
    dialogEnd: .fromRight,
    snackbarStart: .fromRight,
    snackbarEnd: .fromRight,
    bottomsheetStart: .fromRight,
    bottomsheetEnd: .fromRight,
  );

  /// Scale animation
  static const scale = AnimationConfig(
    dialogStart: .scale,
    dialogEnd: .scale,
    snackbarStart: .scale,
    snackbarEnd: .scale,
    bottomsheetStart: .scale,
    bottomsheetEnd: .scale,
  );

  /// Bounce animation
  static const bounce = AnimationConfig(
    dialogStart: .bounce,
    dialogEnd: .bounce,
    snackbarStart: .bounce,
    snackbarEnd: .bounce,
    bottomsheetStart: .scale, // No bounce for bottom sheets
    bottomsheetEnd: .scale,
  );

  /// Elastic animation
  static const elastic = AnimationConfig(
    dialogStart: .elastic,
    dialogEnd: .elastic,
    snackbarStart: .elastic,
    snackbarEnd: .elastic,
    bottomsheetStart: .scale,
    bottomsheetEnd: .scale,
  );

  /// Slide in from left, exit to right
  static const slideLeftToRight = AnimationConfig(
    dialogStart: .fromLeft,
    dialogEnd: .fromRight,
    snackbarStart: .fromLeft,
    snackbarEnd: .fromRight,
    bottomsheetStart: .fromLeft,
    bottomsheetEnd: .fromRight,
  );

  /// Slide in from right, exit to left
  static const slideRightToLeft = AnimationConfig(
    dialogStart: .fromRight,
    dialogEnd: .fromLeft,
    snackbarStart: .fromRight,
    snackbarEnd: .fromLeft,
    bottomsheetStart: .fromRight,
    bottomsheetEnd: .fromLeft,
  );
}

/// Animation configuration for all component types
class AnimationConfig {
  const AnimationConfig({
    this.dialogStart,
    this.dialogEnd,
    this.snackbarStart,
    this.snackbarEnd,
    this.bottomsheetStart,
    this.bottomsheetEnd,
  });
  final DialogAnimationDirection? dialogStart;
  final DialogAnimationDirection? dialogEnd;
  final SnackbarAnimationDirection? snackbarStart;
  final SnackbarAnimationDirection? snackbarEnd;
  final BottomsheetAnimationDirection? bottomsheetStart;
  final BottomsheetAnimationDirection? bottomsheetEnd;
}
