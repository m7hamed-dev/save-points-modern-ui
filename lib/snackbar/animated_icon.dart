import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_enums.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_constants.dart';

/// Animated icon widget with scale animation for snackbars.
///
/// This widget displays an icon with an optional scale animation effect
/// based on the specified [SnackbarAnimation] type.
/// For [ContentDesignStyle.outlined], the icon sits in a bordered circle.
class AnimatedIcon extends StatefulWidget {
  /// Creates an animated icon widget.
  const AnimatedIcon({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.type,
    required this.animation,
    this.designStyle,
  });

  /// The icon data to display.
  final IconData icon;

  /// The color of the icon.
  final Color iconColor;

  /// The snackbar type (affects styling).
  final SnackbarType type;

  /// The animation type to apply to the icon.
  final SnackbarAnimation animation;

  /// When [ContentDesignStyle.outlined], uses bordered circle instead of filled.
  final ContentDesignStyle? designStyle;

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
    final isOutlined = widget.designStyle == ContentDesignStyle.outlined;
    final isColorHeader = widget.designStyle == ContentDesignStyle.colorHeader;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    BoxDecoration decoration;
    if (isColorHeader) {
      // For colorHeader style: enhanced circle with subtle glow
      decoration = BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: widget.iconColor.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      );
    } else if (isOutlined) {
      // Enhanced outlined style with subtle gradient border effect
      decoration = BoxDecoration(
        color: widget.iconColor.withValues(alpha: isDark ? 0.12 : 0.06),
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.iconColor.withValues(alpha: isDark ? 0.6 : 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.iconColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );
    } else {
      // Enhanced solid style with gradient-like effect
      decoration = BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.iconColor.withValues(alpha: 0.25),
            widget.iconColor.withValues(alpha: 0.15),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: widget.iconColor.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );
    }

    final iconWidget = Container(
      width: SnackbarConstants.iconContainerSize,
      height: SnackbarConstants.iconContainerSize,
      alignment: Alignment.center,
      decoration: decoration,
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
