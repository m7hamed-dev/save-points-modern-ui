import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_color_config.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_container.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_icon.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_title.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_message.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_buttons.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_loading_indicator.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_constants.dart';

/// Modern dialog widget with loading support
class ModernDialog extends StatefulWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;
  final bool showCancelButton;
  final VoidCallback? onConfirm;
  final Future<bool>? Function()? onConfirmAsync;
  final VoidCallback? onCancel;
  final bool isDark;
  final bool isLoading;
  final ValueNotifier<bool>? loadingNotifier;
  final double? blur;
  final ImageFilter? backdropFilter;
  final ContentDesignStyle? designStyle;

  const ModernDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.showCancelButton,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.confirmButtonColor,
    this.cancelButtonColor,
    this.onConfirm,
    this.onConfirmAsync,
    this.onCancel,
    required this.isDark,
    this.isLoading = false,
    this.loadingNotifier,
    this.blur,
    this.backdropFilter,
    this.designStyle,
  });

  @override
  State<ModernDialog> createState() => _ModernDialogState();
}

class _ModernDialogState extends State<ModernDialog> {
  late bool _isLoading;
  late ValueNotifier<bool>? _loadingNotifier;
  DialogColorConfig? _cachedColorConfig;
  ThemeData? _cachedTheme;
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
  void didUpdateWidget(ModernDialog oldWidget) {
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
    // Cache theme and color config when dependencies change
    _cachedTheme = Theme.of(context);
    _cachedColorConfig = DialogColorConfig(
      theme: _cachedTheme!,
      isDark: widget.isDark,
      iconColor: widget.iconColor,
      backgroundColor: widget.backgroundColor,
      confirmButtonColor: widget.confirmButtonColor,
      cancelButtonColor: widget.cancelButtonColor,
      designStyle: widget.designStyle,
    );
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
        DialogColorConfig(
          theme: Theme.of(context),
          isDark: widget.isDark,
          iconColor: widget.iconColor,
          backgroundColor: widget.backgroundColor,
          confirmButtonColor: widget.confirmButtonColor,
          cancelButtonColor: widget.cancelButtonColor,
          designStyle: widget.designStyle,
        );

    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            margin: DialogConstants.dialogMargin,
            constraints: const BoxConstraints(
              maxWidth: DialogConstants.maxDialogWidth,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(DialogConstants.borderRadius),
              child: _buildContent(
                blur: widget.blur,
                backdropFilter: widget.backdropFilter,
                child: DialogContainer(
                  colorConfig: colorConfig,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null)
                        RepaintBoundary(
                          child: DialogIcon(
                            icon: widget.icon!,
                            color: colorConfig.iconColor,
                            designStyle: colorConfig.designStyle,
                          ),
                        ),
                      RepaintBoundary(
                        child: DialogTitle(
                          title: widget.title,
                          isDark: widget.isDark,
                          color: colorConfig.titleColor,
                        ),
                      ),
                      const SizedBox(
                        height: DialogConstants.contentSpacingAfterTitle,
                      ),
                      RepaintBoundary(
                        child: DialogMessage(
                          message: widget.message,
                          isDark: widget.isDark,
                          color: colorConfig.messageColor,
                        ),
                      ),
                      const SizedBox(
                        height: DialogConstants.contentSpacingAfterMessage,
                      ),
                      // Main content: loading indicator or action buttons
                      if (_isLoading)
                        RepaintBoundary(
                          child: DialogLoadingIndicator(
                            color: colorConfig.confirmColor,
                          ),
                        )
                      else
                        RepaintBoundary(
                          child: DialogButtons(
                            confirmText: widget.confirmText,
                            cancelText: widget.cancelText,
                            showCancelButton: widget.showCancelButton,
                            confirmColor: colorConfig.confirmColor,
                            cancelColor: colorConfig.cancelColor,
                            isDark: widget.isDark,
                            isOutlined: colorConfig.designStyle == ContentDesignStyle.outlined,
                            onConfirm: () => _handleConfirm(context),
                            onCancel: () => _handleCancel(context),
                          ),
                        ),
                    ],
                  ),
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

  Future<void> _handleConfirm(BuildContext context) async {
    if (_isLoading) return;

    HapticFeedback.lightImpact();

    // Handle async confirm callback
    if (widget.onConfirmAsync != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final onConfirmAsync = widget.onConfirmAsync;
        if (onConfirmAsync != null) {
          final shouldClose = await onConfirmAsync();
          if (shouldClose == true && mounted) {
            if (context.mounted) {
              Navigator.of(context).pop(true);
            }
          } else if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        rethrow;
      }
    } else {
      // Handle sync confirm callback
      Navigator.of(context).pop(true);
      widget.onConfirm?.call();
    }
  }

  void _handleCancel(BuildContext context) {
    if (_isLoading) return;

    HapticFeedback.lightImpact();
    Navigator.of(context).pop(false);
    widget.onCancel?.call();
  }
}
