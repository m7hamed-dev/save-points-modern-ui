# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

