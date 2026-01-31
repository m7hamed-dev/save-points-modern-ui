import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_constants.dart';

/// Dialog icon widget with optional outlined style
class DialogIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final ContentDesignStyle? designStyle;

  const DialogIcon({
    super.key,
    required this.icon,
    required this.color,
    this.designStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isOutlined = designStyle == ContentDesignStyle.outlined;
    final decoration = BoxDecoration(
      color: isOutlined
          ? color.withValues(alpha: 0.08)
          : color.withValues(alpha: 0.1),
      shape: BoxShape.circle,
      border: isOutlined
          ? Border.all(color: color, width: 2)
          : null,
    );

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(DialogConstants.iconPadding),
          decoration: decoration,
          child: Icon(icon, size: DialogConstants.iconSize, color: color),
        ),
        const SizedBox(height: DialogConstants.contentSpacingAfterIcon),
      ],
    );
  }
}
