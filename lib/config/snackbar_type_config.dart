import 'package:flutter/material.dart';

/// Configuration for a specific snackbar type
class SnackbarTypeConfig {
  const SnackbarTypeConfig({
    required this.backgroundColor,
    required this.iconColor,
    required this.defaultIcon,
  });
  final Map<Brightness, Color> backgroundColor;
  final Color iconColor;
  final IconData defaultIcon;
}
