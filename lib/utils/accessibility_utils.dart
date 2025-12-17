import 'package:flutter/material.dart';

/// Utility functions for accessibility features
class AccessibilityUtils {
  /// Creates semantic properties for a dialog
  static SemanticsProperties dialogSemantics({
    required String label,
    required String? hint,
    bool isModal = true,
    bool? isButton,
    VoidCallback? onTap,
  }) {
    return SemanticsProperties(
      label: label,
      hint: hint,
      button: isButton,
      onTap: onTap,
      modal: isModal,
    );
  }

  /// Creates semantic properties for a snackbar
  static SemanticsProperties snackbarSemantics({
    required String label,
    String? hint,
    bool isLiveRegion = true,
    bool isButton = false,
    VoidCallback? onTap,
  }) {
    return SemanticsProperties(
      label: label,
      hint: hint,
      button: isButton,
      onTap: onTap,
      liveRegion: isLiveRegion,
    );
  }

  /// Creates semantic properties for a button
  static SemanticsProperties buttonSemantics({
    required String label,
    String? hint,
    bool isEnabled = true,
    VoidCallback? onTap,
  }) {
    return SemanticsProperties(
      label: label,
      hint: hint,
      button: true,
      enabled: isEnabled,
      onTap: onTap,
    );
  }

  /// Wraps a widget with semantic properties
  static Widget withSemantics({
    required Widget child,
    required SemanticsProperties properties,
  }) {
    return Semantics(
      label: properties.label,
      hint: properties.hint,
      button: properties.button,
      enabled: properties.enabled,
      liveRegion: properties.liveRegion,
      onTap: properties.onTap,
      child: child,
    );
  }
}

/// Properties for semantic widgets
class SemanticsProperties {
  final String? label;
  final String? hint;
  final bool? button;
  final bool? enabled;
  final bool? modal;
  final bool? liveRegion;
  final VoidCallback? onTap;

  const SemanticsProperties({
    this.label,
    this.hint,
    this.button,
    this.enabled,
    this.modal,
    this.liveRegion,
    this.onTap,
  });
}

