/// Bottom sheet container widget with styling and safe area handling.
library;

import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_color_config.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_constants.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_shadows.dart';

/// Bottom sheet container with decoration
class BottomsheetContainer extends StatelessWidget {
  const BottomsheetContainer({
    super.key,
    required this.colorConfig,
    required this.child,
    this.showTopRadius = true,
  });

  final BottomsheetColorConfig colorConfig;
  final Widget child;
  final bool showTopRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == .dark;
    final isOutlined = colorConfig.borderColor != null;
    final isLeftAccent = colorConfig.designStyle == .leftAccent;
    const topRadius = BottomsheetConstants.topBorderRadius;

    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(showTopRadius ? topRadius : 0),
      topRight: Radius.circular(showTopRadius ? topRadius : 0),
      bottomLeft: const Radius.circular(BottomsheetConstants.borderRadius),
      bottomRight: const Radius.circular(BottomsheetConstants.borderRadius),
    );

    Widget content = Container(
      padding: BottomsheetConstants.padding,
      decoration: BoxDecoration(
        color: colorConfig.backgroundColor,
        borderRadius: isLeftAccent
            ? BorderRadius.only(
                topRight: borderRadius.topRight,
                bottomRight: borderRadius.bottomRight,
              )
            : borderRadius,
        border: isOutlined && !isLeftAccent
            ? Border(
                top: BorderSide(color: colorConfig.borderColor!, width: 2),
                left: BorderSide(color: colorConfig.borderColor!, width: 2),
                right: BorderSide(color: colorConfig.borderColor!, width: 2),
              )
            : null,
        boxShadow: BottomsheetShadows.getShadows(
          isDark,
          isOutlined: isOutlined,
          designStyle: colorConfig.designStyle,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(top: false, child: child),
      ),
    );

    if (isLeftAccent) {
      content = ClipRRect(
        borderRadius: borderRadius,
        child: Row(
          crossAxisAlignment: .stretch,
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
