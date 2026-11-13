import 'dart:async';
import 'dart:ui';

import 'package:material_ui/material_ui.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/pulse_scope.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_theme.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/circular_reveal_clip.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/clamped_animation.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/modern_snackbar_content.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_animation_direction.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_constants.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_enums.dart';

/// Overlay-based snackbar for top positioning.
///
/// Only one top snackbar is visible at a time: calling [show] replaces any
/// toast already on screen. [show] returns an opaque token that identifies
/// that toast, so callers can dismiss *their own* toast via [hide] without
/// accidentally closing a newer one that has since replaced it.
class TopSnackbarOverlay {
  /// The single entry kept inserted in [_host].
  ///
  /// Toasts change what this entry *paints* rather than being inserted and
  /// removed themselves. Structurally mutating the overlay from a callback is
  /// what makes `OverlayEntry.remove()` race its own deferred insert, and it
  /// is the documented cause of the `mouse_tracker` `_debugDuringDeviceUpdate`
  /// assertion: the tree changing shape mid-hover forces the tracker to
  /// re-enter its update phase. One insert per overlay, then nothing but
  /// repaints.
  static OverlayEntry? _entry;

  /// The overlay [_entry] is inserted into, so a new route gets a new entry.
  static OverlayState? _host;

  /// What [_entry] paints; null means nothing is on screen.
  ///
  /// Deliberately never disposed: it is process-wide state with the same
  /// lifetime as the class itself.
  static final ValueNotifier<Widget?> _content = ValueNotifier<Widget?>(null);

  /// Identifies the toast currently on screen, so a stale [hide] is a no-op.
  static Object? _token;

  /// Fired exactly once when the current toast goes away, whatever the cause
  /// (timer expiry, user dismissal, or replacement by a newer toast).
  static VoidCallback? _onHidden;

  /// Shows a top toast, replacing any toast already on screen.
  ///
  /// Returns a token identifying this toast; pass it to [hide] to dismiss
  /// only this toast.
  static Object show(
    BuildContext context, {
    required String title,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    Color? backgroundColor,
    Gradient? gradient,
    Duration duration = const Duration(seconds: 3),
    SnackbarAnimation? animation,
    SnackbarAnimationDirection? startAnimation,
    SnackbarAnimationDirection? endAnimation,
    SnackbarType type = SnackbarType.info,
    bool dismissible = true,
    bool dismissOnTap = false,
    bool showProgressIndicator = false,

    /// Whether the toast retires itself once [duration] elapses.
    ///
    /// [SavePointsSnackbar] passes `false`: it backs each toast with a
    /// placeholder snack bar and lets that placeholder be the single clock,
    /// so the toast and the placeholder can never race to expire first.
    bool autoDismiss = true,
    BorderRadius? borderRadius,
    double? maxWidth,
    Color? borderColor,
    double borderWidth = 0,
    bool hideLikeCircle = false,
    VoidCallback? onTap,
    VoidCallback? onDismissed,
    double? blur,
    ImageFilter? backdropFilter,
    ContentDesignStyle designStyle = ContentDesignStyle.solid,
    Color? titleColor,
    Color? subtitleColor,
    bool showCloseButton = false,

    /// One-call override for the icon's looping pulse; null defers to the
    /// enclosing [SavePointsTheme].
    bool? enablePulse,
  }) {
    // Hide any existing overlay (this also fires its onDismissed).
    hide();

    final overlayState = Overlay.of(context);

    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final topMargin = topPadding + kToolbarHeight + 12.0;

    final token = Object();
    _token = token;
    // Routed through `hide`, which clears `_onHidden` before invoking it, so
    // `onDismissed` runs exactly once no matter how many paths race to it.
    _onHidden = onDismissed;

    _content.value = _TopSnackbarOverlayWidget(
      // A fresh key per toast, so each one gets its own State and replays
      // its entrance instead of reusing the previous toast's controller.
      key: ValueKey<Object>(token),
      token: token,
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconColor: iconColor,
      backgroundColor: backgroundColor,
      gradient: gradient,
      animation: animation,
      startAnimation: startAnimation,
      endAnimation: endAnimation,
      type: type,
      dismissible: dismissible,
      dismissOnTap: dismissOnTap,
      showProgressIndicator: showProgressIndicator,
      autoDismiss: autoDismiss,
      duration: duration,
      borderRadius:
          borderRadius ?? BorderRadius.circular(SnackbarConstants.borderRadius),
      maxWidth: maxWidth ?? SnackbarConstants.maxWidth,
      topMargin: topMargin,
      borderColor: borderColor,
      borderWidth: borderWidth,
      hideLikeCircle: hideLikeCircle,
      onTap: onTap,
      onDismissed: () => hide(token),
      blur: blur,
      backdropFilter: backdropFilter,
      designStyle: designStyle,
      titleColor: titleColor,
      subtitleColor: subtitleColor,
      showCloseButton: showCloseButton,
      enablePulse: enablePulse,
    );

    _attachTo(overlayState);
    return token;
  }

