import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/modern_button.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_constants.dart';

/// Dialog buttons row
class DialogButtons extends StatelessWidget {
  final String confirmText;
  final String cancelText;
  final bool showCancelButton;
  final Color confirmColor;
  final Color cancelColor;
  final bool isDark;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const DialogButtons({
    super.key,
    required this.confirmText,
    required this.cancelText,
    required this.showCancelButton,
    required this.confirmColor,
    required this.cancelColor,
    required this.isDark,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showCancelButton) ...[
          Expanded(
            child: RepaintBoundary(
              child: ModernButton(
                text: cancelText,
                onPressed: onCancel,
                backgroundColor: cancelColor.withValues(alpha: 0.1),
                foregroundColor: cancelColor,
                isDark: isDark,
              ),
            ),
          ),
          const SizedBox(width: DialogConstants.buttonSpacing),
        ],
        Expanded(
          flex: showCancelButton ? 1 : 0,
          child: RepaintBoundary(
            child: ModernButton(
              text: confirmText,
              onPressed: onConfirm,
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
              isPrimary: true,
              isDark: isDark,
            ),
          ),
        ),
      ],
    );
  }
}
