import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/sp_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_color_config.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_constants.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_shadows.dart';

/// Dialog container with decoration
class DialogContainer extends StatelessWidget {
  final DialogColorConfig colorConfig;
  final Widget child;

  const DialogContainer({
    super.key,
    required this.colorConfig,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOutlined = colorConfig.borderColor != null;
    final isLeftAccent =
        colorConfig.designStyle == ContentDesignStyle.leftAccent;
    final spec = SpStyles.of(
      colorConfig.designStyle,
      colorConfig.iconColor,
      isDark,
    );
    // Rounding is part of the style: brutalism wants tight corners, clay wants
    // generous ones. Everything else keeps the component's own radius.
    final borderRadius = BorderRadius.circular(
      DialogConstants.borderRadius * spec.radiusScale,
    );

    final contentBorderRadius = isLeftAccent
        ? BorderRadius.only(
            topRight: borderRadius.topRight,
            bottomRight: borderRadius.bottomRight,
          )
        : borderRadius;

    Widget content = Container(
      padding: DialogConstants.dialogPadding,
      decoration: BoxDecoration(
        // A style may paint a wash across the surface instead of a flat fill.
        color: spec.fillGradient == null ? colorConfig.backgroundColor : null,
        gradient: spec.fillGradient,
        borderRadius: contentBorderRadius,
        border: isLeftAccent || spec.borderGradient != null
            ? null
            : Border.all(
                color: colorConfig.borderColor ?? SpSurface.hairline(isDark),
                width: colorConfig.borderWidth ?? 1.5,
              ),
        boxShadow: DialogShadows.getShadows(
          isDark,
          isOutlined: isOutlined,
          designStyle: colorConfig.designStyle,
          accentColor: colorConfig.iconColor,
        ),
      ),
      child: child,
    );

    // A gradient stroke cannot be expressed as a Border, so it is painted as
    // a thin gradient-filled layer that the surface sits inside.
    final borderGradient = spec.borderGradient;
    if (borderGradient != null) {
      content = Container(
        padding: EdgeInsets.all(spec.borderWidth),
        decoration: BoxDecoration(
          gradient: borderGradient,
          borderRadius: borderRadius,
        ),
        child: content,
      );
    }

    if (colorConfig.designStyle == ContentDesignStyle.glass) {
      content = ClipRRect(
        borderRadius: contentBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: SpSurface.glassBlur,
            sigmaY: SpSurface.glassBlur,
          ),
          child: content,
        ),
      );
    }

    if (isLeftAccent) {
      content = ClipRRect(
        borderRadius: borderRadius,
        // IntrinsicHeight so `stretch` sizes the accent bar to the content.
        // Without it the Row takes every pixel of an unbounded height — which
        // is what turned the leftAccent dialog into a full-screen-tall card.
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: SpPalette.gradientFrom(colorConfig.iconColor),
                ),
                child: const SizedBox(width: 6),
              ),
              Expanded(child: content),
            ],
          ),
        ),
      );
    }

    return content;
  }
}
