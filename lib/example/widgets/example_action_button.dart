/// Example widgets for the SavePoints UI demo application
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Animated action button widget for example demonstrations
///
/// Features ripple effects, hover animations, and interactive feedback.
class ExampleActionButton extends StatefulWidget {
  /// Icon to display on the button
  final IconData icon;

  /// Label text displayed below the icon
  final String label;

  /// Primary color for the button theme
  final Color color;

  /// Callback invoked when the button is pressed
  final VoidCallback onPressed;

  const ExampleActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  State<ExampleActionButton> createState() => _ExampleActionButtonState();
}

class _ExampleActionButtonState extends State<ExampleActionButton>
    with TickerProviderStateMixin {
  bool _isPressed = false;
  bool _isHovered = false;
  late AnimationController _rippleController;
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _rippleController.forward(from: 0);
    _iconController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _iconController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _iconController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()
              ..scaleByDouble(
                _isPressed ? 0.95 : (_isHovered ? 1.05 : 1.0),
                _isPressed ? 0.95 : (_isHovered ? 1.05 : 1.0),
                _isPressed ? 0.95 : (_isHovered ? 1.05 : 1.0),
                1.0,
              ),
            child: Card(
              elevation: _isHovered ? 6 : 2,
              shape: RoundedRectangleBorder(borderRadius: .circular(12)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: .circular(12),
                  gradient: _isHovered
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            widget.color.withValues(alpha: 0.1),
                            widget.color.withValues(alpha: 0.05),
                          ],
                        )
                      : null,
                ),
                child: Stack(
                  children: [
                    AnimatedBuilder(
                      animation: _rippleController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: RipplePainter(
                            progress: _rippleController.value,
                            color: widget.color.withValues(alpha: 0.3),
                          ),
                          child: Container(),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: .min,
                        children: [
                          AnimatedBuilder(
                            animation: _iconController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _iconController.value * 0.2 * math.pi,
                                child: Transform.scale(
                                  scale: 1.0 + (_iconController.value * 0.2),
                                  child: Icon(
                                    widget.icon,
                                    size: 32,
                                    color: widget.color,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _isHovered
                                  ? widget.color
                                  : Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for rendering ripple animation effects
class RipplePainter extends CustomPainter {
  /// Animation progress value (0.0 to 1.0)
  final double progress;

  /// Color of the ripple effect
  final Color color;

  RipplePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.sqrt(
      math.pow(size.width / 2, 2) + math.pow(size.height / 2, 2),
    );
    final radius = maxRadius * progress;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
