import 'package:flutter/material.dart';
import 'package:savepoints_modern_ui/snackbar/snackbar_enums.dart';
import 'package:savepoints_modern_ui/snackbar/snackbar_constants.dart';

/// Animated icon with scale animation
class AnimatedIcon extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final SnackbarType type;
  final SnackbarAnimation animation;

  const AnimatedIcon({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.type,
    required this.animation,
  });

  @override
  State<AnimatedIcon> createState() => AnimatedIconState();
}

class AnimatedIconState extends State<AnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.animation != SnackbarAnimation.none) {
      _controller = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      );
      _scaleAnimation = CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      );
      _controller.forward();
    } else {
      _controller = AnimationController(
        duration: const Duration(milliseconds: 1),
        vsync: this,
      );
      _scaleAnimation = const AlwaysStoppedAnimation(1.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconWidget = Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: widget.iconColor.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.icon,
        size: SnackbarConstants.iconSize,
        color: widget.iconColor,
      ),
    );

    if (widget.animation == SnackbarAnimation.none) {
      return iconWidget;
    }

    return ScaleTransition(scale: _scaleAnimation, child: iconWidget);
  }
}
