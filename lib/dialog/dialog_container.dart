import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_color_config.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_constants.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_shadows.dart';

/// Dialog container with decoration
class DialogContainer extends StatelessWidget {
  final DialogColorConfig colorConfig;
  final Widget child;

  const DialogContainer({
    super.key,
    required this.colorConfig,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOutlined = colorConfig.borderColor != null;

    return Container(
      padding: DialogConstants.dialogPadding,
      decoration: BoxDecoration(
        color: colorConfig.backgroundColor,
        borderRadius: BorderRadius.circular(DialogConstants.borderRadius),
        border: Border.all(
          color: isOutlined
              ? colorConfig.borderColor!
              : (isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05)),
          width: isOutlined ? 2 : 1.5,
        ),
        boxShadow: DialogShadows.getShadows(isDark, isOutlined: isOutlined),
      ),
      child: child,
    );
  }
}
