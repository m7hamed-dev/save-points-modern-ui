import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/modern_bottomsheet.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_transition_builder.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_animation_direction.dart';

// Export animation direction for public use
export 'bottomsheet/bottomsheet_animation_direction.dart';

/// A modern, customizable bottom sheet with glassmorphism design.
///
/// This class provides a static method to display beautiful bottom sheets with:
/// - Glassmorphism effects with backdrop blur
/// - Drag handles and gestures
/// - Scrollable content support
/// - Loading states
/// - Custom animations
/// - Dark mode support
///
/// Example:
/// ```dart
/// SavePointsBottomsheet.show(
///   context: context,
///   title: 'Options',
///   child: YourContentWidget(),
/// );
/// ```
class SavePointsBottomsheet {
  /// Shows a modern bottom sheet.
  ///
  /// Returns the result value when the bottom sheet is dismissed,
  /// or `null` if dismissed without a result.
  ///
  /// Example:
  /// ```dart
  /// final result = await SavePointsBottomsheet.show<String>(
  ///   context: context,
  ///   title: 'Select Option',
  ///   child: OptionsList(),
  /// );
  /// ```
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    Widget? child,
    IconData? icon,
    Color? iconColor,
    Color? backgroundColor,
    bool? isDismissible,
    bool? enableDrag,
    bool? showHandle,
    double? maxHeight,
    bool isScrollControlled = false,
    BottomsheetAnimationDirection? startAnimation,
    BottomsheetAnimationDirection? endAnimation,
    bool isLoading = false,
    ValueNotifier<bool>? loadingNotifier,
    bool hideLikeCircle = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final finalIsDismissible = isDismissible ?? true;
    final finalEnableDrag = enableDrag ?? true;
    final finalShowHandle = showHandle ?? true;

    // Use showGeneralDialog for full animation control
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: finalIsDismissible,
      barrierLabel: 'Close bottom sheet',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, _, _) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, _) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: BottomsheetTransitionBuilder(
            animation: animation,
            startAnimation: startAnimation,
            endAnimation: endAnimation,
            hideLikeCircle: hideLikeCircle,
            bottomsheet: GestureDetector(
              onTap: () {}, // Prevent tap from closing
              child: ModernBottomsheet(
                title: title,
                icon: icon,
                iconColor: iconColor,
                backgroundColor: backgroundColor,
                isDark: isDark,
                isLoading: isLoading,
                loadingNotifier: loadingNotifier,
                showHandle: finalShowHandle,
                isDismissible: finalIsDismissible,
                enableDrag: finalEnableDrag,
                maxHeight: maxHeight,
                isScrollControlled: isScrollControlled,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
