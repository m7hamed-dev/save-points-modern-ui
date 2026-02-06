import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/button_shadows.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_constants.dart';

/// Professional animated button widget with enhanced interactions
class ModernButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool isPrimary;
  final bool isDark;
  final bool isOutlined;

  const ModernButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.isPrimary = false,
    required this.isDark,
    this.isOutlined = false,
  });

  @override
  State<ModernButton> createState() => ModernButtonState();
}

class ModernButtonState extends State<ModernButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Enhanced button styling
    final BoxDecoration decoration;

    if (widget.isOutlined) {
      // Outlined button with subtle background on press
      decoration = BoxDecoration(
        color: _isPressed
            ? widget.foregroundColor.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(DialogConstants.buttonBorderRadius),
        border: Border.all(
          color: widget.foregroundColor.withValues(
            alpha: widget.isDark ? 0.6 : 0.4,
          ),
          width: 1.5,
        ),
      );
    } else if (widget.isPrimary) {
      // Primary button with gradient and enhanced shadow
      decoration = BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.backgroundColor,
            HSLColor.fromColor(widget.backgroundColor)
                .withLightness(
                  (HSLColor.fromColor(widget.backgroundColor).lightness - 0.08)
                      .clamp(0.0, 1.0),
                )
                .toColor(),
          ],
        ),
        borderRadius: BorderRadius.circular(DialogConstants.buttonBorderRadius),
        boxShadow: ButtonShadows.getPrimaryShadow(widget.backgroundColor),
      );
    } else {
      // Secondary button with subtle styling
      decoration = BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(DialogConstants.buttonBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      );
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: DialogConstants.buttonMinHeight,
          ),
          child: Container(
            padding: DialogConstants.buttonPadding,
            decoration: decoration,
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: widget.foregroundColor,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }
}
