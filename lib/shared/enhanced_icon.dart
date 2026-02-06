import 'package:flutter/material.dart';

/// Professional enhanced icon widget with animations and effects.
///
/// Used across dialogs, snackbars, and bottomsheets for consistent
/// premium icon styling with:
/// - Entrance animations
/// - Pulse glow effects
/// - Gradient icon fills
/// - Customizable container styling
class EnhancedIcon extends StatefulWidget {
  const EnhancedIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 28,
    this.containerSize = 60,
    this.backgroundColor,
    this.enableAnimation = true,
    this.enablePulse = true,
    this.showShadow = true,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double containerSize;
  final Color? backgroundColor;
  final bool enableAnimation;
  final bool enablePulse;
  final bool showShadow;

  @override
  State<EnhancedIcon> createState() => _EnhancedIconState();
}

class _EnhancedIconState extends State<EnhancedIcon>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    // Entrance animation with bounce
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _bounceAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Pulse animation for continuous subtle effect
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.2, end: 0.4).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.enableAnimation) {
      _entranceController.forward();
      if (widget.enablePulse) {
        _entranceController.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _pulseController.repeat(reverse: true);
          }
        });
      }
    } else {
      _entranceController.value = 1.0;
      if (widget.enablePulse) {
        _pulseController.repeat(reverse: true);
      }
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        widget.backgroundColor ??
        (isDark ? const Color(0xFF1F2937) : Colors.white);

    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleAnimation,
        _bounceAnimation,
        _pulseAnimation,
      ]),
      builder: (context, child) {
        final entranceScale = _scaleAnimation.value * _bounceAnimation.value;
        final pulseScale = widget.enablePulse ? _pulseAnimation.value : 1.0;
        final glowIntensity = widget.enablePulse ? _glowAnimation.value : 0.25;

        return Transform.scale(
          scale: entranceScale * pulseScale,
          child: _buildContainer(
            bgColor: bgColor,
            glowIntensity: glowIntensity,
            isDark: isDark,
          ),
        );
      },
    );
  }

  Widget _buildContainer({
    required Color bgColor,
    required double glowIntensity,
    required bool isDark,
  }) {
    return Container(
      width: widget.containerSize,
      height: widget.containerSize,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: widget.showShadow
            ? [
                // Colored glow
                BoxShadow(
                  color: widget.color.withValues(alpha: glowIntensity),
                  blurRadius: 20,
                  spreadRadius: -2,
                ),
                // Depth shadow
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                // Subtle inner highlight
                BoxShadow(
                  color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.8),
                  blurRadius: 1,
                  offset: const Offset(0, -1),
                  spreadRadius: -1,
                ),
              ]
            : null,
      ),
      child: Center(child: _buildGradientIcon()),
    );
  }

  /// Builds icon with gradient fill for a premium look
  Widget _buildGradientIcon() {
    final baseColor = widget.color;
    final lighterColor = _adjustLightness(baseColor, 0.15);
    final darkerColor = _adjustLightness(baseColor, -0.1);

    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [lighterColor, baseColor, darkerColor],
          stops: const [0.0, 0.45, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: Icon(widget.icon, size: widget.size, color: Colors.white),
    );
  }

  Color _adjustLightness(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }
}

/// A simpler version without animations for static contexts
class StaticEnhancedIcon extends StatelessWidget {
  const StaticEnhancedIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 28,
    this.containerSize = 60,
    this.backgroundColor,
    this.showShadow = true,
    this.glowIntensity = 0.25,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double containerSize;
  final Color? backgroundColor;
  final bool showShadow;
  final double glowIntensity;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        backgroundColor ?? (isDark ? const Color(0xFF1F2937) : Colors.white);

    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: color.withValues(alpha: glowIntensity),
                  blurRadius: 20,
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Center(child: _buildGradientIcon(isDark)),
    );
  }

  Widget _buildGradientIcon(bool isDark) {
    final baseColor = color;
    final lighterColor = _adjustLightness(baseColor, 0.15);
    final darkerColor = _adjustLightness(baseColor, -0.1);

    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [lighterColor, baseColor, darkerColor],
          stops: const [0.0, 0.45, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: Icon(icon, size: size, color: Colors.white),
    );
  }

  Color _adjustLightness(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }
}
