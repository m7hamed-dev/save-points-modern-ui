import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_constants.dart';

/// Bottom sheet drag handle
class BottomsheetHandle extends StatelessWidget {
  final Color? color;

  const BottomsheetHandle({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final handleColor =
        color ??
        (isDark
            ? Colors.white.withValues(alpha: 0.3)
            : Colors.black.withValues(alpha: 0.2));

    return Container(
      margin: const EdgeInsets.only(
        top: BottomsheetConstants.handleSpacing,
        bottom: BottomsheetConstants.handleSpacing,
      ),
      width: BottomsheetConstants.handleWidth,
      height: BottomsheetConstants.handleHeight,
      decoration: BoxDecoration(
        color: handleColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
