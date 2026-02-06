/// Design style for dialog, bottom sheet, and snackbar content.
///
/// - [ContentDesignStyle.solid]: Filled background with shadow (current default).
/// - [ContentDesignStyle.outlined]: Light background with colored border and dark text.
/// - [ContentDesignStyle.colorHeader]: Card with colored header area, icon in circle, and dark button.
enum ContentDesignStyle {
  /// Solid colored background, light text, with shadow (toast/snackbar style).
  solid,

  /// White/light background with colored border, dark text (outlined toast style).
  outlined,

  /// Card style with colored header gradient, centered icon in circle,
  /// title and message below, with a dark action button.
  /// Similar to modern notification/alert card designs.
  colorHeader,
}
