import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart' hide AnimatedIcon;
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_enums.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_constants.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_shadows.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/animated_icon.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/progress_indicator_bar.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/animated_wrapper.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/clamped_animation.dart';

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
  });

  @override
  State<ModernSnackbarContent> createState() => ModernSnackbarContentState();
}

class ModernSnackbarContentState extends State<ModernSnackbarContent>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _entranceController;
  late Animation<double> _entranceAnimation;
  Timer? _timer;
  ImageFilter? _cachedBackdropFilter;
  double? _lastBlur;
  ImageFilter? _lastBackdropFilterParam;

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
    );
    _entranceAnimation = _getAnimation(widget.animation);
    _entranceController.forward();
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

  Animation<double> _getAnimation(SnackbarAnimation animation) {
    switch (animation) {
      case SnackbarAnimation.fadeSlide:
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );
      case SnackbarAnimation.scale:
        return ClampedAnimation(
          Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _entranceController,
              curve: Curves.elasticOut,
            ),
          ),
        );
      case SnackbarAnimation.slide:
        return ClampedAnimation(
          Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _entranceController,
              curve: Curves.easeOutBack,
            ),
          ),
        );
      case SnackbarAnimation.bounce:
        return ClampedAnimation(
          Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _entranceController,
              curve: Curves.bounceOut,
            ),
          ),
        );
      case SnackbarAnimation.rotate:
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutBack,
          ),
        );
      case SnackbarAnimation.elastic:
        return ClampedAnimation(
          Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _entranceController,
              curve: Curves.elasticOut,
            ),
          ),
        );
      case SnackbarAnimation.slideRotate:
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );
      case SnackbarAnimation.none:
        return const AlwaysStoppedAnimation(1.0);
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
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
    _cachedBackdropFilter =
        backdropFilter ??
        (b != null && b <= 0
            ? null
            : ImageFilter.blur(sigmaX: b ?? 20.0, sigmaY: b ?? 20.0));
    return _cachedBackdropFilter;
  }

  Widget _wrapWithBackdrop(Widget child) {
    final filter = _getBackdropFilter();
    if (filter == null) return child;
    return ClipRect(
      child: BackdropFilter(filter: filter, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = RepaintBoundary(
      child: Container(
        constraints: BoxConstraints(maxWidth: widget.maxWidth),
        decoration: BoxDecoration(
          color: widget.gradient == null ? widget.backgroundColor : null,
          gradient: widget.gradient,
          borderRadius: widget.borderRadius,
          boxShadow: SnackbarShadows.getShadows(),
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
                                  style: const TextStyle(
                                    fontSize: SnackbarConstants.titleFontSize,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2,
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
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ],
                            ),
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

    return AnimatedWrapper(
      animation: _entranceAnimation,
      animationType: widget.animation,
      position: widget.position,
      child: content,
    );
  }
}
