import 'package:flutter/material.dart';

/// Utility functions for keyboard handling
class KeyboardUtils {
  /// Hides the keyboard if it's currently visible
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Hides the keyboard and removes focus from any focused widget
  static void hideKeyboardAndUnfocus(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  /// Shows the keyboard for a given text field
  static void showKeyboard(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  /// Checks if the keyboard is currently visible
  static bool isKeyboardVisible(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return viewInsets.bottom > 0;
  }

  /// Gets the keyboard height
  static double getKeyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  /// Dismisses keyboard when dialog is shown
  static void dismissKeyboardForDialog(BuildContext context) {
    hideKeyboard(context);
  }

  /// Dismisses keyboard when bottom sheet is shown
  static void dismissKeyboardForBottomSheet(BuildContext context) {
    hideKeyboard(context);
  }
}

