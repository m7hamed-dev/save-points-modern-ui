import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/dialog/dialog_constants.dart';

/// Professional dialog icon widget with enhanced styling
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    BoxDecoration decoration;
    List<BoxShadow> shadows;

    if (isOutlined) {
      // Enhanced outlined style with subtle glow
      shadows = [
        BoxShadow(
          color: color.withValues(alpha: 0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
      decoration = BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.12 : 0.06),
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.6 : 0.4),
          width: 2,
        ),
        boxShadow: shadows,
      );
    } else {
      // Enhanced solid style with gradient effect
      shadows = [
        BoxShadow(
          color: color.withValues(alpha: 0.25),
          blurRadius: 16,
          offset: const Offset(0, 6),
          spreadRadius: -2,
        ),
        BoxShadow(
          color: color.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
      decoration = BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
        ),
        shape: BoxShape.circle,
        boxShadow: shadows,
      );
    }

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
