import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';

/// Dialog title widget
class DialogTitle extends StatelessWidget {
  final String title;
  final bool isDark;
  final Color? color;

  const DialogTitle({
    super.key,
    required this.title,
    required this.isDark,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? SpSurface.onSurface(isDark);
    return Text(
      title,
      textAlign: .center,
      style: TextStyle(
        fontSize: SpType.displaySize,
        fontWeight: SpType.displayWeight,
        color: effectiveColor,
        letterSpacing: SpType.displayTracking,
        height: SpType.displayHeight,
      ),
    );
  }
}
