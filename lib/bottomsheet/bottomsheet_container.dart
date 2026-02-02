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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOutlined = colorConfig.borderColor != null;

    return Container(
      padding: BottomsheetConstants.padding,
      decoration: BoxDecoration(
        color: colorConfig.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            showTopRadius ? BottomsheetConstants.topBorderRadius : 0,
          ),
          topRight: Radius.circular(
            showTopRadius ? BottomsheetConstants.topBorderRadius : 0,
          ),
          bottomLeft: const Radius.circular(BottomsheetConstants.borderRadius),
          bottomRight: const Radius.circular(BottomsheetConstants.borderRadius),
        ),
        border: isOutlined
            ? Border(
                top: BorderSide(color: colorConfig.borderColor!, width: 2),
                left: BorderSide(color: colorConfig.borderColor!, width: 2),
                right: BorderSide(color: colorConfig.borderColor!, width: 2),
              )
            : null,
        boxShadow: BottomsheetShadows.getShadows(
          isDark,
          isOutlined: isOutlined,
        ),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}
