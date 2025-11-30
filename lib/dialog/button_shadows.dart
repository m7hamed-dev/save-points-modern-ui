import 'package:flutter/material.dart';

/// Button shadows configuration
class ButtonShadows {
  static List<BoxShadow> getPrimaryShadow(Color backgroundColor) => [
    BoxShadow(
      color: backgroundColor.withValues(alpha: 0.4),
      blurRadius: 12,
      offset: const Offset(0, 6),
      spreadRadius: -2,
    ),
  ];
}
