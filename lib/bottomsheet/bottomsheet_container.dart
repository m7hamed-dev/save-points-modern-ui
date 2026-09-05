/// Bottom sheet container widget with styling and safe area handling.
library;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_color_config.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_constants.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/bottomsheet/bottomsheet_shadows.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/design/save_points_tokens.dart';

/// Bottom sheet container with decoration
class BottomsheetContainer extends StatelessWidget {
  const BottomsheetContainer({
    super.key,
    required this.colorConfig,
    required this.child,
    this.showTopRadius = true,
  });

  final BottomsheetColorConfig colorConfig;
  final Widget child;
  final bool showTopRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOutlined = colorConfig.borderColor != null;
    final isLeftAccent =
        colorConfig.designStyle == ContentDesignStyle.leftAccent;
    const topRadius = BottomsheetConstants.topBorderRadius;

    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(showTopRadius ? topRadius : 0),
      topRight: Radius.circular(showTopRadius ? topRadius : 0),
      bottomLeft: const Radius.circular(BottomsheetConstants.borderRadius),
      bottomRight: const Radius.circular(BottomsheetConstants.borderRadius),
    );

    Widget content = Container(
      padding: BottomsheetConstants.padding,
      decoration: BoxDecoration(
        color: colorConfig.backgroundColor,
        borderRadius: isLeftAccent
            ? BorderRadius.only(
                topRight: borderRadius.topRight,
                bottomRight: borderRadius.bottomRight,
              )
            : borderRadius,
        border: isOutlined && !isLeftAccent
            ? Border(
                top: BorderSide(
                  color: colorConfig.borderColor!,
                  width: colorConfig.borderWidth ?? 2,
                ),
                left: BorderSide(
                  color: colorConfig.borderColor!,
                  width: colorConfig.borderWidth ?? 2,
                ),
                right: BorderSide(
                  color: colorConfig.borderColor!,
                  width: colorConfig.borderWidth ?? 2,
                ),
              )
            : null,
        boxShadow: BottomsheetShadows.getShadows(
          isDark,
          isOutlined: isOutlined,
          designStyle: colorConfig.designStyle,
          accentColor: colorConfig.iconColor,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(top: false, child: child),
      ),
    );

    if (colorConfig.designStyle == ContentDesignStyle.glass) {
      content = ClipRRect(
        borderRadius: borderRadius,
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

    // A neon sheet paints a near-black surface, but the `child` belongs to the
    // caller and is styled by *their* ThemeData — on a light theme that means
    // dark text on a near-black card, i.e. unreadable. Hand the subtree a
    // matching brightness so consumer content inherits legible colours.
    if (colorConfig.designStyle == ContentDesignStyle.neon && !isDark) {
      content = Theme(
        data: ThemeData.dark(useMaterial3: Theme.of(context).useMaterial3),
        child: content,
      );
    }

    return content;
  }
}
