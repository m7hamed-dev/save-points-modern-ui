import 'package:flutter/widgets.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_theme.dart';

/// Resolves whether component icons should loop their pulse animation.
///
/// Off unless a [SavePointsTheme] in scope turns it on. The pulse never ends,
/// so leaving it on costs a repaint every frame for as long as the surface is
/// visible and makes `pumpAndSettle()` hang in consumers' tests — it is opt-in
/// for a subtree, or for a single call via the `enablePulse` argument on
/// `show()`, which installs a scoped override with [pulseScope].
bool resolvePulse(BuildContext context) =>
    SavePointsTheme.maybeOf(context)?.enablePulse ?? false;

/// Wraps [child] in a [SavePointsTheme] carrying a one-call `enablePulse`
/// override, so the leaf icon widgets can read it from context instead of
/// every widget in between growing a field just to forward it.
///
/// Returns [child] untouched when [enablePulse] is null, so a call that does
/// not mention pulsing adds nothing to the tree.
Widget pulseScope(
  SavePointsThemeData? inherited,
  bool? enablePulse,
  Widget child,
) {
  if (enablePulse == null) return child;
  return SavePointsTheme(
    data: (inherited ?? const SavePointsThemeData()).copyWith(
      enablePulse: enablePulse,
    ),
    child: child,
  );
}
