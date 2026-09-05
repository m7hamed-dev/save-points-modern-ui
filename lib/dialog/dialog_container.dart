import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';
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
    final borderRadius = BorderRadius.circular(DialogConstants.borderRadius);

    final contentBorderRadius = isLeftAccent
        ? BorderRadius.only(
            topRight: borderRadius.topRight,
            bottomRight: borderRadius.bottomRight,
          )
        : borderRadius;

    Widget content = Container(
      padding: DialogConstants.dialogPadding,
      decoration: BoxDecoration(
        color: colorConfig.backgroundColor,
        borderRadius: contentBorderRadius,
        border: isLeftAccent
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
