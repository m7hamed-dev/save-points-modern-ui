import 'package:flutter/material.dart';

/// A clamped animation that ensures values stay within [0, 1] range
/// This is needed for curves like elasticOut, easeOutBack, and bounceOut
/// which can produce values outside the normal range
class ClampedAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  ClampedAnimation(this.parent);

  @override
  final Animation<double> parent;

  @override
  double get value => parent.value.clamp(0.0, 1.0);

  @override
  void addListener(VoidCallback listener) {
    parent.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    parent.removeListener(listener);
  }

  @override
  AnimationStatus get status => parent.status;

  @override
  String toString() => 'ClampedAnimation(parent: $parent)';
}
