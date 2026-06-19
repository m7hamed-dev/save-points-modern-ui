/// Design style for dialog, bottom sheet, and snackbar content.
///
/// - [ContentDesignStyle.solid]: Filled background with shadow (current default).
/// - [ContentDesignStyle.outlined]: Light background with colored border and dark text.
/// - [ContentDesignStyle.colorHeader]: Card with colored header area, icon in circle, and dark button.
/// - [ContentDesignStyle.leftAccent]: Light/dark surface with a colored vertical bar on the left.
/// - [ContentDesignStyle.tonal]: Material 3 filled tonal — light tinted background, dark text.
enum ContentDesignStyle {
  /// Solid colored background, light text, with shadow (toast/snackbar style).
  solid,

  /// White/light background with colored border, dark text (outlined toast style).
  outlined,

  /// Card style with colored header gradient, centered icon in circle,
  /// title and message below, with a dark action button.
  /// Similar to modern notification/alert card designs.
  colorHeader,

  /// Light or dark surface with a colored vertical bar on the left edge.
  /// Clean, minimal look popular in notification UIs.
  leftAccent,

  /// Material 3 filled tonal: light tinted background (e.g. light green for success),
  /// dark text, medium elevation. Softer than [solid].
  tonal,

  /// Frosted glassmorphism: translucent surface over a backdrop blur with a
  /// hairline highlight border and soft elevation.
  glass,

  /// Neon: deep near-black surface with a glowing vivid accent border and an
  /// intense colored bloom. Loud and futuristic.
  neon,

  /// Minimal: opaque surface, single hairline border, flat (no shadow).
  /// Clean and understated.
  minimal,
}
