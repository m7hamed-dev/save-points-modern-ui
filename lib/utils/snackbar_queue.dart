import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_snackbar.dart';

/// Snackbar queue item
class _QueuedSnackbar {
  final BuildContext context;
  final String title;
  final String? subtitle;
  final SnackbarType? type;
  final Duration? duration;
  final bool showProgressIndicator;

  _QueuedSnackbar({
    required this.context,
    required this.title,
    this.subtitle,
    this.type,
    this.duration,
    this.showProgressIndicator = false,
  });
}

/// Manages a queue of snackbars to show them one at a time
class SnackbarQueue {
  static final SnackbarQueue _instance = SnackbarQueue._internal();
  factory SnackbarQueue() => _instance;
  SnackbarQueue._internal();

  final List<_QueuedSnackbar> _queue = [];
  bool _isShowing = false;

  /// Adds a snackbar to the queue
  void enqueue({
    required BuildContext context,
    required String title,
    String? subtitle,
    SnackbarType? type,
    Duration? duration,
    bool showProgressIndicator = false,
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
    if (_isShowing || _queue.isEmpty) return;

    _isShowing = true;
    final item = _queue.removeAt(0);

    if (!item.context.mounted) {
      _isShowing = false;
      _processQueue();
      return;
    }

    final controller = item.type == null
        ? SavePointsSnackbar.show(
            item.context,
            title: item.title,
            subtitle: item.subtitle,
            duration: item.duration,
            showProgressIndicator: item.showProgressIndicator,
          )
        : item.type == SnackbarType.success
            ? SavePointsSnackbar.showSuccess(
                item.context,
                title: item.title,
                subtitle: item.subtitle,
                duration: item.duration,
                showProgressIndicator: item.showProgressIndicator,
              )
            : item.type == SnackbarType.error
                ? SavePointsSnackbar.showError(
                    item.context,
                    title: item.title,
                    subtitle: item.subtitle,
                    duration: item.duration,
                    showProgressIndicator: item.showProgressIndicator,
                  )
                : SavePointsSnackbar.showWarning(
                    item.context,
                    title: item.title,
                    subtitle: item.subtitle,
                    duration: item.duration,
                    showProgressIndicator: item.showProgressIndicator,
                  );

    controller.closed.then((_) {
      _isShowing = false;
      // Wait a bit before showing next snackbar
      Future.delayed(const Duration(milliseconds: 300), () {
        _processQueue();
      });
    });
  }

  /// Clears the queue
  void clear() {
    _queue.clear();
  }

  /// Gets the current queue length
  int get length => _queue.length;

  /// Checks if queue is empty
  bool get isEmpty => _queue.isEmpty;

  /// Checks if a snackbar is currently showing
  bool get isShowing => _isShowing;
}

