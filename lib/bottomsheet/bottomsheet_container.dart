import 'package:flutter/material.dart';
import 'package:save_points_modern_ui/bottomsheet/bottomsheet_color_config.dart';
import 'package:save_points_modern_ui/bottomsheet/bottomsheet_constants.dart';
import 'package:save_points_modern_ui/bottomsheet/bottomsheet_shadows.dart';

/// Bottom sheet container with decoration
class BottomsheetContainer extends StatelessWidget {
  final BottomsheetColorConfig colorConfig;
  final Widget child;
  final bool showTopRadius;

  const BottomsheetContainer({
    super.key,
    required this.colorConfig,
    required this.child,
    this.showTopRadius = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        boxShadow: BottomsheetShadows.getShadows(isDark),
      ),
      child: child,
    );
  }
}
