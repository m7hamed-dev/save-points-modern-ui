import 'package:flutter/material.dart';

/// Loading indicator for bottom sheet
class BottomsheetLoadingIndicator extends StatelessWidget {
  const BottomsheetLoadingIndicator({super.key, this.color, this.size = 32.0});
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == .dark;
    final indicatorColor = color ?? (isDark ? Colors.white70 : Colors.black54);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
          ),
        ),
      ),
    );
  }
}
