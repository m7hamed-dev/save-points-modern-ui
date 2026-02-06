import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';

/// Professional bottom sheet shadows with layered depth
class BottomsheetShadows {
  const BottomsheetShadows();

  static List<BoxShadow> getShadows(
    bool isDark, {
    bool isOutlined = false,
    ContentDesignStyle? designStyle,
  }) {
    final style =
        designStyle ??
        (isOutlined ? ContentDesignStyle.outlined : ContentDesignStyle.solid);

    switch (style) {
      case ContentDesignStyle.outlined:
        // Subtle upward shadow for outlined style
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 1,
            offset: const Offset(0, -1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, -8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.04),
            blurRadius: 32,
            offset: const Offset(0, -16),
            spreadRadius: -8,
          ),
        ];

      case ContentDesignStyle.colorHeader:
        // Premium floating shadow for colorHeader
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.1),
            blurRadius: 24,
            offset: const Offset(0, -12),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.16 : 0.08),
            blurRadius: 48,
            offset: const Offset(0, -24),
            spreadRadius: -12,
          ),
        ];

      case ContentDesignStyle.leftAccent:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 1,
            offset: const Offset(0, -1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, -8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.04),
            blurRadius: 32,
            offset: const Offset(0, -16),
            spreadRadius: -8,
          ),
        ];

      case ContentDesignStyle.tonal:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 18,
            offset: const Offset(0, -8),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.14 : 0.06),
            blurRadius: 36,
            offset: const Offset(0, -16),
            spreadRadius: -8,
          ),
        ];

      case ContentDesignStyle.solid:
        // Deep shadow for solid bottom sheets
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
            blurRadius: 20,
            offset: const Offset(0, -8),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
            blurRadius: 40,
            offset: const Offset(0, -16),
            spreadRadius: -8,
          ),
        ];
    }
  }
}