  /// Ensures the shared entry is inserted in [host], reusing it if it already
  /// is.
  ///
  /// Only the very first toast in a given overlay pays for an insert; every
  /// toast after it is a repaint of an entry that is already there.
  static void _attachTo(OverlayState host) {
    final entry = _entry;
    if (entry != null && identical(_host, host) && host.mounted) return;

    _discardEntry();
    _host = host;

    final fresh = OverlayEntry(
      builder: (context) => ValueListenableBuilder<Widget?>(
        valueListenable: _content,
        // A Stack, because the toast positions itself with [Positioned] and
        // the entry's builder result is no longer the overlay's direct child.
        builder: (context, toast, _) => Stack(
          fit: StackFit.expand,
          children: [?toast],
        ),
      ),
    );
    _entry = fresh;

    // Still deferred: inserting during build or hit-test is what the framework
    // objects to. Unlike before, this now happens once per overlay.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (identical(_entry, fresh) && host.mounted && !fresh.mounted) {
        host.insert(fresh);
      }
    });
  }

  /// Drops the shared entry, e.g. because a different overlay now owns us.
  static void _discardEntry() {
    final entry = _entry;
    _entry = null;
    _host = null;
    if (entry == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (entry.mounted) entry.remove();
    });
  }

  /// Takes the current toast off screen without running its `onDismissed`.
  ///
  /// Used when a newer toast is about to claim the slot: the caller then
  /// retires the outgoing toast's backing placeholder itself (via
  /// `ScaffoldMessenger.hideCurrentSnackBar`), which is the only safe way to
  /// do it. Letting the outgoing `onDismissed` close that placeholder instead
  /// races the messenger and trips `_snackBars.first == controller`.
  static void dismissSilently() {
    _onHidden = null;
    hide();
  }

  /// Forgets the current toast without animating or notifying.
  ///
  /// Called when the entry's [State] is disposed — for instance because the
  /// route or the whole widget tree went away underneath it. Without this the
  /// static slot kept pointing at a dead element, and the next toast tried to
  /// close a placeholder belonging to a disposed [ScaffoldMessenger].
  static void detach(Object token) {
    if (!identical(_token, token)) return;
    _token = null;
    _onHidden = null;
    // The widget is already being unmounted, so the content must not be
    // reassigned here — that would be a notification during a build. The next
    // `show` replaces it, and `_attachTo` rebuilds the entry if the overlay
    // that owned it went away with the widget.
  }

  /// Dismisses the current top toast.
  ///
  /// Pass the token returned by [show] to dismiss only that toast; a token
  /// belonging to a toast that has already gone away is a no-op. Passing no
  /// token dismisses whatever is on screen.
  static void hide([Object? token]) {
    if (token != null && !identical(_token, token)) return;

    _token = null;

    final onHidden = _onHidden;
    _onHidden = null;

    // Clearing the content repaints the entry that is already inserted. No
    // insert, no remove, no deferral — and so no window in which the overlay
    // changes shape underneath a hover.
    _content.value = null;

    onHidden?.call();
  }
}

/// Widget for top snackbar overlay
class _TopSnackbarOverlayWidget extends StatefulWidget {
  final Object token;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Gradient? gradient;
  final SnackbarAnimation? animation;
  final SnackbarAnimationDirection? startAnimation;
  final SnackbarAnimationDirection? endAnimation;
  final SnackbarType type;
  final bool dismissible;
  final bool dismissOnTap;
  final bool showProgressIndicator;
  final bool autoDismiss;
  final Duration duration;
  final BorderRadius borderRadius;
  final double maxWidth;
  final double topMargin;
  final Color? borderColor;
  final double borderWidth;
  final bool hideLikeCircle;
  final VoidCallback? onTap;
  final VoidCallback onDismissed;
  final double? blur;
  final ImageFilter? backdropFilter;
  final ContentDesignStyle designStyle;
  final Color? titleColor;
  final Color? subtitleColor;
  final bool showCloseButton;
  final bool? enablePulse;

