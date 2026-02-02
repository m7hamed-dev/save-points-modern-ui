# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

