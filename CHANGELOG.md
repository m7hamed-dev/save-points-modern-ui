# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.0] - 2026-11-14

Closes the three issues 1.3.0 listed as known and deliberately left alone,
because each one changed behaviour or appearance for existing callers. A minor
release for that reason; nothing public was renamed or removed, so every
existing call still compiles.

### Fixed

- **The typed snackbar helpers no longer override your config.**
  `showSuccess`, `showError`, `showWarning`, `showInfo`, their four
  `BuildContext` counterparts and `SnackbarQueue.enqueue` all declared
  `bool showProgressIndicator = false`, so setting
  `SnackDiaBottomConfig().snackbar.defaultShowProgressIndicator = true` in
  `main()` reached `show` but was silently discarded by every helper. The
  parameter is now `bool?` and falls through to the config. Passing an
  explicit value still wins.

### Changed

- **The typed dialog extensions draw from the package palette.**
  `context.showSuccessDialog`, `showErrorDialog` and `showInfoDialog`
  hard-coded `Colors.green`, `Colors.red` and `Colors.blue` with the
  square-cornered Material icons, so a success dialog and a success snackbar
  disagreed about what "success" looks like. They now resolve their icon and
  accent from `SpPalette` for the intent — the same source the snackbars use
  — and for the ambient brightness, so they adapt to dark mode as well
  (`0xFF34D399` dark against `0xFF10B981` light, for success). `icon` and
  `iconColor` became nullable to allow it; pass either to override.

  **If you relied on the old colours**, pass them explicitly:
  `context.showSuccessDialog(..., iconColor: Colors.green, icon: Icons.check_circle)`.

- **The example settles.** Its rotating background gradient looped forever and
  its header icon breathed forever, which cost a full-screen repaint every
  frame for as long as the demo was open and made `pumpAndSettle()` unusable
  against it — so its own smoke tests had to hand-count `pump(duration)`
  calls. The gradient now turns once; because the sweep's start and end angles
  are 2π apart it lands exactly where it began, so nothing jumps. The header
  icon takes one breath and rests. The smoke tests were rewritten to use
  `pumpAndSettle()` throughout, which is how the fix is verified.

### Documentation

- The snackbar parameter table claimed a default `duration` of 4 seconds;
  `SnackbarConfig.defaultDuration` is 3.
- `showProgressIndicator`'s default is listed as coming from the config rather
  than as a flat `false`.
- New **`BuildContext` shortcuts** section in the README: the extension was
  public API with no entry there at all, and its defaults are worth stating
  now that they come from the palette.

### Tests

- 113 → 120 in the package; the example's four smoke tests now assert the app
  comes to rest.
- Reverting either code fix fails five of the new tests, which is how they
  were checked.

## [1.3.0] - 2026-11-13

