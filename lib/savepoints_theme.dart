import 'package:flutter/widgets.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/snackbar/snackbar_enums.dart';

/// Scoped default styling for every SavePoints component beneath it.
///
/// Instead of repeating `designStyle:`, `blur:` and friends on every
/// `SavePointsDialog.show` / `SavePointsSnackbar.show` /
/// `SavePointsBottomsheet.show` call — or mutating the process-wide
/// `SnackDiaBottomConfig` singleton — declare the defaults once in your widget
/// tree:
///
/// ```dart
/// SavePointsTheme(
///   data: SavePointsThemeData(
///     designStyle: ContentDesignStyle.glass,
///     blur: 24,
///     snackbarPosition: SnackbarPosition.top,
///   ),
///   child: MaterialApp(...),
/// );
/// ```
///
/// Every component looks up the nearest [SavePointsTheme] via its
/// [BuildContext] and uses these values as defaults. Anything passed explicitly
/// to a `show()` call still wins, and any field left `null` here falls back to
/// the component's built-in default — so adopting a theme is fully opt-in and
/// backward compatible.
///
/// Because it is a normal [InheritedWidget], the scope respects the widget tree:
/// a subtree can wrap itself in a second [SavePointsTheme] to override the
/// defaults for just that part of the app.
@immutable
class SavePointsThemeData {
  /// Creates a set of default values. Every field is optional; a `null` field
  /// means "defer to the component's own default".
  const SavePointsThemeData({
    this.designStyle,
    this.blur,
    this.snackbarPosition,
    this.snackbarDuration,
    this.enableHapticFeedback,
    this.barrierDismissible,
  });

  /// Default visual style shared by dialogs, snackbars and bottom sheets.
  final ContentDesignStyle? designStyle;

  /// Default backdrop blur sigma applied behind components.
  final double? blur;

  /// Default screen edge snackbars appear at.
  final SnackbarPosition? snackbarPosition;

  /// Default visible duration for snackbars.
  final Duration? snackbarDuration;

  /// Default haptic-feedback behaviour for snackbars.
  final bool? enableHapticFeedback;

  /// Default barrier-dismiss behaviour for dialogs.
  final bool? barrierDismissible;

  /// Returns a copy with the given fields replaced.
  SavePointsThemeData copyWith({
    ContentDesignStyle? designStyle,
    double? blur,
    SnackbarPosition? snackbarPosition,
    Duration? snackbarDuration,
    bool? enableHapticFeedback,
    bool? barrierDismissible,
  }) {
    return SavePointsThemeData(
      designStyle: designStyle ?? this.designStyle,
      blur: blur ?? this.blur,
      snackbarPosition: snackbarPosition ?? this.snackbarPosition,
      snackbarDuration: snackbarDuration ?? this.snackbarDuration,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
      barrierDismissible: barrierDismissible ?? this.barrierDismissible,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SavePointsThemeData &&
        other.designStyle == designStyle &&
        other.blur == blur &&
        other.snackbarPosition == snackbarPosition &&
        other.snackbarDuration == snackbarDuration &&
        other.enableHapticFeedback == enableHapticFeedback &&
        other.barrierDismissible == barrierDismissible;
  }

  @override
  int get hashCode => Object.hash(
        designStyle,
        blur,
        snackbarPosition,
        snackbarDuration,
        enableHapticFeedback,
        barrierDismissible,
      );
}

/// Provides a [SavePointsThemeData] to all SavePoints components below it.
///
/// Place it above your [MaterialApp] (or any subtree) to set app-wide defaults.
/// Components resolve their defaults with [SavePointsTheme.maybeOf].
class SavePointsTheme extends InheritedWidget {
  /// Creates a scope that supplies [data] to descendant components.
  const SavePointsTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The defaults applied to descendant components.
  final SavePointsThemeData data;

  /// Returns the nearest [SavePointsThemeData], or `null` if none is in scope.
  ///
  /// Components use this so that having no [SavePointsTheme] simply means
  /// "use built-in defaults".
  static SavePointsThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SavePointsTheme>()?.data;
  }

  /// Returns the nearest [SavePointsThemeData]; throws if none is in scope.
  ///
  /// Prefer [maybeOf] inside component internals; use [of] when your own code
  /// requires a theme to be present.
  static SavePointsThemeData of(BuildContext context) {
    final data = maybeOf(context);
    assert(data != null, 'No SavePointsTheme found in context');
    return data!;
  }

  @override
  bool updateShouldNotify(SavePointsTheme oldWidget) => data != oldWidget.data;
}
