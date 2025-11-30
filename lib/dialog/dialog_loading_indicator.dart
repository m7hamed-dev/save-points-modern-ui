import 'package:flutter/material.dart';

/// Loading indicator for dialog
class DialogLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const DialogLoadingIndicator({
    super.key,
    this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final indicatorColor = color ?? 
        (isDark ? Colors.white70 : Colors.black54);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
        ),
      ),
    );
  }
}

