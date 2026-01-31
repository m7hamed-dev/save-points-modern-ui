import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/button_shadows.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_constants.dart';

/// Modern animated button widget
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: DialogConstants.buttonPadding,
          decoration: BoxDecoration(
            color: widget.isOutlined ? Colors.transparent : widget.backgroundColor,
            borderRadius: BorderRadius.circular(
              DialogConstants.buttonBorderRadius,
            ),
            border: widget.isOutlined
                ? Border.all(color: widget.foregroundColor, width: 2)
                : null,
            boxShadow: widget.isPrimary && !widget.isOutlined
                ? ButtonShadows.getPrimaryShadow(widget.backgroundColor)
                : null,
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: widget.foregroundColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }
}
