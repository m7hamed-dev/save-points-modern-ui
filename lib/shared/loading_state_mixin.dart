import 'package:flutter/widgets.dart';

/// Shared loading state for widgets that accept both a static `isLoading`
/// flag and a live [ValueNotifier] of the same thing.
///
/// Internal to the package: it is deliberately not exported from the public
/// barrel, so it can change without breaking consumers.
///
/// It owns the listener's whole lifecycle — attach, swap, detach — so a host
/// widget only has to forward the old widget in `didUpdateWidget`:
///
/// ```dart
/// class _MyState extends State<MyWidget> with LoadingStateMixin<MyWidget> {
///   @override
///   bool get widgetIsLoading => widget.isLoading;
///   @override
///   ValueNotifier<bool>? get widgetLoadingNotifier => widget.loadingNotifier;
///
///   @override
///   void didUpdateWidget(MyWidget oldWidget) {
///     super.didUpdateWidget(oldWidget);
///     updateLoadingState(
///       oldIsLoading: oldWidget.isLoading,
///       oldNotifier: oldWidget.loadingNotifier,
///     );
///   }
/// }
/// ```
mixin LoadingStateMixin<W extends StatefulWidget> on State<W> {
  /// The host widget's static loading flag.
  bool get widgetIsLoading;

  /// The host widget's optional live loading source.
  ValueNotifier<bool>? get widgetLoadingNotifier;

  /// Whether a spinner should be shown right now.
  ///
  /// Starts at [widgetIsLoading] and then tracks [widgetLoadingNotifier] for
  /// as long as one is attached.
  bool get isLoading => _isLoading;
  late bool _isLoading;

  ValueNotifier<bool>? _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = widgetLoadingNotifier;
    // An attached notifier is the source of truth from the very first frame.
    // Seeding from the static flag instead meant a surface opened with a
    // notifier that was already `true` showed no spinner until that notifier
    // happened to change again.
    _isLoading = _notifier?.value ?? widgetIsLoading;
    _notifier?.addListener(_onLoadingChanged);
  }

  /// Reconciles the loading state after the host widget was rebuilt.
  ///
  /// Call this from `didUpdateWidget`, passing the old widget's values.
  void updateLoadingState({
    required bool oldIsLoading,
    required ValueNotifier<bool>? oldNotifier,
  }) {
    final newNotifier = widgetLoadingNotifier;

    if (oldNotifier != newNotifier) {
      oldNotifier?.removeListener(_onLoadingChanged);
      _notifier = newNotifier;
      _notifier?.addListener(_onLoadingChanged);
      // A swapped notifier is the new source of truth, so adopt its value
      // now instead of waiting for its first notification — otherwise the
      // spinner would keep showing the old notifier's state.
      _isLoading = newNotifier?.value ?? widgetIsLoading;
      return;
    }

    // Only an actual change to the static flag moves the state. Assigning it
    // on every rebuild used to clobber notifier-driven loading, and these
    // widgets are rebuilt once per frame by the route's transition builder,
    // so the spinner was cancelled as fast as the notifier turned it on.
    if (oldIsLoading != widgetIsLoading) {
      _isLoading = widgetIsLoading;
    }
  }

  /// Drives the spinner from inside the host widget — for instance while an
  /// async confirm callback runs.
  ///
  /// Safe to call after the state is gone, and skips the rebuild when the
  /// value has not actually changed.
  @protected
  void setLoading(bool value) {
    if (!mounted || _isLoading == value) return;
    setState(() => _isLoading = value);
  }

  @override
  void dispose() {
    _notifier?.removeListener(_onLoadingChanged);
    _notifier = null;
    super.dispose();
  }

  void _onLoadingChanged() {
    final notifier = _notifier;
    if (notifier == null || !mounted) return;
    setState(() => _isLoading = notifier.value);
  }
}
