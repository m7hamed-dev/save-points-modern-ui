import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_snackbar.dart';

/// Snackbar queue item
class _QueuedSnackbar {
  const _QueuedSnackbar({
    required this.context,
    required this.title,
    this.subtitle,
    this.type,
    this.duration,
    this.showProgressIndicator,
  });

  /// Held only until this item is shown; [SnackbarQueue] checks
  /// [BuildContext.mounted] before using it, and drops the item if the
  /// element is gone by then.
  final BuildContext context;
  final String title;
  final String? subtitle;
  final SnackbarType? type;
  final Duration? duration;
  final bool? showProgressIndicator;
}

/// Manages a queue of snackbars to show them one at a time.
///
/// Items are shown in order, each waiting for the previous one to close plus
/// a short gap. Queued items hold the [BuildContext] they were enqueued with
/// and are skipped if that context is unmounted by the time their turn comes,
/// so a disposed screen never shows a stale snackbar.
class SnackbarQueue {
  static final _instance = SnackbarQueue._internal();
  factory SnackbarQueue() => _instance;
  SnackbarQueue._internal();

  /// Gap between one snackbar closing and the next appearing.
  static const Duration gap = Duration(milliseconds: 300);

  final List<_QueuedSnackbar> _queue = [];
  bool _isShowing = false;
  Timer? _gapTimer;

  /// Bumped whenever the queue moves on. A `closed` callback from a snackbar
  /// that has since been superseded — cleared, or displaced by something else
  /// calling `hideCurrentSnackBar()` — carries a stale generation and is
  /// ignored, instead of clobbering the state of the snackbar now showing.
  int _generation = 0;

  /// Adds a snackbar to the queue
  void enqueue({
    required BuildContext context,
    required String title,
    String? subtitle,
    SnackbarType? type,
    Duration? duration,
    bool? showProgressIndicator,
  }) {
    _queue.add(
      _QueuedSnackbar(
        context: context,
        title: title,
        subtitle: subtitle,
        type: type,
        duration: duration,
        showProgressIndicator: showProgressIndicator,
      ),
    );
    _processQueue();
  }

  /// Processes the queue and shows the next snackbar
  void _processQueue() {
    if (_isShowing) return;

    // Drop everything whose screen has gone away, then take the first
    // survivor. A loop rather than recursion so a long run of dead entries
    // can't stack frames.
    while (_queue.isNotEmpty && !_queue.first.context.mounted) {
      _queue.removeAt(0);
    }
    if (_queue.isEmpty) return;

    _isShowing = true;
    final generation = ++_generation;
    final item = _queue.removeAt(0);
    final controller = _show(item);

    controller.closed.then((_) {
      if (generation != _generation) return;
      _isShowing = false;
      _gapTimer?.cancel();
      _gapTimer = Timer(gap, _processQueue);
    });
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _show(
    _QueuedSnackbar item,
  ) {
    // An exhaustive switch, so adding a SnackbarType is a compile error here
    // rather than silently falling through to "warning".
    switch (item.type) {
      case null:
      case SnackbarType.info:
        return SavePointsSnackbar.show(
          item.context,
          title: item.title,
          subtitle: item.subtitle,
          type: item.type,
          duration: item.duration,
          showProgressIndicator: item.showProgressIndicator,
        );
      case SnackbarType.success:
        return SavePointsSnackbar.showSuccess(
          item.context,
          title: item.title,
          subtitle: item.subtitle,
          duration: item.duration,
          showProgressIndicator: item.showProgressIndicator,
        );
      case SnackbarType.error:
        return SavePointsSnackbar.showError(
          item.context,
          title: item.title,
          subtitle: item.subtitle,
          duration: item.duration,
          showProgressIndicator: item.showProgressIndicator,
        );
      case SnackbarType.warning:
        return SavePointsSnackbar.showWarning(
          item.context,
          title: item.title,
          subtitle: item.subtitle,
          duration: item.duration,
          showProgressIndicator: item.showProgressIndicator,
        );
    }
  }

  /// Discards every pending snackbar and returns the queue to rest.
  ///
  /// Also cancels the gap timer and clears the "showing" flag: without that,
  /// clearing while a snackbar was on screen left the queue permanently
  /// wedged, ignoring everything enqueued afterwards.
  void clear() {
    _queue.clear();
    _gapTimer?.cancel();
    _gapTimer = null;
    _isShowing = false;
    _generation++;
  }

  /// Gets the current queue length
  int get length => _queue.length;

  /// Checks if queue is empty
  bool get isEmpty => _queue.isEmpty;

  /// Checks if a snackbar is currently showing
  bool get isShowing => _isShowing;
}
