import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:save_points_modern_ui/bottomsheet/bottomsheet_color_config.dart';
import 'package:save_points_modern_ui/bottomsheet/bottomsheet_container.dart';
import 'package:save_points_modern_ui/bottomsheet/bottomsheet_handle.dart';
import 'package:save_points_modern_ui/bottomsheet/bottomsheet_constants.dart';
import 'package:save_points_modern_ui/bottomsheet/bottomsheet_loading_indicator.dart';

/// Modern bottom sheet widget
class ModernBottomsheet extends StatefulWidget {
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
  });

  @override
  State<ModernBottomsheet> createState() => _ModernBottomsheetState();
}

class _ModernBottomsheetState extends State<ModernBottomsheet> {
  late bool _isLoading;
  late ValueNotifier<bool>? _loadingNotifier;
  BottomsheetColorConfig? _cachedColorConfig;
  double? _cachedMaxHeight;

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
      final screenHeight = MediaQuery.of(context).size.height;
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
            MediaQuery.of(context).size.height *
                BottomsheetConstants.maxHeight);

    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
            minHeight: BottomsheetConstants.minHeight,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(BottomsheetConstants.topBorderRadius),
              topRight: Radius.circular(BottomsheetConstants.topBorderRadius),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
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
                    if (_isLoading)
                      RepaintBoundary(
                        child: BottomsheetLoadingIndicator(
                          color: colorConfig.iconColor,
                        ),
                      )
                    else if (widget.child != null)
                      Expanded(
                        child: RepaintBoundary(
                          child: SingleChildScrollView(child: widget.child!),
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
}
