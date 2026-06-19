import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart' hide AnimatedIcon;
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/shared/enhanced_icon.dart';
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
  Timer? _timer;
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
    _timer?.cancel();
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
    _cachedBackdropFilter =
        backdropFilter ??
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
    if ((widget.designStyle == ContentDesignStyle.outlined ||
            widget.designStyle == ContentDesignStyle.colorHeader ||
            widget.designStyle == ContentDesignStyle.leftAccent ||
            widget.designStyle == ContentDesignStyle.tonal) &&
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
    if ((widget.designStyle == ContentDesignStyle.outlined ||
            widget.designStyle == ContentDesignStyle.colorHeader ||
            widget.designStyle == ContentDesignStyle.leftAccent ||
            widget.designStyle == ContentDesignStyle.tonal) &&
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

  /// Get the header gradient color for colorHeader style
  Color get _headerGradientColor {
    // Create a light pastel version based on icon color
    final hsl = HSLColor.fromColor(widget.iconColor);
    return hsl.withSaturation(0.3).withLightness(0.92).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final isColorHeader = widget.designStyle == ContentDesignStyle.colorHeader;

    if (isColorHeader) {
      return _buildColorHeaderLayout();
    }

    return _buildDefaultLayout();
  }

  Widget _buildDefaultLayout() {
    final hasBorder =
        widget.designStyle == ContentDesignStyle.outlined &&
        widget.borderColor != null;

    final isBottom = widget.position == SnackbarPosition.bottom;
    final constraints = BoxConstraints(
      maxWidth: widget.maxWidth,
      minWidth: isBottom ? SnackbarConstants.minWidthBottom : 0,
    );
    final showLeftAccent = widget.designStyle == ContentDesignStyle.leftAccent;

    Widget content = RepaintBoundary(
      child: Container(
        constraints: constraints,
        decoration: BoxDecoration(
          color: widget.gradient == null ? widget.backgroundColor : null,
          gradient: widget.gradient,
          borderRadius: widget.borderRadius,
          border: hasBorder
              ? Border.all(color: widget.borderColor!, width: 2)
              : null,
          boxShadow: SnackbarShadows.getShadows(widget.designStyle),
        ),
        child: showLeftAccent
            ? Row(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
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

  Widget _buildDefaultLayoutContent() {
    return Column(
      mainAxisSize: .min,
      children: [
        GestureDetector(
          onTap: widget.dismissOnTap || widget.onTap != null
              ? _handleTap
              : null,
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
                        mainAxisSize: .min,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: SnackbarConstants.titleFontSize,
                              color: _effectiveTitleColor,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
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
                        borderRadius: .circular(12),
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
    final buttonColor = isDark
        ? const Color(0xFF374151)
        : const Color(0xFF1F2937);
    final iconBgColor = isDark ? const Color(0xFF1F2937) : Colors.white;

    Widget content = RepaintBoundary(
      child: Container(
        constraints: constraints,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius,
          boxShadow: SnackbarShadows.getShadows(widget.designStyle),
        ),
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: GestureDetector(
            onTap: widget.dismissOnTap || widget.onTap != null
                ? _handleTap
                : null,
            child: Column(
              mainAxisSize: .min,
              children: [
                // Colored header with icon - enhanced gradient
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Header gradient background with smooth transition
                    Container(
                      width: double.infinity,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _headerGradientColor,
                            _headerGradientColor.withValues(
                              alpha: isDark ? 0.4 : 0.2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Subtle radial overlay for depth
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.topRight,
                            radius: 1.5,
                            colors: [
                              Colors.white.withValues(
                                alpha: isDark ? 0.05 : 0.15,
                              ),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Close button with enhanced styling
                    if (widget.showCloseButton)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (widget.onCloseButtonPressed != null) {
                                widget.onCloseButtonPressed!();
                              } else {
                                _animateDismiss();
                              }
                            },
                            borderRadius: .circular(12),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : Colors.black.withValues(alpha: 0.06),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : const Color(0xFF6B7280),
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Centered icon with enhanced animations
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: -26,
                      child: Center(
                        child: RepaintBoundary(
                          child: EnhancedIcon(
                            icon: widget.icon,
                            color: widget.iconColor,
                            size: 26,
                            containerSize: 52,
                            backgroundColor: iconBgColor,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                      mainAxisSize: .min,
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
                              borderRadius: .circular(24),
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
                                  borderRadius: .circular(24),
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
