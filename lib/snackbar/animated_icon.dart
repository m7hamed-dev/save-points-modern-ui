import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_enums.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_constants.dart';

/// Animated icon widget with scale animation for snackbars.
///
/// This widget displays an icon with an optional scale animation effect
/// based on the specified [SnackbarAnimation] type.
class AnimatedIcon extends StatefulWidget {
  /// The icon data to display.
  final IconData icon;

  /// The color of the icon.
  final Color iconColor;

  /// The snackbar type (affects styling).
  final SnackbarType type;

  /// The animation type to apply to the icon.
  final SnackbarAnimation animation;

  /// Creates an animated icon widget.
  ///
  /// The [icon], [iconColor], [type], and [animation] parameters are required.
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
