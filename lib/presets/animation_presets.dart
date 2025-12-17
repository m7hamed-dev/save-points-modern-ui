import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_animation_direction.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_animation_direction.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_animation_direction.dart';

/// Predefined animation configurations for common use cases
class AnimationPresets {
  /// Smooth fade animation
  static const fade = AnimationConfig(
    dialogStart: DialogAnimationDirection.fade,
    dialogEnd: DialogAnimationDirection.fade,
    snackbarStart: SnackbarAnimationDirection.fade,
    snackbarEnd: SnackbarAnimationDirection.fade,
    bottomsheetStart: BottomsheetAnimationDirection.fade,
    bottomsheetEnd: BottomsheetAnimationDirection.fade,
  );

  /// Slide from bottom (default for bottom sheets)
  static const slideFromBottom = AnimationConfig(
    dialogStart: DialogAnimationDirection.fromBottom,
    dialogEnd: DialogAnimationDirection.fromBottom,
    snackbarStart: SnackbarAnimationDirection.fromBottom,
    snackbarEnd: SnackbarAnimationDirection.fromBottom,
    bottomsheetStart: BottomsheetAnimationDirection.fromBottom,
    bottomsheetEnd: BottomsheetAnimationDirection.fromBottom,
  );

  /// Slide from top
  static const slideFromTop = AnimationConfig(
    dialogStart: DialogAnimationDirection.fromTop,
    dialogEnd: DialogAnimationDirection.fromTop,
    snackbarStart: SnackbarAnimationDirection.fromTop,
    snackbarEnd: SnackbarAnimationDirection.fromTop,
    bottomsheetStart: BottomsheetAnimationDirection.fromBottom, // Bottom sheets always from bottom
    bottomsheetEnd: BottomsheetAnimationDirection.fromBottom,
  );

  /// Slide from left
  static const slideFromLeft = AnimationConfig(
    dialogStart: DialogAnimationDirection.fromLeft,
    dialogEnd: DialogAnimationDirection.fromLeft,
    snackbarStart: SnackbarAnimationDirection.fromLeft,
    snackbarEnd: SnackbarAnimationDirection.fromLeft,
    bottomsheetStart: BottomsheetAnimationDirection.fromLeft,
    bottomsheetEnd: BottomsheetAnimationDirection.fromLeft,
  );

  /// Slide from right
  static const slideFromRight = AnimationConfig(
    dialogStart: DialogAnimationDirection.fromRight,
    dialogEnd: DialogAnimationDirection.fromRight,
    snackbarStart: SnackbarAnimationDirection.fromRight,
    snackbarEnd: SnackbarAnimationDirection.fromRight,
    bottomsheetStart: BottomsheetAnimationDirection.fromRight,
    bottomsheetEnd: BottomsheetAnimationDirection.fromRight,
  );

  /// Scale animation
  static const scale = AnimationConfig(
    dialogStart: DialogAnimationDirection.scale,
    dialogEnd: DialogAnimationDirection.scale,
    snackbarStart: SnackbarAnimationDirection.scale,
    snackbarEnd: SnackbarAnimationDirection.scale,
    bottomsheetStart: BottomsheetAnimationDirection.scale,
    bottomsheetEnd: BottomsheetAnimationDirection.scale,
  );

  /// Bounce animation
  static const bounce = AnimationConfig(
    dialogStart: DialogAnimationDirection.bounce,
    dialogEnd: DialogAnimationDirection.bounce,
    snackbarStart: SnackbarAnimationDirection.bounce,
    snackbarEnd: SnackbarAnimationDirection.bounce,
    bottomsheetStart: BottomsheetAnimationDirection.scale, // No bounce for bottom sheets
    bottomsheetEnd: BottomsheetAnimationDirection.scale,
  );

  /// Elastic animation
  static const elastic = AnimationConfig(
    dialogStart: DialogAnimationDirection.elastic,
    dialogEnd: DialogAnimationDirection.elastic,
    snackbarStart: SnackbarAnimationDirection.elastic,
    snackbarEnd: SnackbarAnimationDirection.elastic,
    bottomsheetStart: BottomsheetAnimationDirection.scale,
    bottomsheetEnd: BottomsheetAnimationDirection.scale,
  );

  /// Slide in from left, exit to right
  static const slideLeftToRight = AnimationConfig(
    dialogStart: DialogAnimationDirection.fromLeft,
    dialogEnd: DialogAnimationDirection.fromRight,
    snackbarStart: SnackbarAnimationDirection.fromLeft,
    snackbarEnd: SnackbarAnimationDirection.fromRight,
    bottomsheetStart: BottomsheetAnimationDirection.fromLeft,
    bottomsheetEnd: BottomsheetAnimationDirection.fromRight,
  );

  /// Slide in from right, exit to left
  static const slideRightToLeft = AnimationConfig(
    dialogStart: DialogAnimationDirection.fromRight,
    dialogEnd: DialogAnimationDirection.fromLeft,
    snackbarStart: SnackbarAnimationDirection.fromRight,
    snackbarEnd: SnackbarAnimationDirection.fromLeft,
    bottomsheetStart: BottomsheetAnimationDirection.fromRight,
    bottomsheetEnd: BottomsheetAnimationDirection.fromLeft,
  );
}

/// Animation configuration for all component types
class AnimationConfig {
  final DialogAnimationDirection? dialogStart;
  final DialogAnimationDirection? dialogEnd;
  final SnackbarAnimationDirection? snackbarStart;
  final SnackbarAnimationDirection? snackbarEnd;
  final BottomsheetAnimationDirection? bottomsheetStart;
  final BottomsheetAnimationDirection? bottomsheetEnd;

  const AnimationConfig({
    this.dialogStart,
    this.dialogEnd,
    this.snackbarStart,
    this.snackbarEnd,
    this.bottomsheetStart,
    this.bottomsheetEnd,
  });
}

