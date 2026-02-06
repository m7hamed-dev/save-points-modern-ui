import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart' hide AnimatedIcon;
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_enums.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_constants.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_shadows.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/animated_icon.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/progress_indicator_bar.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/animated_wrapper.dart';

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

  /// Animates the snackbar out before dismissing
  void _animateDismiss() {
    if (_isDismissing) return;
    _isDismissing = true;

    // Reverse the entrance animation for exit
    _entranceController.reverse().then((_) {
      if (mounted) {
        // Use removeCurrentSnackBar to avoid Flutter's dismiss animation conflicting
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
      }
    });
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
            widget.designStyle == ContentDesignStyle.colorHeader) &&
        widget.titleColor != null) {
      return widget.titleColor!;
    }
    if (widget.designStyle == ContentDesignStyle.colorHeader) {
      return const Color(0xFF424242);
    }
    return Colors.white;
  }

  Color get _effectiveSubtitleColor {
    if ((widget.designStyle == ContentDesignStyle.outlined ||
            widget.designStyle == ContentDesignStyle.colorHeader) &&
        widget.subtitleColor != null) {
      return widget.subtitleColor!;
    }
    if (widget.designStyle == ContentDesignStyle.colorHeader) {
      return const Color(0xFF616161);
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
    final hasBorder = widget.designStyle == ContentDesignStyle.outlined &&
        widget.borderColor != null;

    final isBottom = widget.position == SnackbarPosition.bottom;
    final constraints = BoxConstraints(
      maxWidth: widget.maxWidth,
      minWidth: isBottom ? SnackbarConstants.minWidthBottom : 0,
    );
    Widget content = RepaintBoundary(
      child: Container(
        constraints: constraints,
        decoration: BoxDecoration(
          color: widget.gradient == null ? widget.backgroundColor : null,
          gradient: widget.gradient,
          borderRadius: widget.borderRadius,
          border: hasBorder
              ? Border.all(
                  color: widget.borderColor!,
                  width: 2,
                )
              : null,
          boxShadow: SnackbarShadows.getShadows(widget.designStyle),
        ),
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                          style: const TextStyle(
                            decoration: TextDecoration.none,
                          ),
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
                                      fontSize:
                                          SnackbarConstants.subtitleFontSize,
                                      color: _effectiveSubtitleColor,
                                      fontWeight: FontWeight.w400,
                                      height: SnackbarConstants.subtitleLineHeight,
                                      letterSpacing: SnackbarConstants.subtitleLetterSpacing,
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
          ),
        ),
      ),
    );
    content = _wrapWithBackdrop(content);

    return AnimatedBuilder(
      animation: _entranceController,
      builder: (context, child) {
        return AnimatedWrapper(
          animation: _entranceController,
          animationType: widget.animation,
          position: widget.position,
          child: child!,
        );
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
              mainAxisSize: MainAxisSize.min,
              children: [
                // Colored header with icon
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Header gradient background
                    Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            _headerGradientColor,
                            _headerGradientColor.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                    ),
                    // Close button
                    if (widget.showCloseButton)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            if (widget.onCloseButtonPressed != null) {
                              widget.onCloseButtonPressed!();
                            } else {
                              _animateDismiss();
                            }
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ),
                      ),
                    // Centered icon in circle
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: -24,
                      child: Center(
                        child: RepaintBoundary(
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              widget.icon,
                              size: 24,
                              color: widget.iconColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Content area
                Padding(
                  padding: const EdgeInsets.only(
                    top: 32,
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  child: DefaultTextStyle(
                    style: const TextStyle(decoration: TextDecoration.none),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: _effectiveTitleColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                            height: 1.3,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        // Subtitle/Message
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            widget.subtitle!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: _effectiveSubtitleColor,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                        // Action button
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              widget.onTap?.call();
                              if (widget.dismissOnTap) {
                                _animateDismiss();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2D2D2D),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
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

    return AnimatedBuilder(
      animation: _entranceController,
      builder: (context, child) {
        return AnimatedWrapper(
          animation: _entranceController,
          animationType: widget.animation,
          position: widget.position,
          child: child!,
        );
      },
      child: content,
    );
  }
}
