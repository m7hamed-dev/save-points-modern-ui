import 'package:material_ui/material_ui.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_constants.dart';

/// Professional dialog icon widget with enhanced animations and styling.
///
/// Features:
/// - Entrance scale animation with bounce
/// - Subtle continuous pulse glow effect
/// - Gradient icon fills
/// - Style-specific decorations
class DialogIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final ContentDesignStyle? designStyle;
  final bool enableAnimation;

  /// Loops a subtle scale + glow pulse for as long as the surface is on
  /// screen.
  ///
  /// Off by default: a never-ending animation keeps the whole app repainting
  /// for the lifetime of the dialog or snackbar, and it makes
  /// `pumpAndSettle()` hang in the tests of anyone using this package.
  final bool enablePulse;

  const DialogIcon({
    super.key,
    required this.icon,
    required this.color,
    this.designStyle,
    this.enableAnimation = true,
    this.enablePulse = false,
  });

  @override
  State<DialogIcon> createState() => _DialogIconState();
}

class _DialogIconState extends State<DialogIcon> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    // Entrance animation
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.elasticOut),
    );

    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 0.2, end: 0.35).animate(
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
    } else if (widget.enablePulse) {
      _entranceController.value = 1.0;
      _pulseController.repeat(reverse: true);
    } else {
      _entranceController.value = 1.0;
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
    final isOutlined = widget.designStyle == ContentDesignStyle.outlined ||
        widget.designStyle == ContentDesignStyle.leftAccent ||
        widget.designStyle == ContentDesignStyle.tonal ||
        widget.designStyle == ContentDesignStyle.glass ||
        widget.designStyle == ContentDesignStyle.neon ||
        widget.designStyle == ContentDesignStyle.minimal;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
          builder: (context, child) {
            final pulseScale = widget.enablePulse ? _pulseAnimation.value : 1.0;
            final glowIntensity =
                widget.enablePulse ? _glowAnimation.value : 0.25;

            return Transform.scale(
              scale: _scaleAnimation.value * pulseScale,
              child: _buildIconContainer(
                isDark: isDark,
                isOutlined: isOutlined,
                glowIntensity: glowIntensity,
              ),
            );
          },
        ),
        const SizedBox(height: DialogConstants.contentSpacingAfterIcon),
      ],
    );
  }

  Widget _buildIconContainer({
    required bool isDark,
    required bool isOutlined,
    required double glowIntensity,
  }) {
    if (isOutlined) {
      return _buildOutlinedIcon(isDark, glowIntensity);
    } else {
      return _buildSolidIcon(isDark, glowIntensity);
    }
  }

  Widget _buildOutlinedIcon(bool isDark, double glowIntensity) {
    return Container(
      padding: const EdgeInsets.all(DialogConstants.iconPadding),
      decoration: BoxDecoration(
        color: widget.color.withValues(alpha: isDark ? 0.16 : 0.10),
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.color.withValues(alpha: isDark ? 0.65 : 0.55),
          width: 2,
        ),
        boxShadow: [
          // Colored glow
          BoxShadow(
            color: widget.color.withValues(alpha: glowIntensity * 0.6),
            blurRadius: 16,
            spreadRadius: -2,
          ),
          // Depth shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: _buildGradientIcon(),
    );
  }

  /// The filled variant's chip: the accent gradient at full strength with a
  /// white glyph on top.
  ///
  /// It used to paint the same gradient at 22%/12% alpha, which on a white
  /// surface came out as a pale wash — the single weakest element in the
  /// family, and the reason `solid` did not read as bolder than `minimal`.
  Widget _buildSolidIcon(bool isDark, double glowIntensity) {
    return Container(
      padding: const EdgeInsets.all(DialogConstants.iconPadding),
      decoration: BoxDecoration(
        gradient: SpPalette.gradientFrom(widget.color),
        shape: BoxShape.circle,
        boxShadow: [
          // Colored glow
          BoxShadow(
            color: widget.color.withValues(alpha: glowIntensity),
            blurRadius: 20,
            spreadRadius: -4,
          ),
          // Depth shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        widget.icon,
        size: DialogConstants.iconSize,
        color: Colors.white,
      ),
    );
  }

  /// Builds icon with gradient fill for a premium look
  Widget _buildGradientIcon() {
    final baseColor = widget.color;
    final lighterColor = _lightenColor(baseColor, 0.12);
    final darkerColor = _darkenColor(baseColor, 0.08);

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
        size: DialogConstants.iconSize,
        color: Colors.white,
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
