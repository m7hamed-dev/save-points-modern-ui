/// SavePoints Modern UI - A Flutter package for modern UI components
///
/// This package provides:
/// - Modern dialogs with glassmorphism
/// - Enhanced snackbars with animations
/// - Customizable bottom sheets
/// - Extensive customization options
library;

// Export bottomsheet components
export 'bottomsheet/bottomsheet.dart';
// Export config
export 'config/config.dart';
export 'content_design_style.dart';
// Export the shared design-token layer (radius, spacing, type, motion,
// palette) so consumers can theme against the same source of truth.
// The shared header band, so a caller can build a matching surface.
export 'design/color_header_band.dart';
export 'design/pulse_scope.dart';
export 'design/save_points_tokens.dart';
// One resolver for every design style; see README, "Building on the
// same styles".
export 'design/sp_style.dart';
// Export dialog components
export 'dialog/dialog.dart';
// Export extensions
export 'extensions/context_extensions.dart';
// Export presets
export 'presets/presets.dart';
export 'savepoints_bottomsheet.dart';
export 'savepoints_config.dart';
// Export the scoped theme provider (declarative, per-subtree defaults).
export 'savepoints_theme.dart';
// Export main classes
export 'savepoints_dialog.dart';
export 'savepoints_snackbar.dart';
// Export shared components
export 'shared/enhanced_icon.dart';
// Export snackbar components
export 'snackbar/snackbar.dart';
// Export snackbar queue
export 'utils/snackbar_queue.dart';
// Export utilities
export 'utils/utils.dart';
