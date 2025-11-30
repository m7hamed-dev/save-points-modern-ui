import 'package:flutter/material.dart';
import 'package:savepoints_modern_ui/dialog/dialog_constants.dart';

/// Dialog icon widget
class DialogIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const DialogIcon({
    super.key,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(DialogConstants.iconPadding),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: DialogConstants.iconSize,
            color: color,
          ),
        ),
        const SizedBox(height: DialogConstants.contentSpacingAfterIcon),
      ],
    );
  }
}