> **One behaviour changes in every app.** Tapping outside a dialog now
> dismisses it. That is what `barrierDismissible` has promised since 1.0 and
> what it defaults to, but it never actually worked — see
> [Fixed](#fixed). If any of your dialogs relied on *not* closing, pass
> `barrierDismissible: false` (or set it on a `SavePointsTheme`) before
> upgrading. Bottom sheets and snackbars are unaffected.

A quality and documentation pass, released as a **minor** rather than a patch
because it adds public API (`SavePointsSnackbar.showInfo`) and changes a
user-visible behaviour. Source-compatible throughout: no public name was
removed or renamed and every existing call still compiles, so `^1.2.1`
resolves to this release.

### Fixed

- **Tapping outside a dialog dismisses it.** Both `SavePointsDialog.show` and
  `showCustom` built their card as `Material` → `Center` → card. The
  transparent `Material` therefore filled the whole screen and hit-tested as
  opaque, swallowing every tap meant for the barrier underneath: measured on
  an 800×600 surface, the dialog's box was the full 800×600 while the visible
  card was 400×307. `barrierDismissible` — `true` by default — had no effect.
  The order is now `Center` → `Material` → card, and the dialog's horizontal
  inset moved outside the `Material` the way Flutter's own `Dialog` places
  `insetPadding`, so the region that absorbs taps is exactly the visible card
  and the strip beside it dismisses too. Bottom sheets were never affected:
  their barrier is a separate `GestureDetector` layered above the sheet.
  Pixel geometry of the card is unchanged.
- **A rebuild no longer cancels a `loadingNotifier`-driven spinner.**
  `ModernDialog` and `ModernBottomsheet` assigned `_isLoading = widget.isLoading`
  on *every* `didUpdateWidget`, so any rebuild from above reset the spinner
  the notifier had just turned on. Because a route's `transitionBuilder`
  rebuilds its child once per frame, a spinner raised during the open
  animation was cancelled as fast as it appeared. The static flag now moves
  the state only when it actually changes.
- **A `loadingNotifier` that is already `true` is honoured from the first
  frame.** `initState` seeded the state from `widget.isLoading` and never read
  the notifier, so a surface opened mid-flight showed no spinner until that
  notifier happened to change again. Swapping one notifier for another now
  adopts the new one's value immediately too, instead of leaving the old one's
  state on screen.

### Added

- **`SavePointsDialog.showCustom` now resolves its defaults from an in-scope
  `SavePointsTheme`.** It read neither the theme nor anything else, so a
  `SavePointsTheme` that set `blur` or `barrierDismissible` applied to every
  surface in the subtree *except* this one. Both now follow the documented
  order — explicit argument → nearest theme → built-in default — exactly as
  `show` does. `barrierDismissible` changed from `bool barrierDismissible =
  true` to `bool?` so that "not given" can fall through to the theme; passing
  a value, or passing nothing without a theme, behaves exactly as before.
- **`SavePointsSnackbar.showInfo`** — the counterpart of `showSuccess`,
  `showError` and `showWarning` for `SnackbarType.info`, which the class
  documented as a supported type but offered no helper for.
- **The `BuildContext` snackbar extensions now return their
  `ScaffoldFeatureController`** instead of `void`, so
  `context.showSuccessSnackbar(...)` can be closed early or awaited the same
  way `SavePointsSnackbar.showSuccess(...)` can. Callers that ignore the
  result are unaffected.

### Changed

- **One shared loading-state implementation.** The identical ~25-line
  notifier lifecycle in `ModernDialog` and `ModernBottomsheet` moved into an
  internal `LoadingStateMixin`, so the two cannot drift apart again. It is
  deliberately not exported.
- **The repeated design-style tests in `SavePointsSnackbar.show` are resolved
  once** instead of being spelled out identically in both position branches.
- **`deprecated_member_use` is an `info`, not an `error`.** Flutter 3.47
  deprecated `package:flutter/material.dart` itself, which this line is built
  on deliberately, so every file reported an error nothing here could act on
  — 51 of them, which is what pub.dev's analysis saw. `dart analyze` now
  reports **no errors and no warnings**, and the deprecations that *can* be
  acted on are no longer buried.
- Documentation accuracy, all of it user-visible:
  - the pub.dev screenshot caption said "eight built-in design styles"; there
    are twelve;
  - `ContentDesignStyle`'s own doc listed only five of its twelve values, and
    called `solid` "the current default" without saying that is true for
    snackbars but not for dialogs and bottom sheets;
  - `SavePointsDialog.show` promised an assertion when `message` is empty; it
    asserts on `title` only, and an empty `message` is valid alongside a
    `child`;
  - `applyTheme` on all three config classes said it applied theme-aware
    settings while doing nothing at all; it is now documented as the reserved
    no-op it is;
  - `margin`, `actionLabel` and `onActionPressed` are ignored for
    `SnackbarPosition.top` — an overlay toast has no `SnackBarAction` slot —
    which the parameters now say.

### Documentation

- README rewritten around a single `H1` with a uniform badge row, and gained a
  **Compatibility** table (Dart `^3.6.0`, Flutter 3.27+, every platform, zero
  dependencies) and a **FAQ** covering the questions this API actually raises.
- **Four dead links removed.** The demo GIF in the hero, both "Live Demo"
  URLs and the GitHub Discussions link all returned 404.
- The "Running the Example" instructions pointed at `lib/main.dart` and
  `cd save_points_snackbar_dialog_bottomsheet`; neither path exists.

### Tests

- 78 → 113 tests in the package, plus 3 new smoke tests in the example.
- `test/api_surface_test.dart` is a new backward-compatibility guard: it calls
  every public entry point the way 1.2.1 documented it, so a future rename or
  signature change fails to compile instead of reaching pub.dev.
- `test/_doc_check.dart` type-checks every Dart snippet in the README's FAQ.
- `example/test/` drives the demo's real buttons, so the example is verified
  to work rather than merely to compile.

## [1.2.1] - 2026-09-11

> **Upgrading from 1.2.0 needs a look.** Despite the patch number this release
> removes public API — `AccessibilityUtils`, `ValidationUtils`, `ThemeUtils`,
> `SnackbarPresets`, `AnimationPresets` and `StaticEnhancedIcon` — and changes
> some layout defaults. A `^1.2.0` constraint resolves to it automatically, so
> anyone who imported those names will meet a compile error rather than a
> deprecation notice. See [Removed](#removed) for what to use instead.

**In short:** four crashes and compile errors are fixed, the twelve design
styles now resolve in one place instead of drifting apart across three
components, contrast meets WCAG AA everywhere, and the minimum SDK drops from
Dart 3.11 to 3.6 so most projects can actually install it.

### Added

- **Four new design styles**, taking the family to twelve:
  - `brutalist` — flat punchy fill, a 3dp hard-edged border and an offset
    shadow with no blur at all. Tight corners; deliberately un-soft.
  - `gradientBorder` — a neutral surface ringed by a vivid gradient stroke,
    so the accent frames the content without tinting it.
  - `aurora` — a multi-stop wash of the accent bleeding diagonally across the
    surface, like light through frosted colour.
  - `soft` — claymorphic: pastel fill, generous rounding and a light-from-
    above pair of shadows.
- **`SavePointsTheme` scoped defaults** — an `InheritedWidget`
  (`SavePointsTheme` + `SavePointsThemeData`) that declares component defaults
  once in the widget tree instead of repeating `designStyle:` / `blur:` on
  every call or mutating the `SnackDiaBottomConfig` singleton. Covers
  `designStyle`, `blur`, `snackbarPosition`, `snackbarDuration`,
  `enableHapticFeedback`, `barrierDismissible` and `enablePulse`. Resolution
  order is explicit argument → nearest theme → built-in default, so adopting
  it is backward compatible and scopes per subtree.
- **`SpStyles`** — one resolver that turns a `ContentDesignStyle` into a
  concrete surface spec (fill, wash, border, gradient stroke, elevation,
  rounding, text colours). Public, so you can decorate your own widgets in the
  package's language.
- **Design tokens are public**: `SpRadius`, `SpSpacing`, `SpType`, `SpMotion`,
  `SpSurface`, `SpPalette`, `SpAccent`, `SpIntent`, `SpShadows` and the new
  `SpContrast`.
- **Canonical entry point** — `save_points_snackbar_dialog_bottomsheet.dart`,
  so the import path matches the package name. One import exposes the whole
  public API.
- **Test suite**, from 26 tests to 78: design tokens, the snackbar queue, the
  three `show()` APIs across every style, a regression test per fix below, and
  a quality suite that guards contrast, idle frame count and text scaling.
- pub.dev metadata: `topics`, `platforms` and `screenshots`.

### Changed

- **Minimum SDK lowered from `^3.11.5` to `^3.6.0`** (Flutter 3.27+). The old
  floor bought nothing but dot-shorthand syntax (`.circular(12)`,
  `behavior: .floating`) and locked out every user below Dart 3.11. 174 call
  sites desugared; behaviour unchanged.
- **Icon pulse is opt-in.** Icons looped a scale-and-glow animation forever
  with no way to switch it off, so a surface repainted every frame for as long
  as it was open and `pumpAndSettle()` hung in consumers' tests. Now off by
  default — `enablePulse: true` on `show()`, or on `SavePointsThemeData` for a
  subtree.
- **`SavePointsSnackbar.show` returns a truthful controller for
  `SnackbarPosition.top`.** It used to return a placeholder `SnackBar` with a
  1 ms duration, so `close()` did nothing and `closed` completed almost
  immediately — which also made `SnackbarQueue` fire every queued item at
  once. The placeholder now lives exactly as long as the toast and is its
  single clock.
- **Every style resolves in one place.** The three components each carried
  their own answer to the same questions — 64 style branches across three
  colour-config files and three shadow files — and had drifted. They all
  delegate to `SpStyles` now, so a style looks like itself wherever it is used
  and a new one is written once instead of three times.
- **The `colorHeader` band is one widget.** All three components built it
  themselves, and the copies drifted: a 110dp band on a dialog against 90dp on
  a snackbar, a 14dp close chip against 12dp, a 16dp glyph against 14dp. Worse,
  the snackbar derived its band from a pastel of the accent (saturation 0.3,
  lightness 0.92), so the "coloured header" was a wash you could barely see.
  260 lines lighter, and of 72 rendered states 66 came back byte-identical —
  only the six `colorHeader` shots moved.
- **Surfaces honour a style's wash, gradient stroke and rounding**, not just
  its fill and border — which is what lets `aurora`, `gradientBorder` and
  `brutalist` exist at all.
- **The top toast no longer restructures the overlay.** Each toast used to
  insert its own `OverlayEntry` and remove it again, both deferred to
  post-frame callbacks to dodge Flutter's `mouse_tracker`
  `_debugDuringDeviceUpdate` assertion — a workaround the 1.2.x source already
  carried, and one that left the insert racing its own removal. One entry per
  overlay now, whose *content* changes.
- **The barrier fade costs one layer instead of two.** It animated an
  `Opacity` wrapped around the `BackdropFilter`, paying for a screen-sized
  `saveLayer` on every frame of the entrance. It ramps the blur sigma and dim
  alpha instead, so the background comes into focus rather than a finished
  blur dissolving in.
- **Barrier blur is an explicit, documented default.** Dialogs and sheets
  always blurred even when `blur` was null, contradicting the documented "when
  null, no blur is applied". Behaviour is unchanged, but the default is named
  (`defaultBarrierBlurSigma`) and `blur: 0` is the documented opt-out.
- **`SnackbarQueue` dispatch is an exhaustive `switch`**, so a new
  `SnackbarType` is a compile error rather than silently falling through to
  "warning".
- Bottom-sheet button labels pick their colour by measured contrast, as dialog
  labels already did.
- The package no longer ships example code in `lib/`; the demo lives in
  `example/` where pub.dev can show it.
- `require_trailing_commas` disabled — it fights the Dart 3.7+ formatter,
  which removes the very commas the rule then demands back.
- The example app demonstrates `SavePointsTheme` instead of mutating
  process-wide globals.

### Fixed

**Crashes and compile errors**

- **Two top snackbars in the same frame threw** *"An OverlayEntry should be
  removed only once"*. `show()` deferred its insert and skipped it when a
  newer toast claimed the slot, while `hide()` still scheduled a removal for
  that never-inserted entry. Reproduced by any double-tapped button.
- **Ambiguous import with `package:flutter/semantics.dart`.** The package
  exported its own `SemanticsProperties`, which collided with Flutter's and
  failed consumer builds.
- **Top snackbars leaked a timer past the widget tree.** The auto-dismiss
  timer and overlay entry were `static`, so they outlived disposal and later
  fired against a disposed `AnimationController` and `ScaffoldMessenger`.
- **`SnackbarQueue` could wedge permanently.** `clear()` left `_isShowing`
  set, so every later `enqueue()` was silently swallowed. Stale `closed`
  callbacks could also clobber the snackbar currently showing; they are
  generation-guarded now.

**Contrast** — measured across every style in both brightnesses, 32 checks now
guarded by `test/quality_test.dart`. Three combinations were under the 4.5:1
WCAG AA floor for body text:

- Dark-mode dialog buttons read **2.54:1** — a white label on the dark-theme
  blue. Label colour is now chosen by measured contrast rather than assumed
  white, which also protects caller-supplied colours. **7.36:1**.
- `tonal` body text **3.93:1** → **6.26:1** (light muted tone moved from
  slate-500 to slate-600).
- `glass` body text **2.50:1** → **8.68:1** (a translucent surface composites
  over whatever is behind it, so it needs its own darker body tone).

Layout was also checked at 1.5x and 2.0x text scale: no overflow.

**Styles that were not delivering what the tokens described**

- **`leftAccent` was broken.** Its accent bar sat in a `Row` with
  `CrossAxisAlignment.stretch` and no height bound, so the dialog stretched to
  fill the viewport instead of hugging its content, and the bar was not
  visible at all.
- **`glass` was not translucent.** Its fill sat at 58% alpha — opaque enough to
  hide its own `BackdropFilter`, which is why it looked like `solid`. Now 30%
  (light) / 38% (dark) with a brighter highlight edge.
- **`solid`'s icon chip was a wash** — the accent gradient at 22%/12% alpha.
  Now full strength with a white glyph, which is what makes `solid` read as the
  boldest of the family.
- **`neon` barely glowed**; the bloom is wider and stronger.
- **`neon` sheets rendered the caller's `child` dark-on-dark**, because that
  child inherits the app's own `ThemeData` while the surface is near-black.
  The subtree gets a matching brightness now.
- **`outlined` borders were nearly invisible** at 25–30% alpha. Now 55%
  (light) / 62% (dark).
- **Colored-glow elevation was invisible in light mode** (halo at 22%, now
  34%), which is what separates `solid` from `minimal` at a glance.

**Behaviour**

- **`hideLikeCircle` was accepted and ignored.** It is forwarded to the
  top-position toast now — the only position that can honour it, since bottom
  snackbars are laid out by `ScaffoldMessenger`.
- **Circular-reveal animations were hard-coded LTR.** Three clippers called
  `alignment.resolve(TextDirection.ltr)`, so directional alignments revealed
  from the wrong edge in RTL. They resolve against `Directionality.of` now.
- **Bottom snackbars sat too high.** The package added 80dp of "FAB space" on
  screens taller than 700dp — a guess, and a double-count: `Scaffold` already
  lifts a floating `SnackBar` clear of the FAB (measured at 72dp) and of the
  bottom safe area.
- **Snackbars were invisible to screen readers.** Content sits in a `Semantics`
  live region now, with `explicitChildNodes` so the close button stays
  reachable rather than being collapsed into the announcement. Every icon-only
  close affordance carries a localized label from `MaterialLocalizations`.
- The example app's action buttons scaled themselves from a `MouseRegion`
  hover callback, moving their own hit area out from under the pointer; the
  scale is painted with `transformHitTests: false` now.
- A stray `debugPrint` logged on every `ModernDialog` build.
- Dialogs tinted a caller-supplied `child` with a translucent blue debug box.
- Placeholder `yourusername` URLs in `pubspec.yaml` and the README pointed
  nowhere.

### Deprecated

- `SavePointsBottomsheet.defaultDesignStyle` — use
  `SavePointsTheme(data: SavePointsThemeData(designStyle: ...))`. A mutable
  static is process-wide and notifies nothing already on screen.
- `SavePointsConstants` — superseded by the `SpSpacing` / `SpRadius` /
  `SpMotion` tokens it duplicates one-for-one.
- `KeyboardUtils.dismissKeyboardForDialog` and
  `.dismissKeyboardForBottomSheet` — use `KeyboardUtils.dismissIfFocused`.

### Removed

Public API with no callers anywhere — not in the package, the example, the
tests or the README:

- **`AccessibilityUtils` and its `SemanticsProperties`** — unused, and the name
  collided with Flutter's own `SemanticsProperties`, breaking consumer builds.
  Real `Semantics` is wired into the components now; if you used it, call
  `Semantics(...)` from `package:flutter/material.dart` directly.
- **`ValidationUtils`** — `isNotEmpty`, `isPositiveDuration` and friends, none
  of which the package ever called.
- **`ThemeUtils`** — one-line wrappers around `Theme.of(context)`.
- **`SnackbarPresets`** and **`AnimationPresets`** (with its `AnimationConfig`)
  — preset tables nothing read. `DialogPresets` is genuinely used and stays.
- **`StaticEnhancedIcon`** — a non-animating variant of `EnhancedIcon` that was
  never built.

## [1.1.10] - 2026-02-13

### Added

- **Dialog Custom Content**: New optional `child` parameter for all dialog types
  - `SavePointsDialog.show()`: Add custom widgets between message and action buttons
  - `ModernDialog`: Support for custom child widget with proper spacing
  - `DialogTransitionScope`: Pass-through support for child parameter
  - Works with all design styles (solid, outlined, colorHeader, leftAccent, tonal)
  - Example app: Added "With Custom Child" dialog showing form inputs (name and email fields)
  - Example app: Added "Rating Dialog" with interactive 5-star rating widget using colorHeader style

### Use Cases

- Form inputs within dialogs (text fields, dropdowns, etc.)
- Interactive widgets (rating systems, sliders, switches)
- Custom content layouts (images, charts, custom UI elements)
- Rich content presentation (formatted text, lists, cards)

## [1.1.10] - 2026-02-07

### Added

- **OrganicShape**: New shared utility for organic blob-like shapes (amoeba/fluid forms)
  - `OrganicShape.pathInRect()` for smooth irregular closed paths
  - `OrganicShapeClipper` for clipping widgets to organic blob shape
  - `OrganicBlobBorderPainter` for painting blob outlines with optional soft shadow/glow

### Improved

- **DialogIcon**: Enhanced icon styling with entrance scale animation, subtle pulse glow, gradient icon fills, and refined design-style decorations
- **AnimatedIcon**: Added `colorHeader` design style support for snackbar icons; refined solid, outlined, and color-header icon container styling with gradient fills

## [1.1.4] - 2026-02-02

### Added

- **HeaderDialog**: New dialog style with colored header bar and close button positioned outside the dialog box
- **SavePointsDialog.showCustom()**: New method to show custom dialogs with header, custom content widget, and primary/secondary action buttons
  - Close button outside the dialog (top-left)
  - Colored header with customizable background and text color
  - Custom child widget for flexible content
  - Primary and secondary action buttons
  - Support for blur/glassmorphism backdrop
- **Example app**: Added HeaderDialog and snackbar dismiss animation examples

### Fixed

- **Snackbar dismiss animation**: Fixed animation not playing on dismiss by using `AnimatedBuilder` and proper curve handling
- **Animation curves**: Added `reverseCurve` (easeInCubic) for smooth exit animations instead of reversed bounceOut/elasticOut
- **Nested animations**: Cleaned up nested `CurvedAnimation` wrappers that prevented proper animation playback

### Changed

- **Animation architecture**: Simplified by passing controller directly to `AnimatedWrapper` instead of pre-curved animation
- **Dismiss handling**: Use `removeCurrentSnackBar()` instead of `hideCurrentSnackBar()` to avoid Flutter's dismiss animation conflict

## [1.1.3] - 2026-02-02

### Added

- **Snackbar dismiss animation**: Snackbar now animates out when dismissed via close button or tap-to-dismiss, reversing the entrance animation for a smooth exit

### Improved

- **TopSnackbarOverlay**: Close button now triggers animated dismiss instead of instant removal

## [1.1.2] - 2026-02-02

### Changed

- **Documentation**: Updated README with keyboard-aware feature for bottom sheets

## [1.1.1] - 2026-02-02

### Fixed

- **Keyboard visibility with TextFormField**: Bottom sheet now properly positions above the keyboard when a text field is focused, ensuring the input field remains visible
- **Bottom sheet max height**: Dynamically adjusts max height when keyboard is visible to prevent content overflow

### Improved

- **BottomsheetContainer**: Wrapped child in `SafeArea` to improve visibility and prevent content overflow at the bottom of the screen
- **BottomsheetContainer**: Better handling of safe area for a more consistent user experience across devices

### Changed

- **Bottom sheet positioning**: Sheet now uses `Positioned` widget to lift above keyboard instead of internal padding, providing smoother keyboard interaction
- **BottomsheetContainer**: Refactored code organization by moving property declarations to the constructor for improved readability
- **BottomsheetContainer**: Enhanced `boxShadow` configuration formatting for better code clarity

## [1.1.0] - 2026-01-31

### Added

- **Two design styles (solid & outlined)** for dialogs, snackbars, and bottom sheets
  - `ContentDesignStyle` enum: `solid` (filled background, current default) and `outlined` (light background with colored border and dark text)
  - Snackbar: `designStyle` parameter and config `SnackbarConfig.defaultDesignStyle`; outlined style includes close button, bordered icon container, and refined shadows
  - Dialog: `designStyle` parameter and config `DialogConfig.defaultDesignStyle`; outlined style uses bordered icon, outlined cancel button, and light shadows
  - Bottom sheet: `designStyle` parameter; outlined style uses light/dark surface with primary border
- **Theme support for both styles** – Outlined style adapts to light and dark theme (dark background and light text in dark mode)
- **Design enhancements**
  - Snackbar: icon container with outlined variant (bordered circle), progress bar with rounded ends and track color, 48dp touch target for close button, typography (title/subtitle line height and letter spacing), refined outlined shadows
  - Dialog: icon with outlined variant (bordered circle), button minimum height 48dp for accessibility, refined outlined shadows
  - Bottom sheet: larger handle (44×5) and pill-shaped border radius
- **Snackbar sizing** – Minimum width (320dp) for bottom-position snackbars so they don’t appear too small

### Changed

- **Dismiss animation** – Dialog and bottom sheet barrier (blur + dim) now animate with the route so the blur stays visible during dismiss instead of disappearing abruptly
- **Top-position snackbar** – Dummy SnackBar used for the controller is no longer placed off-screen (avoids “Floating SnackBar presented off screen”); uses on-screen margin with 1ms duration
- **Shadows** – Refined multi-layer shadows for outlined style and primary buttons

### Fixed

- “Floating SnackBar presented off screen” when using top-position snackbars (dummy SnackBar now uses valid on-screen margin)
- Small snackbar at bottom when using short text (min width applied for bottom position)

## [1.0.5] - 2026-01-29

### Changed
- Documentation and version references updated for release

## [1.0.4] - 2026-01-28

### Changed
- **Code Quality & Architecture**: Comprehensive refactoring for professional code standards
  - Extracted magic numbers into named constants (`_AnimationConstants`, `_SpacingConstants`)
  - Improved code organization with better method separation and structure
  - Enhanced theme building with dedicated methods (`_buildLightTheme`, `_buildDarkTheme`)
  - Refactored animation initialization into separate methods for better maintainability
  - Improved navigation handling with dedicated method (`_handleNavigationSelection`)
  - Better section building with consolidated `_buildAllSections()` method

### Improved
- **Documentation**: Added comprehensive documentation throughout the codebase
  - Added library documentation headers to all main files
  - Enhanced class and method documentation with detailed descriptions
  - Added parameter documentation for public properties
  - Improved code comments for better maintainability
- **Code Organization**: Better structure and separation of concerns
  - Refactored margin calculation in `SavePointsSnackbar` into dedicated helper methods
  - Extracted keyboard dismissal logic into reusable helper methods
  - Improved import organization (alphabetical, grouped)
  - Better consistency across all example widgets
- **Maintainability**: Improved code maintainability and readability
  - Extracted helper methods for common operations
  - Better naming conventions and code structure
  - Improved error handling and code organization
  - Enhanced example widget documentation

### Technical Details
- **main.dart**: Refactored example app with constants extraction and better organization
- **savepoints_snackbar.dart**: Improved margin calculation with dedicated helper methods
- **savepoints_dialog.dart**: Extracted keyboard dismissal into reusable helper
- **savepoints_bottomsheet.dart**: Extracted keyboard dismissal into reusable helper
- **Example Widgets**: Enhanced documentation and consistency across all widgets

## [1.0.3+1] - 2025-01-24

### Added
- Improved snackbar position handling in `SavePointsSnackbar` and `SnackbarConfig` for better flexibility

### Changed
- **ModernBottomsheet**: Use `MediaQuery.sizeOf` for height calculations; updated border radius property for consistency
- **ModernBottomsheet**: Moved property declarations to constructor for clearer structure
- **AnimatedWrapper**: Moved property declarations to constructor for clarity
- **BottomsheetLoadingIndicator**: Refactored constructor by removing redundant declaration

## [1.0.2+1] - 2025-12-18

### Added
- Enhanced example app with beautiful animations and effects
- Animated gradient background with smooth transitions
- Staggered section animations for improved visual appeal
- Interactive button animations with scale, hover, and ripple effects
- Bottom navigation bar with snackbar feedback
- New "More Examples" section showcasing advanced use cases:
  - Dialog chains and sequential flows
  - Snackbar queuing examples
  - Combined dialog → snackbar flows
  - Bottom sheet → dialog interactions
  - Success and error flow demonstrations
  - Story flow with multiple steps
  - Quick actions bottom sheet
- Additional dialog examples using DialogPresets:
  - Delete confirmation dialogs
  - Logout confirmation dialogs
  - Update available dialogs
  - Feature not available dialogs
  - Discard changes confirmations
- Additional snackbar examples:
  - Long duration snackbars
  - Custom color schemes
  - Scale, fade, and rotate-scale animations
  - Persistent snackbars with tap to dismiss
  - Rainbow gradient snackbars

### Changed
- Updated example app UI with modern design patterns
- Improved code organization and structure
- Enhanced user experience with smooth animations throughout

### Fixed
- Fixed deprecated `withOpacity` method usage (replaced with `withValues`)
- Fixed deprecated `Matrix4.scale` method (replaced with `scaleByDouble`)
- Fixed async context usage issues (added proper `context.mounted` checks)
- Fixed linter warnings for `prefer_final_in_for_each`
- Improved code quality and static analysis compliance
- Removed circular reveal examples from example app (feature still available in API)

### Improved
- Better error handling in async operations
- Enhanced code maintainability
- Improved example app performance with optimized animations

## [1.0.1+1] - 2024-12-03

### Added
- Example app demonstrating all package features
- Comprehensive documentation for AnimatedIcon class

### Fixed
- Fixed lint warning in SnackbarColorConfig (use initializing formal)
- Improved code quality and static analysis score

## [1.0.0+1] - 2024-12-01

### Added
- Initial release of SavePoints Modern UI
- Modern dialog component with glassmorphism effects
- Enhanced snackbar component with multiple animations
- Customizable bottom sheet component
- Support for dark mode
- Extensive customization options for all components
- Multiple animation types (fade, slide, scale, bounce, rotate, elastic, slideRotate)
- Progress indicators for snackbars
- Loading states for dialogs and bottom sheets
- Custom start/end animations for dialogs and bottom sheets
- Circular reveal animation (`hideLikeCircle`) for all components
- Gradient backgrounds support
- Haptic feedback support
- Centralized configuration system
- Performance optimizations with RepaintBoundary

### Features
- **Dialogs**: Glassmorphism design, customizable icons, flexible actions, smooth animations
- **Snackbars**: Multiple types (success, error, warning, info), rich animations, progress indicators, position control
- **Bottom Sheets**: Modern design, drag handle, scrollable content, custom animations

