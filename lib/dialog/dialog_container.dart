import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
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
    final isLeftAccent =
        colorConfig.designStyle == ContentDesignStyle.leftAccent;
    final borderRadius = .circular(DialogConstants.borderRadius);

    final contentBorderRadius = isLeftAccent
        ? BorderRadius.only(
            topRight: borderRadius.topRight,
            bottomRight: borderRadius.bottomRight,
          )
        : borderRadius;

    Widget content = Container(
      padding: DialogConstants.dialogPadding,
      decoration: BoxDecoration(
        color: colorConfig.backgroundColor,
        borderRadius: contentBorderRadius,
        border: isLeftAccent
            ? null
            : Border.all(
                color: isOutlined
                    ? colorConfig.borderColor!
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.05)),
                width: isOutlined ? 2 : 1.5,
              ),
        boxShadow: DialogShadows.getShadows(
          isDark,
          isOutlined: isOutlined,
          designStyle: colorConfig.designStyle,
        ),
      ),
      child: child,
    );

    if (isLeftAccent) {
      content = ClipRRect(
        borderRadius: borderRadius,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 5, color: colorConfig.iconColor),
            Expanded(child: content),
          ],
        ),
      );
    }

    return content;
  }
}
