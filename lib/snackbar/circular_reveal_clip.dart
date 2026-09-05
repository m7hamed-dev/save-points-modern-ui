import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Widget that applies a circular reveal/hide animation for snackbars
class SnackbarCircularRevealClip extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  final AlignmentGeometry alignment;

  const SnackbarCircularRevealClip({
    super.key,
    required this.animation,
    required this.child,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxRadius = _calculateMaxRadius(screenSize);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final radius = animation.value * maxRadius;

        return ClipPath(
          clipper: _CircularRevealClipper(
            radius: radius,
            alignment: alignment,
            textDirection: Directionality.of(context),
          ),
          child: child,
        );
      },
      child: child,
    );
  }

  double _calculateMaxRadius(Size screenSize) {
    // Calculate diagonal distance to cover entire screen
    final diagonal = math.sqrt(
      screenSize.width * screenSize.width +
          screenSize.height * screenSize.height,
    );
    return diagonal / 2;
  }
}

/// Custom clipper for circular reveal animation
class _CircularRevealClipper extends CustomClipper<Path> {
  final double radius;
  final AlignmentGeometry alignment;
  final TextDirection textDirection;

  _CircularRevealClipper({
    required this.radius,
    required this.alignment,
    required this.textDirection,
  });

  @override
  Path getClip(Size size) {
    // Resolved against the ambient direction rather than a hard-coded
    // TextDirection.ltr, so a directional alignment (centerStart, topEnd, ...)
    // mirrors correctly in an RTL app instead of revealing from the wrong side.
    final align = alignment.resolve(textDirection);
    final center = align.inscribe(Size.zero, Offset.zero & size).center;

    final path = Path();
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    return path;
  }

  @override
  bool shouldReclip(_CircularRevealClipper oldClipper) {
    return oldClipper.radius != radius ||
        oldClipper.alignment != alignment ||
        oldClipper.textDirection != textDirection;
  }
}
