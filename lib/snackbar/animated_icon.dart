import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_enums.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_constants.dart';

/// Professional animated icon widget with multiple animation effects.
///
/// Features:
/// - Entrance animations (scale, bounce, elastic)
/// - Continuous subtle animations (pulse glow, gentle bounce)
/// - Gradient icon backgrounds
/// - Type-specific styling (success checkmark, error X, etc.)
class AnimatedIcon extends StatefulWidget {
  const AnimatedIcon({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.type,
    required this.animation,
    this.designStyle,
    this.enablePulse = true,
  });

  final IconData icon;
  final Color iconColor;
  final SnackbarType type;
  final SnackbarAnimation animation;
  final ContentDesignStyle? designStyle;

  /// Whether to enable subtle pulse animation after entrance
  final bool enablePulse;

  @override
  State<AnimatedIcon> createState() => AnimatedIconState();
}

class AnimatedIconState extends State<AnimatedIcon>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _initEntranceAnimation();
    _initPulseAnimation();
  }

  void _initEntranceAnimation() {
    if (widget.animation != SnackbarAnimation.none) {
      _entranceController = AnimationController(
        duration: _getEntranceDuration(),
        vsync: this,
      );
      _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _entranceController,
          curve: _getEntranceCurve(),
        ),
      );
      _entranceController.forward();
    } else {
      _entranceController = AnimationController(
        duration: const Duration(milliseconds: 1),
        vsync: this,
      );
      _scaleAnimation = const AlwaysStoppedAnimation(1.0);
    }
  }

  void _initPulseAnimation() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.15, end: 0.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.enablePulse && widget.animation != SnackbarAnimation.none) {
      // Start pulse after entrance animation completes
      _entranceController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _pulseController.repeat(reverse: true);
        }
      });
    } else if (widget.enablePulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  Duration _getEntranceDuration() {
    switch (widget.animation) {
      case SnackbarAnimation.bounce:
        return const Duration(milliseconds: 600);
      case SnackbarAnimation.elastic:
        return const Duration(milliseconds: 800);
      case SnackbarAnimation.scale:
        return const Duration(milliseconds: 400);
      case SnackbarAnimation.rotate:
        return const Duration(milliseconds: 500);
      default:
        return const Duration(milliseconds: 450);
    }
  }

  Curve _getEntranceCurve() {
    switch (widget.animation) {
      case SnackbarAnimation.bounce:
        return Curves.bounceOut;
      case SnackbarAnimation.elastic:
        return Curves.elasticOut;
      case SnackbarAnimation.scale:
        return Curves.easeOutBack;
      case SnackbarAnimation.rotate:
        return Curves.easeOutBack;
      default:
        return Curves.elasticOut;
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
    final isOutlined = widget.designStyle == ContentDesignStyle.outlined;
    final isColorHeader = widget.designStyle == ContentDesignStyle.colorHeader;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
      builder: (context, child) {
        final pulseScale = widget.enablePulse ? _pulseAnimation.value : 1.0;
        final glowIntensity = widget.enablePulse ? _glowAnimation.value : 0.2;

        return Transform.scale(
          scale: _scaleAnimation.value * pulseScale,
          child: _buildIconContainer(
            isDark: isDark,
            isOutlined: isOutlined,
            isColorHeader: isColorHeader,
            glowIntensity: glowIntensity,
          ),
        );
      },
    );
  }

  Widget _buildIconContainer({
    required bool isDark,
    required bool isOutlined,
    required bool isColorHeader,
    required double glowIntensity,
  }) {
    if (isColorHeader) {
      return _buildColorHeaderIcon(isDark, glowIntensity);
    } else if (isOutlined) {
      return _buildOutlinedIcon(isDark, glowIntensity);
    } else {
      return _buildSolidIcon(isDark, glowIntensity);
    }
  }

  Widget _buildColorHeaderIcon(bool isDark, double glowIntensity) {
    return Container(
      width: SnackbarConstants.iconContainerSize,
      height: SnackbarConstants.iconContainerSize,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          // Colored glow
          BoxShadow(
            color: widget.iconColor.withValues(alpha: glowIntensity),
            blurRadius: 16,
          ),
          // Depth shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: _buildGradientIcon(),
    );
  }

  Widget _buildOutlinedIcon(bool isDark, double glowIntensity) {
    return Container(
      width: SnackbarConstants.iconContainerSize,
      height: SnackbarConstants.iconContainerSize,
      decoration: BoxDecoration(
        color: widget.iconColor.withValues(alpha: isDark ? 0.1 : 0.05),
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.iconColor.withValues(alpha: isDark ? 0.5 : 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.iconColor.withValues(alpha: glowIntensity * 0.6),
            blurRadius: 12,
            spreadRadius: -2,
          ),
        ],
      ),
      child: _buildGradientIcon(),
    );
  }

  Widget _buildSolidIcon(bool isDark, double glowIntensity) {
    return Container(
      width: SnackbarConstants.iconContainerSize,
      height: SnackbarConstants.iconContainerSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.iconColor.withValues(alpha: 0.28),
            widget.iconColor.withValues(alpha: 0.15),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          // Inner glow effect
          BoxShadow(
            color: widget.iconColor.withValues(alpha: glowIntensity),
            blurRadius: 14,
            spreadRadius: -2,
          ),
          // Subtle depth
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildGradientIcon(),
    );
  }

  /// Builds icon with gradient fill for a premium look
  Widget _buildGradientIcon() {
    // Create gradient colors based on icon color
    final baseColor = widget.iconColor;
    final lighterColor = _lightenColor(baseColor, 0.15);
    final darkerColor = _darkenColor(baseColor, 0.1);

    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [lighterColor, baseColor, darkerColor],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: Icon(
        widget.icon,
        size: SnackbarConstants.iconSize,
        color: Colors.white, // This gets replaced by shader
      ),
    );
  }

  Color _lightenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }
}
