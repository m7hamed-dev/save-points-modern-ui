import 'package:flutter/material.dart';

/// Configuration for a specific snackbar type
class SnackbarTypeConfig {
  final Map<Brightness, Color> backgroundColor;
  final Color iconColor;
  final IconData defaultIcon;

  SnackbarTypeConfig({
    required this.backgroundColor,
    required this.iconColor,
    required this.defaultIcon,
  });
}
