import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_enums.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/clamped_animation.dart';

/// Professional wrapper for entrance and exit animations with enhanced dismiss effects
class AnimatedWrapper extends StatelessWidget {
  const AnimatedWrapper({
    super.key,
    required this.animation,
    required this.animationType,
    required this.position,
    required this.child,
    this.isDismissing = false,
  });

  final Animation<double> animation;
  final SnackbarAnimation animationType;
  final SnackbarPosition position;
  final Widget child;
  final bool isDismissing;

  @override
  Widget build(BuildContext context) {
    // Use different curves for forward (entrance) and reverse (exit)
    final forwardCurve = _getForwardCurve();
    final reverseCurve = _getReverseCurve();

    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: forwardCurve,
      reverseCurve: reverseCurve,
    );

    final clampedAnimation = ClampedAnimation(curvedAnimation);

    return RepaintBoundary(child: _buildAnimation(clampedAnimation));
  }

  Curve _getForwardCurve() {
    switch (animationType) {
      case SnackbarAnimation.fadeSlide:
        return Curves.easeOutCubic;
      case SnackbarAnimation.scale:
        return Curves.easeOutBack;
      case SnackbarAnimation.slide:
        return Curves.easeOutCubic;
      case SnackbarAnimation.bounce:
        return Curves.bounceOut;
      case SnackbarAnimation.rotate:
        return Curves.easeOutBack;
      case SnackbarAnimation.elastic:
        return Curves.elasticOut;
      case SnackbarAnimation.slideRotate:
        return Curves.easeOutCubic;
      case SnackbarAnimation.none:
        return Curves.linear;
    }
  }

  /// Enhanced reverse curves for smoother dismiss animations
  Curve _getReverseCurve() {
    switch (animationType) {
      case SnackbarAnimation.fadeSlide:
        return Curves.easeInQuart;
      case SnackbarAnimation.scale:
        return Curves.easeInBack;
      case SnackbarAnimation.slide:
        return Curves.easeInQuart;
      case SnackbarAnimation.bounce:
        return Curves.easeInQuart;
      case SnackbarAnimation.rotate:
        return Curves.easeInBack;
      case SnackbarAnimation.elastic:
        return Curves.easeInQuart;
      case SnackbarAnimation.slideRotate:
        return Curves.easeInQuart;
      case SnackbarAnimation.none:
        return Curves.linear;
    }
  }

  Widget _buildAnimation(Animation<double> clampedAnimation) {
    switch (animationType) {
      case SnackbarAnimation.fadeSlide:
        // Enhanced: Slide further out on dismiss with accelerated fade
        final slideOffset = position == SnackbarPosition.top ? -0.4 : 0.4;
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: clampedAnimation,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
            reverseCurve: const Interval(0.0, 1.0, curve: Curves.easeIn),
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, slideOffset),
              end: Offset.zero,
            ).animate(clampedAnimation),
            child: child,
          ),
        );

      case SnackbarAnimation.scale:
        // Enhanced: Scale down smaller on dismiss with slight vertical movement
        return FadeTransition(
          opacity: clampedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, position == SnackbarPosition.top ? -0.1 : 0.1),
              end: Offset.zero,
            ).animate(clampedAnimation),
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.85,
                end: 1.0,
              ).animate(clampedAnimation),
              child: child,
            ),
          ),
        );

      case SnackbarAnimation.slide:
        // Enhanced: Slide completely off screen
        final slideDirection = position == SnackbarPosition.top ? -1.2 : 1.2;
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, slideDirection),
            end: Offset.zero,
          ).animate(clampedAnimation),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: clampedAnimation,
              curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
              reverseCurve: const Interval(0.3, 1.0, curve: Curves.easeIn),
            ),
            child: child,
          ),
        );

      case SnackbarAnimation.bounce:
        // Enhanced: Squish effect on dismiss
        return FadeTransition(
          opacity: clampedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.8,
              end: 1.0,
            ).animate(clampedAnimation),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(
                  0,
                  position == SnackbarPosition.top ? -0.15 : 0.15,
                ),
                end: Offset.zero,
              ).animate(clampedAnimation),
              child: child,
            ),
          ),
        );

      case SnackbarAnimation.rotate:
        // Enhanced: Rotate and scale with slight tilt on dismiss
        final rotationAnimation = Tween<double>(
          begin: -0.12,
          end: 0.0,
        ).animate(clampedAnimation);
        return FadeTransition(
          opacity: clampedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(
                0.05,
                position == SnackbarPosition.top ? -0.2 : 0.2,
              ),
              end: Offset.zero,
            ).animate(clampedAnimation),
            child: RotationTransition(
              turns: rotationAnimation,
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.9,
                  end: 1.0,
                ).animate(clampedAnimation),
                child: child,
              ),
            ),
          ),
        );

      case SnackbarAnimation.elastic:
        // Enhanced: Compress effect on dismiss
        return FadeTransition(
          opacity: clampedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.75,
              end: 1.0,
            ).animate(clampedAnimation),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, position == SnackbarPosition.top ? -0.2 : 0.2),
                end: Offset.zero,
              ).animate(clampedAnimation),
              child: child,
            ),
          ),
        );

      case SnackbarAnimation.slideRotate:
        // Enhanced: More dramatic rotation and slide on dismiss
        final rotationAnimation = Tween<double>(
          begin: 0.15,
          end: 0.0,
        ).animate(clampedAnimation);
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: clampedAnimation,
            curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
            reverseCurve: const Interval(0.2, 1.0, curve: Curves.easeIn),
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0.1, position == SnackbarPosition.top ? -0.6 : 0.6),
              end: Offset.zero,
            ).animate(clampedAnimation),
            child: RotationTransition(turns: rotationAnimation, child: child),
          ),
        );

      case SnackbarAnimation.none:
        return child;
    }
  }
}
