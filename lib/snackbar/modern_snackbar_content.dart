import 'dart:ui';

import 'package:material_ui/material_ui.dart' hide AnimatedIcon;
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/color_header_band.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/sp_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/pulse_scope.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/animated_icon.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/animated_wrapper.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/progress_indicator_bar.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_constants.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_enums.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_shadows.dart';

/// Modern snackbar content with enhanced features
class ModernSnackbarContent extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Gradient? gradient;
  final bool showProgressIndicator;
  final Duration duration;
  final SnackbarType type;
  final SnackbarPosition position;
  final SnackbarAnimation animation;
  final BorderRadius borderRadius;
  final double maxWidth;
  final bool dismissOnTap;
  final VoidCallback? onTap;
  final double? blur;
  final ImageFilter? backdropFilter;
  final ContentDesignStyle designStyle;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? borderColor;
  final bool showCloseButton;
  final VoidCallback? onCloseButtonPressed;

  const ModernSnackbarContent({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.gradient,
    required this.showProgressIndicator,
    required this.duration,
    required this.type,
    required this.position,
    required this.animation,
    required this.borderRadius,
    required this.maxWidth,
    this.dismissOnTap = false,
    this.onTap,
    this.blur,
    this.backdropFilter,
    this.designStyle = ContentDesignStyle.solid,
    this.titleColor,
    this.subtitleColor,
    this.borderColor,
    this.showCloseButton = false,
    this.onCloseButtonPressed,
  });

  @override
  State<ModernSnackbarContent> createState() => ModernSnackbarContentState();
}

