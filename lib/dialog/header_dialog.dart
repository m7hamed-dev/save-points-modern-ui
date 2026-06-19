import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_constants.dart';

/// A dialog with a colored header bar and close button outside the box.
///
/// This dialog style features:
/// - Close button positioned outside (top-left) the dialog
/// - A colored header with title
/// - Custom content area
/// - Primary and optional secondary action buttons
class HeaderDialog extends StatelessWidget {
  /// Creates a header dialog.
  const HeaderDialog({
    super.key,
    required this.headerTitle,
    this.headerColor,
    this.headerTextColor,
    required this.child,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.primaryButtonColor,
    this.secondaryButtonColor,
    this.showCloseButton = true,
    this.onClose,
    this.isDark = false,
    this.blur,
    this.backdropFilter,
    this.borderRadius,
  });

  /// The title displayed in the header bar.
  final String headerTitle;

  /// The background color of the header bar.
  /// Defaults to primary color from theme.
  final Color? headerColor;

  /// The text color for the header title.
  /// Defaults to white.
  final Color? headerTextColor;

  /// The main content of the dialog.
  final Widget child;

  /// Text for the primary action button.
  final String? primaryButtonText;

  /// Text for the secondary (outlined) action button.
  final String? secondaryButtonText;

  /// Callback when primary button is pressed.
  final VoidCallback? onPrimaryPressed;

  /// Callback when secondary button is pressed.
  final VoidCallback? onSecondaryPressed;

  /// Color for the primary button.
  final Color? primaryButtonColor;

  /// Color for the secondary button border and text.
  final Color? secondaryButtonColor;

  /// Whether to show the close button outside the dialog.
  final bool showCloseButton;

  /// Callback when close button is pressed.
  /// If null, defaults to popping the dialog.
  final VoidCallback? onClose;

  /// Whether to use dark mode colors.
  final bool isDark;

  /// Blur amount for glassmorphism effect.
  final double? blur;

  /// Custom backdrop filter.
  final ImageFilter? backdropFilter;

  /// Custom border radius for the dialog.
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveHeaderColor = headerColor ?? theme.primaryColor;
    final effectiveHeaderTextColor = headerTextColor ?? Colors.white;
    final effectivePrimaryColor = primaryButtonColor ?? theme.primaryColor;
    final effectiveSecondaryColor = secondaryButtonColor ?? theme.primaryColor;
    final effectiveBorderRadius = borderRadius ?? DialogConstants.borderRadius;
    final backgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            margin: DialogConstants.dialogMargin,
            constraints: const BoxConstraints(
              maxWidth: DialogConstants.maxDialogWidth,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Main dialog content
                ClipRRect(
                  borderRadius: .circular(effectiveBorderRadius),
                  child: _buildContent(
                    blur: blur,
                    backdropFilter: backdropFilter,
                    child: Column(
                      mainAxisSize: .min,
                      children: [
                        // Header bar
                        _buildHeader(
                          effectiveHeaderColor,
                          effectiveHeaderTextColor,
                        ),
                        // Content area
                        Container(
                          width: double.infinity,
                          color: backgroundColor,
                          child: Column(
                            mainAxisSize: .min,
                            children: [
                              // Custom content
                              Padding(padding: const .all(20), child: child),
                              // Action buttons
                              if (primaryButtonText != null ||
                                  secondaryButtonText != null)
                                _buildButtons(
                                  context,
                                  effectivePrimaryColor,
                                  effectiveSecondaryColor,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Close button outside the dialog (top-left)
                if (showCloseButton)
                  Positioned(
                    top: -16,
                    left: 0,
                    child: _OutsideCloseButton(
                      iconColor: effectiveHeaderTextColor,
                      backgroundColor: effectiveHeaderColor,
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        if (onClose != null) {
                          onClose!();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color headerColor, Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(color: headerColor),
      child: Text(
        headerTitle,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildButtons(
    BuildContext context,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: [
          if (primaryButtonText != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  if (onPrimaryPressed != null) {
                    onPrimaryPressed!();
                  } else {
                    Navigator.of(context).pop(true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: .circular(DialogConstants.buttonBorderRadius),
                  ),
                  minimumSize: const Size(
                    double.infinity,
                    DialogConstants.buttonMinHeight,
                  ),
                ),
                child: Text(
                  primaryButtonText!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (primaryButtonText != null && secondaryButtonText != null)
            const SizedBox(height: 12),
          if (secondaryButtonText != null)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  if (onSecondaryPressed != null) {
                    onSecondaryPressed!();
                  } else {
                    Navigator.of(context).pop(false);
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: secondaryColor,
                  side: BorderSide(
                    color: secondaryColor.withValues(alpha: 0.5),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: .circular(DialogConstants.buttonBorderRadius),
                  ),
                  minimumSize: const Size(
                    double.infinity,
                    DialogConstants.buttonMinHeight,
                  ),
                ),
                child: Text(
                  secondaryButtonText!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent({
    required double? blur,
    required ImageFilter? backdropFilter,
    required Widget child,
  }) {
    final filter =
        backdropFilter ??
        (blur != null && blur > 0
            ? ImageFilter.blur(sigmaX: blur, sigmaY: blur)
            : null);
    if (filter == null) {
      return child;
    }
    return ClipRect(
      child: BackdropFilter(filter: filter, child: child),
    );
  }
}

/// Close button widget positioned outside the dialog
class _OutsideCloseButton extends StatelessWidget {
  const _OutsideCloseButton({
    required this.iconColor,
    required this.backgroundColor,
    required this.onPressed,
  });

  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: 44,
          height: 44,
          alignment: .center,
          child: Icon(Icons.close, color: iconColor, size: 22),
        ),
      ),
    );
  }
}
