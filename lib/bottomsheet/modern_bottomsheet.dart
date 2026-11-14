import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_color_config.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_constants.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_container.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_handle.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_loading_indicator.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_shadows.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/color_header_band.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/pulse_scope.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/shared/loading_state_mixin.dart';

/// Modern bottom sheet widget
class ModernBottomsheet extends StatefulWidget {
  const ModernBottomsheet({
    super.key,
    this.title,
    this.child,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    required this.isDark,
    this.isLoading = false,
    this.loadingNotifier,
    this.showHandle = true,
    this.isDismissible = true,
    this.enableDrag = true,
    this.maxHeight,
    this.isScrollControlled = false,
    this.blur = 20.0,
    this.backdropFilter,
    this.designStyle,
  });

  final String? title;
  final Widget? child;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool isDark;
  final bool isLoading;
  final ValueNotifier<bool>? loadingNotifier;
  final bool showHandle;
  final bool isDismissible;
  final bool enableDrag;
  final double? maxHeight;
  final bool isScrollControlled;

  /// Optional blur sigma for the glassmorphism backdrop. When null, defaults to 20.
  /// Set to 0 to disable blur. Ignored when [backdropFilter] is non-null.
  final double? blur;

  /// Optional custom [ImageFilter] for the [BackdropFilter]. When set, overrides [blur].
  final ImageFilter? backdropFilter;

  final ContentDesignStyle? designStyle;

  @override
  State<ModernBottomsheet> createState() => _ModernBottomsheetState();
}

