import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_dialog.dart';

/// Predefined dialog configurations for common use cases
class DialogPresets {
  const DialogPresets();

  /// Shows a delete confirmation dialog
  ///
  /// Returns `true` if user confirmed deletion, `false` if cancelled
  static Future<bool?> showDeleteConfirmation(
    BuildContext context, {
    String? itemName,
  }) {
    final title = 'Delete ${itemName ?? 'Item'}?';
    final message = itemName != null
        ? 'Are you sure you want to delete "$itemName"? This action cannot be undone.'
        : 'Are you sure you want to delete this item? This action cannot be undone.';

    /// Show the dialog
    return SavePointsDialog.show(
      context,
      title: title,
      message: message,
      icon: Icons.delete_rounded,
      iconColor: Colors.red,
      confirmText: 'Delete',
      cancelText: 'Cancel',
      showCancelButton: true,
      confirmButtonColor: Colors.red,
    );
  }

  /// Shows a logout confirmation dialog
  ///
  /// Returns `true` if user confirmed logout, `false` if cancelled
  static Future<bool?> showLogoutConfirmation(BuildContext context) {
    return SavePointsDialog.show(
      context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      icon: Icons.logout_rounded,
      iconColor: Colors.orange,
      confirmText: 'Logout',
      cancelText: 'Cancel',
      showCancelButton: true,
    );
  }

  /// Shows a discard changes confirmation dialog
  ///
  /// Returns `true` if user confirmed discarding, `false` if cancelled
  static Future<bool?> showDiscardChangesConfirmation(BuildContext context) {
    const title = 'Discard Changes?';
    const message =
        'You have unsaved changes. Are you sure you want to discard them?';
    return SavePointsDialog.show(
      context,
      title: title,
      message: message,
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.orange,
      confirmText: 'Discard',
      cancelText: 'Keep Editing',
      showCancelButton: true,
    );
  }

  /// Shows a "Clear all" confirmation dialog
  ///
  /// Returns `true` if user confirmed clearing, `false` if cancelled
  static Future<bool?> showClearAllConfirmation(
    BuildContext context, {
    String? itemType,
  }) {
    final title = 'Clear All ${itemType ?? 'Items'}?';
    final message =
        'Are you sure you want to clear all ${itemType?.toLowerCase() ?? 'items'}? This action cannot be undone.';
    return SavePointsDialog.show(
      context,
      title: title,
      message: message,
      icon: Icons.clear_all_rounded,
      iconColor: Colors.orange,
      confirmText: 'Clear All',
      cancelText: 'Cancel',
      showCancelButton: true,
    );
  }

  /// Shows a "Are you sure?" confirmation dialog
  ///
  /// Returns `true` if user confirmed, `false` if cancelled
  static Future<bool?> showAreYouSure(
    BuildContext context, {
    required String message,
    String? title,
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) {
    return SavePointsDialog.show(
      context,
      title: title ?? 'Are you sure?',
      message: message,
      icon: Icons.help_outline_rounded,
      iconColor: Colors.blue,
      confirmText: confirmText,
      cancelText: cancelText,
      showCancelButton: true,
    );
  }

  /// Shows a "Feature not available" dialog
  static Future<bool?> showFeatureNotAvailable(BuildContext context) {
    const title = 'Feature Not Available';
    const message =
        'This feature is currently under development and will be available soon.';
    return SavePointsDialog.show(
      context,
      title: title,
      message: message,
      icon: Icons.construction_rounded,
      iconColor: Colors.orange,
      confirmText: 'OK',
    );
  }

  /// Shows a "Update available" dialog
  ///
  /// Returns `true` if user wants to update, `false` if cancelled
  static Future<bool?> showUpdateAvailable(
    BuildContext context, {
    String? version,
  }) {
    const title = 'Update Available';
    final message = version != null
        ? 'A new version ($version) is available. Would you like to update now?'
        : 'A new version is available. Would you like to update now?';
    return SavePointsDialog.show(
      context,
      title: title,
      message: message,
      icon: Icons.system_update_rounded,
      iconColor: Colors.green,
      confirmText: 'Update',
      cancelText: 'Later',
      showCancelButton: true,
    );
  }
}
