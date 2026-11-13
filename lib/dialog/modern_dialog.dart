import 'dart:ui';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/color_header_band.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/pulse_scope.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_buttons.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_shadows.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_color_config.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_constants.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_container.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_icon.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_loading_indicator.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_message.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_title.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/shared/loading_state_mixin.dart';

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
  final Widget? child;

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
    this.child,
  });

  @override
  State<ModernDialog> createState() => _ModernDialogState();
}

class _ModernDialogState extends State<ModernDialog>
    with LoadingStateMixin<ModernDialog> {
  @override
  bool get widgetIsLoading => widget.isLoading;

  @override
  ValueNotifier<bool>? get widgetLoadingNotifier => widget.loadingNotifier;

  DialogColorConfig? _cachedColorConfig;
  ThemeData? _cachedTheme;
  ImageFilter? _cachedBackdropFilter;
  double? _lastBlur;
  ImageFilter? _lastBackdropFilterParam;

  @override
  void didUpdateWidget(ModernDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateLoadingState(
      oldIsLoading: oldWidget.isLoading,
      oldNotifier: oldWidget.loadingNotifier,
    );
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
  Widget build(BuildContext context) {
    final colorConfig = _cachedColorConfig ??
        DialogColorConfig(
          theme: Theme.of(context),
          isDark: widget.isDark,
          iconColor: widget.iconColor,
          backgroundColor: widget.backgroundColor,
          confirmButtonColor: widget.confirmButtonColor,
          cancelButtonColor: widget.cancelButtonColor,
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
    DialogColorConfig colorConfig,
  ) {
    return RepaintBoundary(
      // Center first, Material second. The other way round the transparent
      // Material filled the whole screen and hit-tested opaque, so it
      // swallowed every tap aimed at the barrier behind it and
      // barrierDismissible — true by default — did nothing. Center does not
      // hit-test itself, so a tap outside the card now falls through to the
      // barrier while the card still absorbs its own taps.
      child: Center(
        child: Padding(
            // The inset lives outside the Material, the way Flutter's own
            // Dialog places insetPadding: a tap in this band is a tap outside
            // the card, so it dismisses rather than being absorbed.
            padding: DialogConstants.dialogMargin,
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: DialogConstants.maxDialogWidth,
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(DialogConstants.borderRadius),
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
                                enablePulse: resolvePulse(context),
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
                          if (widget.message.isNotEmpty)
                            RepaintBoundary(
                              child: DialogMessage(
                                message: widget.message,
                                isDark: widget.isDark,
                                color: colorConfig.messageColor,
                              ),
                            ),
                          if (widget.message.isNotEmpty)
                            const SizedBox(
                              height:
                                  DialogConstants.contentSpacingAfterMessage,
                            ),
                          // Optional custom child widget
                          if (widget.child != null) ...[
                            Container(
                              color: Colors.blue.withValues(alpha: 0.1),
                              child: widget.child!,
                            ),
                            const SizedBox(height: 16),
                          ],
                          // Main content: loading indicator or action buttons
                          if (isLoading)
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
                                isOutlined: colorConfig.designStyle ==
                                        ContentDesignStyle.outlined ||
                                    colorConfig.designStyle ==
                                        ContentDesignStyle.leftAccent ||
                                    colorConfig.designStyle ==
                                        ContentDesignStyle.tonal ||
                                    colorConfig.designStyle ==
                                        ContentDesignStyle.glass ||
                                    colorConfig.designStyle ==
                                        ContentDesignStyle.minimal,
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
            )),
      ),
    );
  }

  Widget _buildColorHeaderLayout(
    BuildContext context,
    DialogColorConfig colorConfig,
  ) {
    return RepaintBoundary(
      // Center first, Material second. The other way round the transparent
      // Material filled the whole screen and hit-tested opaque, so it
      // swallowed every tap aimed at the barrier behind it and
      // barrierDismissible — true by default — did nothing. Center does not
      // hit-test itself, so a tap outside the card now falls through to the
      // barrier while the card still absorbs its own taps.
      child: Center(
        child: Padding(
            // The inset lives outside the Material, the way Flutter's own
            // Dialog places insetPadding: a tap in this band is a tap outside
            // the card, so it dismisses rather than being absorbed.
            padding: DialogConstants.dialogMargin,
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: DialogConstants.maxDialogWidth,
                ),
                decoration: BoxDecoration(
                  color: colorConfig.backgroundColor,
                  borderRadius:
                      BorderRadius.circular(DialogConstants.borderRadius),
                  boxShadow: DialogShadows.getShadows(
                    widget.isDark,
                    designStyle: ContentDesignStyle.colorHeader,
                    accentColor: colorConfig.iconColor,
                  ),
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(DialogConstants.borderRadius),
                  child: _buildContent(
                    blur: widget.blur,
                    backdropFilter: widget.backdropFilter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                        Padding(
                          padding: EdgeInsets.only(
                            top: ColorHeaderBand.contentTopPadding(
                              hasIcon: widget.icon != null,
                            ),
                            left: 28,
                            right: 28,
                            bottom: 28,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Title with enhanced typography
                              RepaintBoundary(
                                child: Text(
                                  widget.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: SpType.displaySize,
                                    fontWeight: SpType.displayWeight,
                                    color: colorConfig.titleColor,
                                    letterSpacing: SpType.displayTracking,
                                    height: SpType.displayHeight,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Message with better readability
                              if (widget.message.isNotEmpty)
                                RepaintBoundary(
                                  child: Text(
                                    widget.message,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: colorConfig.messageColor,
                                      height: 1.55,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ),
                              if (widget.message.isNotEmpty)
                                const SizedBox(height: 28),
                              // Optional custom child widget
                              if (widget.child != null) ...[
                                widget.child!,
                                const SizedBox(height: 20),
                              ],
                              // Action button(s) with enhanced styling
                              if (isLoading)
                                RepaintBoundary(
                                  child: DialogLoadingIndicator(
                                    color: colorConfig.confirmColor,
                                  ),
                                )
                              else
                                Column(
                                  children: [
                                    // Primary button with gradient and shadow
                                    SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(26),
                                          boxShadow: [
                                            BoxShadow(
                                              color: colorConfig.buttonColor
                                                  .withValues(alpha: 0.3),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              _handleConfirm(context),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                colorConfig.buttonColor,
                                            foregroundColor:
                                                colorConfig.buttonTextColor,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                              horizontal: 28,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(26),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: Text(
                                            widget.confirmText,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Cancel button with subtle styling
                                    if (widget.showCancelButton) ...[
                                      const SizedBox(height: 14),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 44,
                                        child: TextButton(
                                          onPressed: () =>
                                              _handleCancel(context),
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                colorConfig.cancelColor,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 24,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(22),
                                            ),
                                          ),
                                          child: Text(
                                            widget.cancelText,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
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

  Future<void> _handleConfirm(BuildContext context) async {
    if (isLoading) return;

    HapticFeedback.lightImpact();

    // Handle async confirm callback
    if (widget.onConfirmAsync != null) {
      setLoading(true);

      try {
        final onConfirmAsync = widget.onConfirmAsync;
        if (onConfirmAsync != null) {
          final shouldClose = await onConfirmAsync();
          if (shouldClose == true && mounted) {
            if (context.mounted) {
              Navigator.of(context).pop(true);
            }
          } else {
            setLoading(false);
          }
        }
      } catch (_) {
        setLoading(false);
        rethrow;
      }
    } else {
      // Handle sync confirm callback
      Navigator.of(context).pop(true);
      widget.onConfirm?.call();
    }
  }

  void _handleCancel(BuildContext context) {
    if (isLoading) return;

    HapticFeedback.lightImpact();
    Navigator.of(context).pop(false);
    widget.onCancel?.call();
  }
}
