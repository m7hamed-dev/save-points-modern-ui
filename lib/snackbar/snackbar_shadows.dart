import 'package:flutter/material.dart';

/// Snackbar shadows configuration
class SnackbarShadows {
  static List<BoxShadow> getShadows() => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 20,
      offset: const Offset(0, 8),
      spreadRadius: -5,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
}
