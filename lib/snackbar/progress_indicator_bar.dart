import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_constants.dart';

/// Progress indicator bar at the bottom with rounded ends
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
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(SnackbarConstants.progressBarBorderRadius),
            bottomRight: Radius.circular(SnackbarConstants.progressBarBorderRadius),
          ),
          child: LinearProgressIndicator(
            value: 1.0 - animation.value,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: SnackbarConstants.progressBarHeight,
          ),
        );
      },
    );
  }
}
