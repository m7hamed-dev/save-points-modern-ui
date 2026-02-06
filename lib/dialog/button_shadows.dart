import 'package:flutter/material.dart';

/// Professional button shadows configuration with layered depth
class ButtonShadows {
  /// Primary button shadow with color glow effect
  static List<BoxShadow> getPrimaryShadow(Color backgroundColor) => [
    // Subtle top highlight
    BoxShadow(
      color: Colors.white.withValues(alpha: 0.1),
      blurRadius: 1,
      offset: const Offset(0, -1),
    ),
    // Color glow
    BoxShadow(
      color: backgroundColor.withValues(alpha: 0.4),
      blurRadius: 16,
      offset: const Offset(0, 6),
      spreadRadius: -4,
    ),
    // Soft ambient shadow
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 8,
      offset: const Offset(0, 3),
      spreadRadius: -2,
    ),
  ];

  /// Secondary button shadow (subtle)
  static List<BoxShadow> getSecondaryShadow() => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.02),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  /// Outlined button shadow (minimal)
  static List<BoxShadow> getOutlinedShadow(Color borderColor) => [
    BoxShadow(
      color: borderColor.withValues(alpha: 0.08),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];
}
