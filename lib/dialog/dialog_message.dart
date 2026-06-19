import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';

/// Dialog message widget
class DialogMessage extends StatelessWidget {
  final String message;
  final bool isDark;
  final Color? color;

  const DialogMessage({
    super.key,
    required this.message,
    required this.isDark,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? SpSurface.onSurfaceMuted(isDark);
    return Text(
      message,
      textAlign: .center,
      style: TextStyle(
        fontSize: SpType.bodySize,
        fontWeight: SpType.bodyWeight,
        color: effectiveColor,
        height: SpType.bodyHeight,
        letterSpacing: SpType.bodyTracking,
      ),
    );
  }
}
