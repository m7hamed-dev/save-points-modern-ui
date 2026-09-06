import 'dart:ui';

import 'package:flutter/material.dart';

/// The dimmed, blurred barrier painted behind a dialog or bottom sheet.
///
/// Fades in by ramping the blur sigma and the dim alpha rather than by wrapping
/// the blur in an [Opacity]. Opacity over a [BackdropFilter] forces a
/// full-screen `saveLayer` on top of the one the blur already needs, on every
/// frame of the entrance — the most expensive thing this package draws. Ramping
/// the sigma costs one layer instead of two and reads better besides: the
/// background comes into focus rather than a finished blur dissolving in.
class AnimatedBarrier extends StatelessWidget {
  const AnimatedBarrier({
    super.key,
    required this.animation,
    required this.dimColor,
    this.sigma,
    this.filter,
    this.onTap,
  }) : assert(
         sigma != null || filter != null,
         'AnimatedBarrier needs a sigma to ramp, or a filter to hold constant',
       );

  /// Drives both the blur ramp and the dim fade.
  final Animation<double> animation;

  /// Barrier tint at full strength; its alpha is scaled by [animation].
  final Color dimColor;

  /// Blur strength at full strength. When set, the sigma is ramped.
  final double? sigma;

  /// A caller-supplied filter used instead of [sigma].
  ///
  /// Arbitrary [ImageFilter]s cannot be interpolated, so this one is held
  /// constant and only the dim fades.
  final ImageFilter? filter;

  /// Dismisses the surface when the barrier is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            final t = animation.value.clamp(0.0, 1.0);
            final s = sigma;
            return ClipRect(
              child: BackdropFilter(
                filter: s != null
                    ? ImageFilter.blur(sigmaX: s * t, sigmaY: s * t)
                    : filter!,
                child: ColoredBox(
                  color: dimColor.withValues(alpha: dimColor.a * t),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
