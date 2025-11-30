import 'package:flutter/material.dart';
import 'package:save_points_modern_ui/snackbar/snackbar_constants.dart';

/// Progress indicator bar at the bottom
class ProgressIndicatorBar extends StatelessWidget {
  final AnimationController animation;
  final Color color;

  const ProgressIndicatorBar({
    super.key,
    required this.animation,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return LinearProgressIndicator(
          value: 1.0 - animation.value,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: SnackbarConstants.progressBarHeight,
        );
      },
    );
  }
}
