import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/content_design_style.dart';

/// Professional dialog shadows configuration with layered depth
class DialogShadows {
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
        // Clean, minimal shadow for outlined style
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.04),
            blurRadius: 32,
            offset: const Offset(0, 16),
            spreadRadius: -8,
          ),
        ];

      case ContentDesignStyle.colorHeader:
        // Premium floating card shadow
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 12),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.16 : 0.08),
            blurRadius: 48,
            offset: const Offset(0, 32),
            spreadRadius: -12,
          ),
        ];

      case ContentDesignStyle.leftAccent:
        // Same as outlined: clean, minimal shadow
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.04),
            blurRadius: 32,
            offset: const Offset(0, 16),
            spreadRadius: -8,
          ),
        ];

      case ContentDesignStyle.tonal:
        // Softer than solid, medium depth
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.06),
            blurRadius: 40,
            offset: const Offset(0, 20),
            spreadRadius: -8,
          ),
        ];

      case ContentDesignStyle.solid:
        // Deep, immersive shadow for solid dialogs
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
            blurRadius: 24,
            offset: const Offset(0, 12),
            spreadRadius: -6,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 48,
            offset: const Offset(0, 24),
            spreadRadius: -12,
          ),
        ];
    }
  }
}
