import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_color_config.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_container.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_handle.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_constants.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_loading_indicator.dart';

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

  @override
  State<ModernBottomsheet> createState() => _ModernBottomsheetState();
}

class _ModernBottomsheetState extends State<ModernBottomsheet> {
  late bool _isLoading;
  late ValueNotifier<bool>? _loadingNotifier;
  BottomsheetColorConfig? _cachedColorConfig;
  double? _cachedMaxHeight;
  ImageFilter? _cachedBackdropFilter;
  double? _lastBlur;
  ImageFilter? _lastBackdropFilterParam;

  @override
  void initState() {
    super.initState();
    _isLoading = widget.isLoading;
    _loadingNotifier = widget.loadingNotifier;

    if (_loadingNotifier != null) {
      _loadingNotifier!.addListener(_onLoadingChanged);
    }
  }

  @override
  void didUpdateWidget(ModernBottomsheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loadingNotifier != widget.loadingNotifier) {
      oldWidget.loadingNotifier?.removeListener(_onLoadingChanged);
      _loadingNotifier = widget.loadingNotifier;
      _loadingNotifier?.addListener(_onLoadingChanged);
    }
    _isLoading = widget.isLoading;
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
    );

    if (widget.maxHeight == null) {
      final screenHeight = MediaQuery.sizeOf(context).height;
      _cachedMaxHeight = screenHeight * BottomsheetConstants.maxHeight;
    } else {
      _cachedMaxHeight = widget.maxHeight;
    }
  }

  @override
  void dispose() {
    if (_loadingNotifier != null) {
      _loadingNotifier!.removeListener(_onLoadingChanged);
    }
    super.dispose();
  }

  void _onLoadingChanged() {
    if (_loadingNotifier != null && mounted) {
      setState(() {
        _isLoading = _loadingNotifier!.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorConfig =
        _cachedColorConfig ??
        BottomsheetColorConfig(
          theme: Theme.of(context),
          isDark: widget.isDark,
          background: widget.backgroundColor,
          icon: widget.iconColor,
        );

    final maxHeight =
        _cachedMaxHeight ??
        (widget.maxHeight ??
            MediaQuery.sizeOf(context).height * BottomsheetConstants.maxHeight);

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
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    if (_isLoading)
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

  ImageFilter? _getBackdropFilter(double? blur, ImageFilter? backdropFilter) {
    if (blur == _lastBlur && backdropFilter == _lastBackdropFilterParam) {
      return _cachedBackdropFilter;
    }
    _lastBlur = blur;
    _lastBackdropFilterParam = backdropFilter;
    _cachedBackdropFilter =
        backdropFilter ??
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
