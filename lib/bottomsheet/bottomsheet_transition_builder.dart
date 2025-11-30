import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:savepoints_modern_ui/bottomsheet/bottomsheet_animation_direction.dart';
import 'package:savepoints_modern_ui/snackbar/clamped_animation.dart';

/// Bottom sheet transition builder with animation support
class BottomsheetTransitionBuilder extends StatelessWidget {
  final Animation<double> animation;
  final Widget bottomsheet;
  final BottomsheetAnimationDirection? startAnimation;
  final BottomsheetAnimationDirection? endAnimation;
  final bool hideLikeCircle;

  const BottomsheetTransitionBuilder({
    super.key,
    required this.animation,
    required this.bottomsheet,
    this.startAnimation,
    this.endAnimation,
    this.hideLikeCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    // Use circular reveal if enabled
    if (hideLikeCircle) {
      return RepaintBoundary(child: _buildCircularReveal(context));
    }

    final clampedAnimation = ClampedAnimation(animation);

    // Use new animation system if startAnimation or endAnimation is provided
    if (startAnimation != null || endAnimation != null) {
      return RepaintBoundary(child: _buildDirectionalAnimation());
    }

    // Default: slide from bottom
    return RepaintBoundary(child: _buildSlideFromBottom(clampedAnimation));
  }

  Widget _buildCircularReveal(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxRadius = _calculateMaxRadius(screenSize);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final radius = animation.value * maxRadius;

        return ClipPath(
          clipper: _BottomsheetCircularRevealClipper(
            radius: radius,
            alignment: Alignment.bottomCenter,
          ),
          child: child ?? const SizedBox(),
        );
      },
      child: bottomsheet,
    );
  }

  double _calculateMaxRadius(Size screenSize) {
    final diagonal = math.sqrt(
      screenSize.width * screenSize.width +
          screenSize.height * screenSize.height,
    );
    return diagonal / 2;
  }

  Widget _buildDirectionalAnimation() {
    final startDir = startAnimation ?? BottomsheetAnimationDirection.fromBottom;
    final endDir = endAnimation ?? BottomsheetAnimationDirection.fromBottom;

    final isForward =
        animation.status == AnimationStatus.forward ||
        animation.status == AnimationStatus.completed;

    if (isForward) {
      return _buildFromDirection(animation, startDir);
    } else {
      return _buildToDirection(animation, endDir);
    }
  }

  Widget _buildFromDirection(
    Animation<double> anim,
    BottomsheetAnimationDirection dir,
  ) {
    final clampedAnim = ClampedAnimation(anim);

    switch (dir) {
      case BottomsheetAnimationDirection.fromBottom:
        return _buildSlideFromBottom(clampedAnim);
      case BottomsheetAnimationDirection.fromLeft:
        return _buildSlide(clampedAnim, const Offset(-1, 0));
      case BottomsheetAnimationDirection.fromRight:
        return _buildSlide(clampedAnim, const Offset(1, 0));
      case BottomsheetAnimationDirection.fade:
        return _buildFade(clampedAnim);
      case BottomsheetAnimationDirection.scale:
        return _buildScale(clampedAnim);
      case BottomsheetAnimationDirection.none:
        return bottomsheet;
    }
  }

  Widget _buildToDirection(
    Animation<double> anim,
    BottomsheetAnimationDirection dir,
  ) {
    final clampedAnim = ClampedAnimation(anim);

    switch (dir) {
      case BottomsheetAnimationDirection.fromBottom: // Exit to bottom
        return _buildSlideReverse(clampedAnim, const Offset(0, 1));
      case BottomsheetAnimationDirection.fromLeft: // Exit to left
        return _buildSlideReverse(clampedAnim, const Offset(-1, 0));
      case BottomsheetAnimationDirection.fromRight: // Exit to right
        return _buildSlideReverse(clampedAnim, const Offset(1, 0));
      case BottomsheetAnimationDirection.fade:
        return _buildFade(clampedAnim);
      case BottomsheetAnimationDirection.scale:
        return _buildScale(clampedAnim);
      case BottomsheetAnimationDirection.none:
        return bottomsheet;
    }
  }

  Widget _buildSlideFromBottom(Animation<double> anim) {
    final curvedAnimation = CurvedAnimation(
      parent: anim,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(curvedAnimation),
      child: bottomsheet,
    );
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
        child: bottomsheet,
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
        child: bottomsheet,
      ),
    );
  }

  Widget _buildFade(Animation<double> anim) {
    final curvedAnimation = CurvedAnimation(
      parent: anim,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    return FadeTransition(opacity: curvedAnimation, child: bottomsheet);
  }

  Widget _buildScale(Animation<double> anim) {
    final curvedAnimation = CurvedAnimation(
      parent: anim,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: ScaleTransition(
        scale: curvedAnimation,
        alignment: Alignment.bottomCenter,
        child: bottomsheet,
      ),
    );
  }
}

/// Custom clipper for bottom sheet circular reveal animation
class _BottomsheetCircularRevealClipper extends CustomClipper<Path> {
  final double radius;
  final AlignmentGeometry alignment;

  _BottomsheetCircularRevealClipper({
    required this.radius,
    required this.alignment,
  });

  @override
  Path getClip(Size size) {
    final align = alignment.resolve(TextDirection.ltr);
    final center = align.inscribe(Size.zero, Offset.zero & size).center;

    final path = Path();
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    return path;
  }

  @override
  bool shouldReclip(_BottomsheetCircularRevealClipper oldClipper) {
    return oldClipper.radius != radius || oldClipper.alignment != alignment;
  }
}
