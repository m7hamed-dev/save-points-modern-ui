import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_animation_type.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_animation_direction.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/clamped_animation.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/circular_reveal_clip.dart';

/// Dialog transition builder with separate start and end animations
class DialogTransitionBuilder extends StatelessWidget {
  const DialogTransitionBuilder({
    super.key,
    required this.animation,
    required this.dialog,
    this.animationType,
    this.startAnimation,
    this.endAnimation,
    this.hideLikeCircle = false,
  });

  final Animation<double> animation;
  final Widget dialog;
  final DialogAnimationType? animationType; // For backward compatibility
  final DialogAnimationDirection? startAnimation;
  final DialogAnimationDirection? endAnimation;
  final bool hideLikeCircle;

  @override
  Widget build(BuildContext context) {
    Widget animatedWidget;

    // Use circular reveal if enabled
    if (hideLikeCircle) {
      return RepaintBoundary(
        child: CircularRevealClip(animation: animation, child: dialog),
      );
    }

    // Use new animation system if startAnimation or endAnimation is provided
    if (startAnimation != null || endAnimation != null) {
      animatedWidget = _buildDirectionalAnimation();
    } else {
      // Fallback to old animationType system for backward compatibility
      final clampedAnimation = ClampedAnimation(animation);
      final finalAnimationType = animationType ?? .fadeSlide;
      animatedWidget = _buildLegacyAnimation(
        clampedAnimation,
        finalAnimationType,
      );
    }

    return RepaintBoundary(child: animatedWidget);
  }

  Widget _buildLegacyAnimation(
    Animation<double> clampedAnimation,
    DialogAnimationType finalAnimationType,
  ) {
    switch (finalAnimationType) {
      case .fadeSlide:
        return _buildFadeSlide(clampedAnimation);
      case .scale:
        return _buildScale(clampedAnimation);
      case .slideBottom:
        return _buildSlide(clampedAnimation, const Offset(0, 0.3));
      case .slideTop:
        return _buildSlide(clampedAnimation, const Offset(0, -0.3));
      case .slideLeft:
        return _buildSlide(clampedAnimation, const Offset(-0.3, 0));
      case .slideRight:
        return _buildSlide(clampedAnimation, const Offset(0.3, 0));
      case .bounce:
        return _buildBounce(clampedAnimation);
      case .rotateScale:
        return _buildRotateScale(clampedAnimation);
      case .elastic:
        return _buildElastic(clampedAnimation);
      case .none:
        return dialog;
    }
  }

  Widget _buildDirectionalAnimation() {
    final startDir = startAnimation ?? .fade;
    final endDir = endAnimation ?? .fade;

    // Create two separate animations: one for enter, one for exit
    // Use the animation status to determine which one to use
    final isForward =
        animation.status == .forward || animation.status == .completed;

    if (isForward) {
      // Entering - use startAnimation
      return _buildFromDirection(animation, startDir);
    } else {
      // Exiting - use endAnimation (reversed)
      return _buildToDirection(animation, endDir);
    }
  }

  Widget _buildFromDirection(
    Animation<double> anim,
    DialogAnimationDirection dir,
  ) {
    final clampedAnim = ClampedAnimation(anim);

    switch (dir) {
      case .fromTop:
        return _buildSlide(clampedAnim, const Offset(0, -1));
      case .fromBottom:
        return _buildSlide(clampedAnim, const Offset(0, 1));
      case .fromLeft:
        return _buildSlide(clampedAnim, const Offset(-1, 0));
      case .fromRight:
        return _buildSlide(clampedAnim, const Offset(1, 0));
      case .fade:
        return _buildFadeOnly(clampedAnim);
      case .scale:
        return _buildScale(clampedAnim);
      case .rotateScale:
        return _buildRotateScale(clampedAnim);
      case .bounce:
        return _buildBounce(clampedAnim);
      case .elastic:
        return _buildElastic(clampedAnim);
      case .none:
        return dialog;
    }
  }

  Widget _buildToDirection(
    Animation<double> anim,
    DialogAnimationDirection dir,
  ) {
    final clampedAnim = ClampedAnimation(anim);

    switch (dir) {
      case .fromTop: // Exit to top
        return _buildSlideReverse(clampedAnim, const Offset(0, -1));
      case .fromBottom: // Exit to bottom
        return _buildSlideReverse(clampedAnim, const Offset(0, 1));
      case .fromLeft: // Exit to left
        return _buildSlideReverse(clampedAnim, const Offset(-1, 0));
      case .fromRight: // Exit to right
        return _buildSlideReverse(clampedAnim, const Offset(1, 0));
      case .fade:
        return _buildFadeOnly(clampedAnim);
      case .scale:
        return _buildScale(clampedAnim);
      case .rotateScale:
        return _buildRotateScale(clampedAnim);
      case .bounce:
        return _buildBounce(clampedAnim);
      case .elastic:
        return _buildElastic(clampedAnim);
      case .none:
        return dialog;
    }
  }

  Widget _buildFadeOnly(Animation<double> anim) {
    final curvedAnimation = CurvedAnimation(
      parent: anim,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    return FadeTransition(opacity: curvedAnimation, child: dialog);
  }

  Widget _buildSlide(Animation<double> anim, Offset beginOffset) {
    final curvedAnimation = CurvedAnimation(
      parent: anim,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: dialog,
      ),
    );
  }

  Widget _buildSlideReverse(Animation<double> anim, Offset endOffset) {
    final curvedAnimation = CurvedAnimation(
      parent: anim,
      curve: Curves.easeInCubic,
      reverseCurve: Curves.easeOutCubic,
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: endOffset,
        ).animate(curvedAnimation),
        child: dialog,
      ),
    );
  }

  Widget _buildFadeSlide(Animation<double> anim) {
    final curvedAnimation = CurvedAnimation(
      parent: anim,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: dialog,
      ),
    );
  }

  Widget _buildScale(Animation<double> anim) {
    final curvedAnimation = CurvedAnimation(
      parent: anim,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: ScaleTransition(scale: curvedAnimation, child: dialog),
    );
  }

  Widget _buildBounce(Animation<double> anim) {
    final curvedAnimation = CurvedAnimation(
      parent: anim,
      curve: Curves.elasticOut,
      reverseCurve: Curves.easeIn,
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: ScaleTransition(scale: curvedAnimation, child: dialog),
    );
  }

  Widget _buildRotateScale(Animation<double> anim) {
    final curvedAnimation = CurvedAnimation(
      parent: anim,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    );

    final rotationAnimation = Tween<double>(
      begin: -0.2,
      end: 0.0,
    ).animate(curvedAnimation);

    return FadeTransition(
      opacity: curvedAnimation,
      child: RotationTransition(
        turns: rotationAnimation,
        child: ScaleTransition(scale: curvedAnimation, child: dialog),
      ),
    );
  }

  Widget _buildElastic(Animation<double> anim) {
    final curvedAnimation = CurvedAnimation(
      parent: anim,
      curve: Curves.elasticOut,
      reverseCurve: Curves.easeIn,
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: ScaleTransition(scale: curvedAnimation, child: dialog),
    );
  }
}