class _ModernBottomsheetState extends State<ModernBottomsheet>
    with LoadingStateMixin<ModernBottomsheet> {
  @override
  bool get widgetIsLoading => widget.isLoading;

  @override
  ValueNotifier<bool>? get widgetLoadingNotifier => widget.loadingNotifier;

  BottomsheetColorConfig? _cachedColorConfig;
  double? _cachedMaxHeight;
  ImageFilter? _cachedBackdropFilter;
  double? _lastBlur;
  ImageFilter? _lastBackdropFilterParam;

  @override
  void didUpdateWidget(ModernBottomsheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateLoadingState(
      oldIsLoading: oldWidget.isLoading,
      oldNotifier: oldWidget.loadingNotifier,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cache theme, color config, and MediaQuery values
    final theme = Theme.of(context);
    _cachedColorConfig = BottomsheetColorConfig(
      theme: theme,
      isDark: widget.isDark,
      background: widget.backgroundColor,
      icon: widget.iconColor,
      designStyle: widget.designStyle,
    );

    if (widget.maxHeight == null) {
      final screenHeight = MediaQuery.sizeOf(context).height;
      _cachedMaxHeight = screenHeight * BottomsheetConstants.maxHeight;
    } else {
      _cachedMaxHeight = widget.maxHeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorConfig = _cachedColorConfig ??
        BottomsheetColorConfig(
          theme: Theme.of(context),
          isDark: widget.isDark,
          background: widget.backgroundColor,
          icon: widget.iconColor,
          designStyle: widget.designStyle,
        );

    final isColorHeader =
        colorConfig.designStyle == ContentDesignStyle.colorHeader;

    if (isColorHeader) {
      return _buildColorHeaderLayout(context, colorConfig);
    }

    return _buildDefaultLayout(context, colorConfig);
  }

  Widget _buildDefaultLayout(
    BuildContext context,
    BottomsheetColorConfig colorConfig,
  ) {
    // Get keyboard height to adjust max height accordingly
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final keyboardHeight = viewInsets.bottom;
    final screenHeight = MediaQuery.sizeOf(context).height;

    // Calculate available height (screen height minus keyboard)
    final availableHeight = screenHeight - keyboardHeight;

    // Use the smaller of: configured maxHeight or available height (with some margin)
    final configuredMaxHeight = _cachedMaxHeight ??
        (widget.maxHeight ?? screenHeight * BottomsheetConstants.maxHeight);

    // When keyboard is visible, limit max height to available space minus safe margin
    final maxHeight = keyboardHeight > 0
        ? math.min(configuredMaxHeight, availableHeight - 20)
        : configuredMaxHeight;

    // Ensure minHeight is never greater than maxHeight
    final minHeight = math.min(BottomsheetConstants.minHeight, maxHeight);

    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
            minHeight: minHeight,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(BottomsheetConstants.borderRadius),
              topRight: Radius.circular(BottomsheetConstants.borderRadius),
            ),
            child: _buildContent(
              blur: widget.blur,
              backdropFilter: widget.backdropFilter,
              child: BottomsheetContainer(
                colorConfig: colorConfig,
                showTopRadius: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.showHandle)
                      RepaintBoundary(
                        child: Center(
                          child: BottomsheetHandle(
                            color: colorConfig.handleColor,
                          ),
                        ),
                      ),
                    if (widget.title != null || widget.icon != null) ...[
                      RepaintBoundary(
                        child: Row(
                          children: [
                            if (widget.icon != null) ...[
                              Icon(
                                widget.icon,
                                color: colorConfig.iconColor,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                            ],
                            if (widget.title != null)
                              Expanded(
                                child: Text(
                                  widget.title!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: colorConfig.textColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: BottomsheetConstants.titleSpacing),
                    ],
                    // Main content: loading indicator or scrollable child
                    if (isLoading)
                      RepaintBoundary(
                        child: BottomsheetLoadingIndicator(
                          color: colorConfig.iconColor,
                        ),
                      )
                    else if (widget.child != null)
                      Flexible(
                        child: RepaintBoundary(
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: widget.child!,
                          ),
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

  Widget _buildColorHeaderLayout(
    BuildContext context,
    BottomsheetColorConfig colorConfig,
  ) {
    // Get keyboard height to adjust max height accordingly
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final keyboardHeight = viewInsets.bottom;
    final screenHeight = MediaQuery.sizeOf(context).height;

    // Calculate available height (screen height minus keyboard)
    final availableHeight = screenHeight - keyboardHeight;

    // Use the smaller of: configured maxHeight or available height (with some margin)
    final configuredMaxHeight = _cachedMaxHeight ??
        (widget.maxHeight ?? screenHeight * BottomsheetConstants.maxHeight);

    // When keyboard is visible, limit max height to available space minus safe margin
    final maxHeight = keyboardHeight > 0
        ? math.min(configuredMaxHeight, availableHeight - 20)
        : configuredMaxHeight;

    // Ensure minHeight is never greater than maxHeight
    final minHeight = math.min(BottomsheetConstants.minHeight, maxHeight);

    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
            minHeight: minHeight,
          ),
          decoration: BoxDecoration(
            color: colorConfig.backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(BottomsheetConstants.borderRadius),
              topRight: Radius.circular(BottomsheetConstants.borderRadius),
            ),
            boxShadow: BottomsheetShadows.getShadows(
              widget.isDark,
              designStyle: ContentDesignStyle.colorHeader,
              accentColor: colorConfig.iconColor,
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(BottomsheetConstants.borderRadius),
              topRight: Radius.circular(BottomsheetConstants.borderRadius),
            ),
            child: _buildContent(
              blur: widget.blur,
              backdropFilter: widget.backdropFilter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Colored header with icon - enhanced gradient
                  ColorHeaderBand(
                    startColor: colorConfig.headerColor,
                    endColor: colorConfig.headerColorEnd,
                    isDark: widget.isDark,
                    icon: widget.icon,
                    iconColor: colorConfig.iconColor,
                    iconBackgroundColor: colorConfig.iconBackgroundColor,
                    enablePulse: resolvePulse(context),
                    onClose: () => Navigator.of(context).pop(),
                  ),
                  // Content area with enhanced spacing
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: widget.icon != null ? 44 : 28,
                        left: 28,
                        right: 28,
                        bottom: 28,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Title with enhanced typography
                          if (widget.title != null) ...[
                            RepaintBoundary(
                              child: Text(
                                widget.title!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: SpType.displaySize,
                                  fontWeight: SpType.displayWeight,
                                  color: colorConfig.textColor,
                                  letterSpacing: SpType.displayTracking,
                                  height: SpType.displayHeight,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                          ],
                          // Main content: loading indicator or scrollable child
                          if (isLoading)
                            RepaintBoundary(
                              child: BottomsheetLoadingIndicator(
                                color: colorConfig.iconColor,
                              ),
                            )
                          else if (widget.child != null)
                            Flexible(
                              child: RepaintBoundary(
                                child: SingleChildScrollView(
                                  physics: const ClampingScrollPhysics(),
                                  child: widget.child!,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ImageFilter? _getBackdropFilter(double? blur, ImageFilter? backdropFilter) {
    if (blur == _lastBlur && backdropFilter == _lastBackdropFilterParam) {
      return _cachedBackdropFilter;
    }
    _lastBlur = blur;
    _lastBackdropFilterParam = backdropFilter;
    _cachedBackdropFilter = backdropFilter ??
        (blur != null && blur <= 0
            ? null
            : ImageFilter.blur(sigmaX: blur ?? 20.0, sigmaY: blur ?? 20.0));
    return _cachedBackdropFilter;
  }

  Widget _buildContent({
    required double? blur,
    required ImageFilter? backdropFilter,
    required Widget child,
  }) {
    final filter = _getBackdropFilter(blur, backdropFilter);
    if (filter == null) {
      return child;
    }
    return ClipRect(
      child: BackdropFilter(filter: filter, child: child),
    );
  }
}
