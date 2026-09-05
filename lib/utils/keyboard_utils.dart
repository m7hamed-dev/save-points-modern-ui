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

  /// Drops focus only when something in this scope actually holds it.
  ///
  /// Used before showing a dialog or bottom sheet so an open keyboard does
  /// not overlap it. Guarded, because unfocusing a scope that has no focus
  /// still walks the focus tree for nothing.
  static void dismissIfFocused(BuildContext context) {
    final scope = FocusScope.of(context);
    if (scope.hasFocus) {
      scope.unfocus();
    }
  }

  /// Dismisses keyboard when dialog is shown
  @Deprecated('Use dismissIfFocused instead.')
  static void dismissKeyboardForDialog(BuildContext context) =>
      dismissIfFocused(context);

  /// Dismisses keyboard when bottom sheet is shown
  @Deprecated('Use dismissIfFocused instead.')
  static void dismissKeyboardForBottomSheet(BuildContext context) =>
      dismissIfFocused(context);
}