  const _TopSnackbarOverlayWidget({
    super.key,
    required this.token,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.gradient,
    this.animation,
    this.startAnimation,
    this.endAnimation,
    required this.type,
    required this.dismissible,
    required this.dismissOnTap,
    required this.showProgressIndicator,
    required this.autoDismiss,
    required this.duration,
    required this.borderRadius,
    required this.maxWidth,
    required this.topMargin,
    this.borderColor,
    this.borderWidth = 0,
    this.hideLikeCircle = false,
    this.onTap,
    required this.onDismissed,
    this.blur,
    this.backdropFilter,
    this.designStyle = ContentDesignStyle.solid,
    this.titleColor,
    this.subtitleColor,
    this.showCloseButton = false,
    this.enablePulse,
  });

  @override
  State<_TopSnackbarOverlayWidget> createState() =>
      _TopSnackbarOverlayWidgetState();
}

class _TopSnackbarOverlayWidgetState extends State<_TopSnackbarOverlayWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _scaleAnimation;
  Animation<double>? _rotationAnimation;
  late Animation<double> _fadeAnimation;

  /// Owned by the State rather than by [TopSnackbarOverlay] so it dies with
  /// the widget. As a static it outlived the tree, and fired later against a
  /// disposed AnimationController and a disposed ScaffoldMessenger.
  Timer? _autoDismiss;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    if (widget.autoDismiss) {
      _autoDismiss = Timer(widget.duration, _handleDismiss);
    }

    // Use new animation system if startAnimation/endAnimation provided
    if (widget.startAnimation != null || widget.endAnimation != null) {
      _buildDirectionalAnimations();
    } else {
      // Fallback to old animation system
      _buildLegacyAnimations();
    }

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  void _buildDirectionalAnimations() {
    final startDir =
        widget.startAnimation ?? SnackbarAnimationDirection.fromTop;
    _buildEnterAnimation(startDir);
  }

  void _buildEnterAnimation(SnackbarAnimationDirection dir) {
    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    switch (dir) {
      case SnackbarAnimationDirection.fromTop:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(curvedAnimation);
        break;
      case SnackbarAnimationDirection.fromBottom:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(curvedAnimation);
        break;
      case SnackbarAnimationDirection.fromLeft:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(curvedAnimation);
        break;
      case SnackbarAnimationDirection.fromRight:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(curvedAnimation);
        break;
      case SnackbarAnimationDirection.scale:
        _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
        );
        break;
      case SnackbarAnimationDirection.rotateScale:
        _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
        );
        _rotationAnimation = Tween<double>(
          begin: -0.2,
          end: 0.0,
        ).animate(curvedAnimation);
        break;
      case SnackbarAnimationDirection.bounce:
      case SnackbarAnimationDirection.elastic:
        _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          ClampedAnimation(
            CurvedAnimation(
              parent: _controller,
              curve: dir == SnackbarAnimationDirection.elastic
                  ? Curves.elasticOut
                  : Curves.bounceOut,
            ),
          ),
        );
        break;
      case SnackbarAnimationDirection.fade:
      case SnackbarAnimationDirection.none:
        // Fade handled by _fadeAnimation
        break;
    }
  }

  void _buildLegacyAnimations() {
    final animation = widget.animation ?? SnackbarAnimation.fadeSlide;
    switch (animation) {
      case SnackbarAnimation.fadeSlide:
      case SnackbarAnimation.slide:
        _slideAnimation =
            Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
        );
        break;
      default:
        _slideAnimation = null;
    }
  }

  @override
  void dispose() {
    _autoDismiss?.cancel();
    _autoDismiss = null;
    TopSnackbarOverlay.detach(widget.token);
    _controller.dispose();
    super.dispose();
  }

  void _handleDismiss() {
    if (!mounted) return;
    _autoDismiss?.cancel();
    _autoDismiss = null;

    // Switch to exit animation if endAnimation is specified
    if (widget.endAnimation != null) {
      _buildExitAnimation(widget.endAnimation!);
      _controller.value = 1.0; // Reset to end
    }
    _controller.reverse().then((_) {
      if (mounted) widget.onDismissed();
    });
  }

  void _buildExitAnimation(SnackbarAnimationDirection dir) {
    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    );

    switch (dir) {
      case SnackbarAnimationDirection.fromTop: // Exit to top
        _slideAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, -1),
        ).animate(curvedAnimation);
        break;
      case SnackbarAnimationDirection.fromBottom: // Exit to bottom
        _slideAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, 1),
        ).animate(curvedAnimation);
        break;
      case SnackbarAnimationDirection.fromLeft: // Exit to left
        _slideAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-1, 0),
        ).animate(curvedAnimation);
        break;
      case SnackbarAnimationDirection.fromRight: // Exit to right
        _slideAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(1, 0),
        ).animate(curvedAnimation);
        break;
      case SnackbarAnimationDirection.scale:
        _scaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInBack),
        );
        break;
      case SnackbarAnimationDirection.rotateScale:
        _scaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInBack),
        );
        _rotationAnimation = Tween<double>(
          begin: 0.0,
          end: 0.2,
        ).animate(curvedAnimation);
        break;
      case SnackbarAnimationDirection.bounce:
      case SnackbarAnimationDirection.elastic:
        _scaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
          ClampedAnimation(
            CurvedAnimation(parent: _controller, curve: Curves.easeIn),
          ),
        );
        break;
      case SnackbarAnimationDirection.fade:
      case SnackbarAnimationDirection.none:
        // Fade handled by _fadeAnimation
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = FadeTransition(
      opacity: _fadeAnimation,
      child: _buildAnimatedContent(),
    );

    // Apply circular reveal if enabled
    if (widget.hideLikeCircle) {
      content = SnackbarCircularRevealClip(
        animation: _controller,
        alignment: Alignment.topCenter,
        child: content,
      );
    }

    content = pulseScope(
      SavePointsTheme.maybeOf(context),
      widget.enablePulse,
      content,
    );

    return Positioned(
      top: widget.topMargin,
      left: 16,
      right: 16,
      child: Center(child: content),
    );
  }

  Widget _buildAnimatedContent() {
    // Build based on available animations
    if (_slideAnimation != null) {
      return SlideTransition(
        position: _slideAnimation!,
        child: _buildScaleRotation(),
      );
    } else if (_scaleAnimation != null) {
      return _buildScaleRotation();
    } else {
      return _buildScaleRotation();
    }
  }

  Widget _buildScaleRotation() {
    Widget child = _buildSnackbarContent();

    if (_scaleAnimation != null) {
      child = ScaleTransition(scale: _scaleAnimation!, child: child);
    }

    if (_rotationAnimation != null) {
      child = RotationTransition(turns: _rotationAnimation!, child: child);
    }

    return child;
  }

  Widget _buildSnackbarContent() {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
        if (widget.dismissOnTap) {
          _handleDismiss();
        }
      },
      onHorizontalDragEnd: widget.dismissible
          ? (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity!.abs() > 500) {
                _handleDismiss();
              }
            }
          : null,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.maxWidth),
        child: Container(
          width: double.infinity,
          decoration: widget.designStyle != ContentDesignStyle.outlined &&
                  widget.borderWidth > 0 &&
                  widget.borderColor != null
              ? BoxDecoration(
                  border: Border.all(
                    color: widget.borderColor!,
                    width: widget.borderWidth,
                  ),
                  borderRadius: widget.borderRadius,
                )
              : null,
          child: ClipRRect(
            borderRadius: widget.borderRadius,
            child: ModernSnackbarContent(
              title: widget.title,
              subtitle: widget.subtitle,
              icon: widget.icon ?? Icons.info,
              iconColor: widget.iconColor ?? Colors.white,
              backgroundColor: widget.backgroundColor ?? Colors.black,
              gradient: widget.gradient,
              showProgressIndicator: widget.showProgressIndicator,
              duration: widget.duration,
              type: widget.type,
              position: SnackbarPosition.top,
              animation: widget.animation ?? SnackbarAnimation.none,
              borderRadius: widget.borderRadius,
              maxWidth: widget.maxWidth,
              dismissOnTap: widget.dismissOnTap,
              onTap: widget.onTap,
              blur: widget.blur,
              backdropFilter: widget.backdropFilter,
              designStyle: widget.designStyle,
              titleColor: widget.titleColor,
              subtitleColor: widget.subtitleColor,
              borderColor: widget.designStyle == ContentDesignStyle.outlined
                  ? widget.borderColor
                  : null,
              showCloseButton: widget.showCloseButton,
              onCloseButtonPressed:
                  widget.showCloseButton ? _handleDismiss : null,
            ),
          ),
        ),
      ),
    );
  }
}
