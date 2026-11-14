/// Design style for dialog, bottom sheet, and snackbar content.
///
/// Twelve styles share one resolver, `SpStyles.of`, so a surface looks the
/// same whether it is a dialog, a bottom sheet or a snackbar.
///
/// | Style | Looks like |
/// |---|---|
/// | [solid] | Filled background, light text, soft shadow |
/// | [outlined] | Light surface, coloured border, dark text |
/// | [colorHeader] | Card with a coloured header band and a circled icon |
/// | [leftAccent] | Plain surface with a coloured bar down the left edge |
/// | [tonal] | Material 3 filled tonal — tinted surface, dark text |
/// | [glass] | Frosted translucency over a backdrop blur |
/// | [neon] | Near-black surface, glowing accent border and bloom |
/// | [minimal] | Opaque surface, hairline border, no shadow |
/// | [brutalist] | Flat fill, thick hard border, offset un-blurred shadow |
/// | [gradientBorder] | Neutral surface ringed by a vivid gradient stroke |
/// | [aurora] | Soft multi-stop wash of the accent across the surface |
/// | [soft] | Pastel claymorphic fill with light-from-above shadows |
///
/// Defaults differ per component: snackbars default to [solid], dialogs and
/// bottom sheets to [colorHeader]. Override per call with `designStyle:`, per
/// subtree with `SavePointsTheme`, or process-wide via `SnackDiaBottomConfig`.
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

  /// Neo-brutalist: flat punchy fill, a thick hard-edged border and an
  /// offset shadow with no blur. Loud, graphic, deliberately un-soft.
  brutalist,

  /// A neutral surface ringed by a vivid gradient stroke. Reads as premium
  /// without tinting the content area.
  gradientBorder,

  /// Aurora: a soft multi-stop wash of the accent across the surface, like
  /// light bleeding through frosted colour.
  aurora,

  /// Claymorphic: pastel fill, generous rounding and a light-from-above pair
  /// of shadows. Friendly and tactile.
  soft,
}
