# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-09-05

A correctness release. Three of these were crashes or compile errors in real
apps, so the fixes are worth the major bump; the rest widen who can install the
package at all.

### Fixed

- **Crash showing two top snackbars in the same frame.** `show()` deferred its
  overlay insert to a post-frame callback and skipped it when a newer toast had
  claimed the slot, while `hide()` still scheduled a removal for that
  never-inserted entry — tripping *"An OverlayEntry should be removed only
  once"*. Removal is now guarded on `OverlayEntry.mounted`. Reproduced by any
  double-tapped button or back-to-back error message.
- **Ambiguous import when using `package:flutter/semantics.dart`.** The package
  exported its own class named `SemanticsProperties`, which collided with
  Flutter's and failed the consumer's build with `ambiguous_import`. The class
  and its unused `AccessibilityUtils` wrapper are gone — see *Removed*.
- **Top snackbars leaked a timer past the widget tree.** The auto-dismiss timer
  and overlay entry were `static`, so they outlived disposal and later fired
  against a disposed `AnimationController` and `ScaffoldMessenger`. The timer
  now belongs to the toast's `State` and dies with it.
- **`SnackbarQueue` could wedge permanently.** `clear()` left `_isShowing`
  set, so every later `enqueue()` was silently swallowed. A stale `closed`
  callback could also clobber the state of the snackbar currently showing;
  callbacks are now generation-guarded.
- **`hideLikeCircle` was accepted by `SavePointsSnackbar.show` and ignored.**
  It is now forwarded to the top-position toast (the only position that can
  honour it — bottom snackbars are laid out by `ScaffoldMessenger`).
- **Circular-reveal animations were hard-coded LTR.** Three clippers called
  `alignment.resolve(TextDirection.ltr)`, so a directional alignment revealed
  from the wrong edge in RTL. They now resolve against `Directionality.of`.
- **Bottom snackbars sat too high.** The package added 80dp of "FAB space" on
  screens taller than 700dp — a guess, and a double-count: `Scaffold` already
  lifts a floating `SnackBar` clear of the FAB (measured: 72dp) and of the
  bottom safe area. Screens with a FAB were pushed too high; screens without
  one got a dead gap. The guess is gone.
- **Snackbars were invisible to screen readers.** Content now sits in a
  `Semantics` live region so TalkBack and VoiceOver announce it on arrival —
  with `explicitChildNodes`, so the close button stays reachable rather than
  being collapsed into the announcement. Every icon-only close affordance
  carries a localized label from `MaterialLocalizations`.

### Changed

- **Minimum SDK lowered from `^3.11.5` to `^3.6.0`** (Flutter 3.27+). The old
  floor bought nothing but dot-shorthand syntax (`.circular(12)`,
  `behavior: .floating`) and locked out every user below Dart 3.11. 174 call
  sites were desugared; behaviour is unchanged.
- **`SavePointsSnackbar.show` now returns a truthful controller for
  `SnackbarPosition.top`.** It previously returned a placeholder `SnackBar`
  with a 1 ms duration, so `close()` did nothing and `closed` completed almost
  immediately — which also made `SnackbarQueue` fire every queued item at once.
  The placeholder now lives exactly as long as the toast and is its single
  clock, so `close()` dismisses and `closed` completes at the right moment.
- **Barrier blur is now an explicit, documented default.** Dialogs and bottom
  sheets always blurred their barrier even when `blur` was null, contradicting
  the documented "when null, no blur is applied". Behaviour is unchanged, but
  the default is now named (`defaultBarrierBlurSigma`) and `blur: 0` is the
  documented way to opt out.
- **`SnackbarQueue` dispatch is an exhaustive `switch`** rather than a chain of
  conditionals, so a new `SnackbarType` is a compile error instead of silently
  falling through to "warning".
- **`require_trailing_commas` disabled.** It fights the Dart 3.7+ formatter,
  which removes the very commas the rule then demands back.
- The example app now demonstrates `SavePointsTheme` instead of mutating
  process-wide globals.

### Deprecated

- `SavePointsBottomsheet.defaultDesignStyle` — use
  `SavePointsTheme(data: SavePointsThemeData(designStyle: ...))`. A mutable
  static is process-wide and notifies nothing already on screen.
- `SavePointsConstants` — superseded by the `SpSpacing` / `SpRadius` /
  `SpMotion` design tokens it duplicates one-for-one.
- `KeyboardUtils.dismissKeyboardForDialog` and
  `.dismissKeyboardForBottomSheet` — use `KeyboardUtils.dismissIfFocused`.

### Removed

- **`AccessibilityUtils` and its `SemanticsProperties` class.** Unused
  anywhere in the package, and its name collided with Flutter's own
  `SemanticsProperties`, breaking consumer builds. Real `Semantics` is now
  wired directly into the components instead. If you used it, call
  `Semantics(...)` from `package:flutter/material.dart` directly.

### Added

- **Regression test suite** (`test/regression_test.dart`) pinning every fix
  above: the overlay crash, a burst of toasts, tearing the tree down before
  the deferred insert, popping a route while a toast is up, controller
  truthfulness, `hideLikeCircle`, the blur default, live-region semantics and
  close-button reachability, the placeholder swallowing no taps, RTL reveal,
  FAB margin, and the queue wedge. Suite is 43 tests; `flutter analyze` is
  clean and `pub publish --dry-run` passes.
- pub.dev metadata: `topics`, `platforms` and `screenshots`.

## [1.2.1] - 2026-07-23

### Added

- **`SavePointsTheme` scoped defaults**: A new `InheritedWidget`
  (`SavePointsTheme` + `SavePointsThemeData`) lets you declare component
  defaults once in the widget tree instead of repeating `designStyle:`/`blur:`
  on every call or mutating the global `SnackDiaBottomConfig` singleton.
  Supports `designStyle`, `blur`, `snackbarPosition`, `snackbarDuration`,
  `enableHapticFeedback` and `barrierDismissible`. Resolution order is
  explicit argument → nearest theme → built-in default, so it is fully
  backward compatible and scopes correctly per subtree.
- **Canonical entry point**: New `save_points_snackbar_dialog_bottomsheet.dart`
  library so the import path matches the package name (the path the README has
  always documented). A single import now exposes the entire public API.
- **Design tokens are now public**: The shared token layer (`SpRadius`,
  `SpSpacing`, `SpType`, `SpMotion`, `SpSurface`, `SpPalette`, `SpAccent`,
  `SpIntent`) is exported so consumers can theme against the same source of
  truth the components use.
- **Test suite**: Added unit and widget tests covering the design tokens, the
  snackbar queue, public enums, and the `show()` APIs for dialog, snackbar and
  bottom sheet across all eight design styles.

### Changed

- **Package no longer ships example code in `lib/`**: The demo app and its
  widgets lived under `lib/` (`lib/main.dart`, `lib/example/widgets/`,
  `lib/savepoints_config_example.dart`) and bloated the published package. They
  now live in `example/` where they belong. The actively-maintained demo is now
  the canonical `example/lib/main.dart`, so pub.dev shows the current example.

### Fixed

- Removed a stray `debugPrint` that logged on every `ModernDialog` build.
- Replaced placeholder `yourusername` repository/homepage/issue-tracker URLs in
  `pubspec.yaml` and the README with the real repository.

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