class ModernSnackbarContentState extends State<ModernSnackbarContent>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _entranceController;
  ImageFilter? _cachedBackdropFilter;
  double? _lastBlur;
  ImageFilter? _lastBackdropFilterParam;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    if (widget.showProgressIndicator) {
      _progressController = AnimationController(
        duration: widget.duration,
        vsync: this,
      )..forward();
    } else {
      _progressController = AnimationController(
        duration: const Duration(milliseconds: 1),
        vsync: this,
      );
    }

    _entranceController = AnimationController(
      duration: _getAnimationDuration(widget.animation),
      vsync: this,
    )..forward();
  }

  Duration _getAnimationDuration(SnackbarAnimation animation) {
    switch (animation) {
      case SnackbarAnimation.fadeSlide:
        return const Duration(milliseconds: 400);
      case SnackbarAnimation.scale:
        return const Duration(milliseconds: 300);
      case SnackbarAnimation.slide:
        return const Duration(milliseconds: 350);
      case SnackbarAnimation.bounce:
        return const Duration(milliseconds: 500);
      case SnackbarAnimation.rotate:
        return const Duration(milliseconds: 400);
      case SnackbarAnimation.elastic:
        return const Duration(milliseconds: 600);
      case SnackbarAnimation.slideRotate:
        return const Duration(milliseconds: 450);
      case SnackbarAnimation.none:
        return const Duration(milliseconds: 1);
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap?.call();
    if (widget.dismissOnTap) {
      _animateDismiss();
    }
  }

  /// Animates the snackbar out before dismissing with enhanced exit animation
  void _animateDismiss() {
    if (_isDismissing) return;
    _isDismissing = true;

    // Use a faster duration for dismiss to feel more responsive
    final dismissDuration = _getDismissDuration(widget.animation);

    // Create a new animation controller for dismiss with optimized duration
    _entranceController.duration = dismissDuration;

    // Reverse the entrance animation for exit
    _entranceController.reverse().then((_) {
      if (mounted) {
        // Use removeCurrentSnackBar to avoid Flutter's dismiss animation conflicting
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
      }
    });
  }

  /// Get optimized dismiss duration based on animation type
  Duration _getDismissDuration(SnackbarAnimation animation) {
    switch (animation) {
      case SnackbarAnimation.fadeSlide:
        return const Duration(milliseconds: 250);
      case SnackbarAnimation.scale:
        return const Duration(milliseconds: 200);
      case SnackbarAnimation.slide:
        return const Duration(milliseconds: 220);
      case SnackbarAnimation.bounce:
        return const Duration(milliseconds: 200);
      case SnackbarAnimation.rotate:
        return const Duration(milliseconds: 280);
      case SnackbarAnimation.elastic:
        return const Duration(milliseconds: 250);
      case SnackbarAnimation.slideRotate:
        return const Duration(milliseconds: 300);
      case SnackbarAnimation.none:
        return const Duration(milliseconds: 1);
    }
  }

  ImageFilter? _getBackdropFilter() {
    final b = widget.blur;
    final backdropFilter = widget.backdropFilter;
    if (b == _lastBlur && backdropFilter == _lastBackdropFilterParam) {
      return _cachedBackdropFilter;
    }
    _lastBlur = b;
    _lastBackdropFilterParam = backdropFilter;
    // Optional blur: only apply when blur or backdropFilter is explicitly set.
    _cachedBackdropFilter = backdropFilter ??
        (b != null && b > 0 ? ImageFilter.blur(sigmaX: b, sigmaY: b) : null);
    return _cachedBackdropFilter;
  }

  Widget _wrapWithBackdrop(Widget child) {
    final filter = _getBackdropFilter();
    if (filter == null) return child;
    return ClipRect(
      child: BackdropFilter(filter: filter, child: child),
    );
  }

  Color get _effectiveTitleColor {
    if (widget.designStyle != ContentDesignStyle.solid &&
        widget.titleColor != null) {
      return widget.titleColor!;
    }
    if (widget.designStyle == ContentDesignStyle.colorHeader) {
      return _isDark ? Colors.white : const Color(0xFF424242);
    }
    if (widget.designStyle == ContentDesignStyle.leftAccent ||
        widget.designStyle == ContentDesignStyle.tonal) {
      return _isDark ? Colors.white : const Color(0xFF424242);
    }
    return Colors.white;
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _effectiveSubtitleColor {
    if (widget.designStyle != ContentDesignStyle.solid &&
        widget.subtitleColor != null) {
      return widget.subtitleColor!;
    }
    if (widget.designStyle == ContentDesignStyle.colorHeader) {
      return _isDark ? Colors.grey[400]! : const Color(0xFF616161);
    }
    if (widget.designStyle == ContentDesignStyle.leftAccent ||
        widget.designStyle == ContentDesignStyle.tonal) {
      return _isDark ? Colors.grey[400]! : const Color(0xFF616161);
    }
    return Colors.white.withValues(alpha: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    final isColorHeader = widget.designStyle == ContentDesignStyle.colorHeader;

    final content =
        isColorHeader ? _buildColorHeaderLayout() : _buildDefaultLayout();

    // A snackbar appears without the user asking for it, so it has to be
    // announced rather than merely readable: `liveRegion` makes TalkBack and
    // VoiceOver speak it as soon as it lands.
    //
    // `explicitChildNodes` rather than wrapping the content in
    // `ExcludeSemantics`: excluding the subtree does silence the duplicate
    // reading of the title, but it also swallows the close button, leaving no
    // way to dismiss the snackbar with a screen reader on.
    return Semantics(
      container: true,
      liveRegion: true,
      label: widget.subtitle == null
          ? widget.title
          : '${widget.title}. ${widget.subtitle}',
      explicitChildNodes: true,
      child: content,
    );
  }

  SpStyleSpec get _spec =>
      SpStyles.of(widget.designStyle, widget.iconColor, _isDark);

  /// The component's radius, scaled by whatever the style asks for.
  BorderRadius get _radius => BorderRadius.only(
        topLeft: widget.borderRadius.topLeft * _spec.radiusScale,
        topRight: widget.borderRadius.topRight * _spec.radiusScale,
        bottomLeft: widget.borderRadius.bottomLeft * _spec.radiusScale,
        bottomRight: widget.borderRadius.bottomRight * _spec.radiusScale,
      );

  /// Wraps [child] in a gradient stroke when the style calls for one; a
  /// gradient cannot be expressed as a [Border].
  Widget _withGradientStroke(Widget child) {
    final g = _spec.borderGradient;
    if (g == null) return child;
    return Container(
      padding: EdgeInsets.all(_spec.borderWidth),
      decoration: BoxDecoration(gradient: g, borderRadius: _radius),
      child: child,
    );
  }

  /// Per-variant border, resolved from the shared style spec.
  BoxBorder? _variantBorder() {
    final spec = SpStyles.of(widget.designStyle, widget.iconColor, _isDark);
    if (!spec.hasBorder) return null;
    // An explicit borderColor still wins for the outlined variant, which is
    // the one style callers routinely recolour.
    final color = widget.designStyle == ContentDesignStyle.outlined
        ? (widget.borderColor ?? spec.borderColor!)
        : spec.borderColor!;
    return Border.all(color: color, width: spec.borderWidth);
  }

  Widget _buildDefaultLayout() {
    final border = _variantBorder();
    final isGlass = widget.designStyle == ContentDesignStyle.glass;

    final isBottom = widget.position == SnackbarPosition.bottom;
    final constraints = BoxConstraints(
      maxWidth: widget.maxWidth,
      minWidth: isBottom ? SnackbarConstants.minWidthBottom : 0,
    );
    final showLeftAccent = widget.designStyle == ContentDesignStyle.leftAccent;

    Widget content = RepaintBoundary(
      child: _withGradientStroke(Container(
        constraints: constraints,
        decoration: BoxDecoration(
          // A caller-supplied gradient wins; otherwise the style may paint
          // its own wash across the surface.
          color: (widget.gradient ?? _spec.fillGradient) == null
              ? widget.backgroundColor
              : null,
          gradient: widget.gradient ?? _spec.fillGradient,
          borderRadius: _radius,
          border: _spec.borderGradient != null ? null : border,
          boxShadow: SnackbarShadows.getShadows(
            widget.designStyle,
            widget.iconColor,
            _isDark,
          ),
        ),
        child: showLeftAccent
            ? Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 5,
                    decoration: BoxDecoration(
                      color: widget.iconColor,
                      borderRadius: BorderRadius.only(
                        topLeft: widget.borderRadius.topLeft,
                        bottomLeft: widget.borderRadius.bottomLeft,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: widget.borderRadius.topRight,
                        bottomRight: widget.borderRadius.bottomRight,
                      ),
                      child: _buildDefaultLayoutContent(),
                    ),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: widget.borderRadius,
                child: _buildDefaultLayoutContent(),
              ),
      )),
    );
    if (isGlass) {
      content = ClipRRect(
        borderRadius: widget.borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: SpSurface.glassBlur,
            sigmaY: SpSurface.glassBlur,
          ),
          child: content,
        ),
      );
    }
    content = _wrapWithBackdrop(content);
    content = _wrapWithSwipeDismiss(content);

    return AnimatedBuilder(
      animation: _entranceController,
      builder: (context, child) {
        return AnimatedWrapper(
          animation: _entranceController,
          animationType: widget.animation,
          position: widget.position,
          isDismissing: _isDismissing,
          child: child!,
        );
      },
      child: content,
    );
  }

  Widget _buildDefaultLayoutContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap:
              widget.dismissOnTap || widget.onTap != null ? _handleTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SnackbarConstants.horizontalPadding,
              vertical: SnackbarConstants.verticalPadding,
            ),
            child: Row(
              children: [
                RepaintBoundary(
                  child: AnimatedIcon(
                    icon: widget.icon,
                    iconColor: widget.iconColor,
                    type: widget.type,
                    animation: widget.animation,
                    designStyle: widget.designStyle,
                  ),
                ),
                const SizedBox(width: SnackbarConstants.iconSpacing),
                Expanded(
                  child: DefaultTextStyle(
                    style: const TextStyle(decoration: TextDecoration.none),
                    child: RepaintBoundary(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: SnackbarConstants.titleFontSize,
                              color: _effectiveTitleColor,
                              fontWeight: SpType.titleWeight,
                              letterSpacing: SpType.titleTracking,
                              height: SnackbarConstants.titleLineHeight,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          if (widget.subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              widget.subtitle!,
                              style: TextStyle(
                                fontSize: SnackbarConstants.subtitleFontSize,
                                color: _effectiveSubtitleColor,
                                fontWeight: FontWeight.w400,
                                height: SnackbarConstants.subtitleLineHeight,
                                letterSpacing:
                                    SnackbarConstants.subtitleLetterSpacing,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                if (widget.showCloseButton)
                  IconButton(
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).closeButtonTooltip,
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: _effectiveTitleColor,
                    ),
                    onPressed: () {
                      if (widget.onCloseButtonPressed != null) {
                        widget.onCloseButtonPressed!();
                      } else {
                        _animateDismiss();
                      }
                    },
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(
                      minWidth: SnackbarConstants.minTouchTargetSize,
                      minHeight: SnackbarConstants.minTouchTargetSize,
                    ),
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (widget.showProgressIndicator)
          RepaintBoundary(
            child: ProgressIndicatorBar(
              animation: _progressController,
              color: widget.iconColor,
            ),
          ),
      ],
    );
  }

  /// Wraps content with swipe-to-dismiss gesture
  Widget _wrapWithSwipeDismiss(Widget content) {
    if (!widget.dismissOnTap) return content;

    final isTop = widget.position == SnackbarPosition.top;

    return Dismissible(
      key: UniqueKey(),
      direction: isTop ? DismissDirection.up : DismissDirection.down,
      onDismissed: (_) {
        if (mounted && !_isDismissing) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        }
      },
      dismissThresholds: const {
        DismissDirection.up: 0.2,
        DismissDirection.down: 0.2,
      },
      child: content,
    );
  }

  Widget _buildColorHeaderLayout() {
    final isBottom = widget.position == SnackbarPosition.bottom;
    final constraints = BoxConstraints(
      maxWidth: widget.maxWidth,
      minWidth: isBottom ? SnackbarConstants.minWidthBottom : 0,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonColor =
        isDark ? const Color(0xFF374151) : const Color(0xFF1F2937);
    final iconBgColor = isDark ? const Color(0xFF1F2937) : Colors.white;

    Widget content = RepaintBoundary(
      child: Container(
        constraints: constraints,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius,
          boxShadow: SnackbarShadows.getShadows(
            widget.designStyle,
            widget.iconColor,
            _isDark,
          ),
        ),
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: GestureDetector(
            onTap:
                widget.dismissOnTap || widget.onTap != null ? _handleTap : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Colored header with icon - enhanced gradient
                ColorHeaderBand(
                  startColor:
                      SpPalette.gradientFrom(widget.iconColor).colors.first,
                  endColor:
                      SpPalette.gradientFrom(widget.iconColor).colors.last,
                  isDark: isDark,
                  icon: widget.icon,
                  iconColor: widget.iconColor,
                  iconBackgroundColor: iconBgColor,
                  enablePulse: resolvePulse(context),
                  onClose: widget.showCloseButton ? _animateDismiss : null,
                ),
                // Content area with enhanced typography
                Padding(
                  padding: const EdgeInsets.only(
                    top: 36,
                    left: 24,
                    right: 24,
                    bottom: 24,
                  ),
                  child: DefaultTextStyle(
                    style: const TextStyle(decoration: TextDecoration.none),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title with enhanced typography
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: _effectiveTitleColor,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                            height: 1.2,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        // Subtitle/Message with better readability
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            widget.subtitle!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: _effectiveSubtitleColor,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              letterSpacing: 0.1,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                        // Action button with enhanced styling
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: buttonColor.withValues(alpha: 0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                widget.onTap?.call();
                                if (widget.dismissOnTap) {
                                  _animateDismiss();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 28,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Progress indicator
                if (widget.showProgressIndicator)
                  RepaintBoundary(
                    child: ProgressIndicatorBar(
                      animation: _progressController,
                      color: widget.iconColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    content = _wrapWithBackdrop(content);
    content = _wrapWithSwipeDismiss(content);

    return AnimatedBuilder(
      animation: _entranceController,
      builder: (context, child) {
        return AnimatedWrapper(
          animation: _entranceController,
          animationType: widget.animation,
          position: widget.position,
          isDismissing: _isDismissing,
          child: child!,
        );
      },
      child: content,
    );
  }
}
