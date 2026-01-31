import 'package:flutter/material.dart';

/// Button shadows configuration
class ButtonShadows {
  static List<BoxShadow> getPrimaryShadow(Color backgroundColor) => [
    BoxShadow(
      color: backgroundColor.withValues(alpha: 0.35),
      blurRadius: 12,
      offset: const Offset(0, 4),
      spreadRadius: -2,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}
