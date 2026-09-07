import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/shared/enhanced_icon.dart';

/// The vivid header band that tops a `colorHeader` surface.
///
/// Dialogs, snackbars and bottom sheets each built this themselves, and the
/// copies drifted: a 110dp band on a dialog against 90dp on a snackbar, a 14dp
/// close chip here and a 12dp one there, a 16dp close glyph against 14dp. One
/// widget means the band is the same band wherever it appears.
class ColorHeaderBand extends StatelessWidget {
  const ColorHeaderBand({
    super.key,
    required this.startColor,
    required this.endColor,
    required this.isDark,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    this.onClose,
    this.enablePulse = false,
    this.height = defaultHeight,
  });

  /// Height of the band itself, before the icon overhangs it.
  static const double defaultHeight = 110;

  /// How far the floating icon hangs below the band.
  ///
  /// Content beneath must reserve [overhang] plus its own spacing, which is
  /// what [contentTopPadding] works out.
  static const double overhang = 30;

  /// Top padding the content below the band needs, given whether there is an
  /// icon overhanging it.
  static double contentTopPadding({required bool hasIcon}) =>
      hasIcon ? 44 : 28;

  final Color startColor;
  final Color endColor;
  final bool isDark;

  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  /// Shown as a frosted chip in the top-right when non-null.
  final VoidCallback? onClose;

  final bool enablePulse;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [startColor, endColor],
            ),
          ),
        ),

        // A soft highlight from the top-right, so the band reads as lit
        // rather than as a flat swatch.
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.5,
                colors: [
                  Colors.white.withValues(alpha: isDark ? 0.06 : 0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        if (onClose != null)
          Positioned(
            top: 12,
            right: 12,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onClose,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    // Frosted chip on the vivid band.
                    color: Colors.white.withValues(alpha: 0.22),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    semanticLabel:
                        MaterialLocalizations.of(context).closeButtonTooltip,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.95),
                  ),
                ),
              ),
            ),
          ),

        if (icon != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: -overhang,
            child: Center(
              child: RepaintBoundary(
                child: EnhancedIcon(
                  icon: icon!,
                  color: iconColor ?? Theme.of(context).colorScheme.primary,
                  backgroundColor: iconBackgroundColor,
                  enablePulse: enablePulse,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
