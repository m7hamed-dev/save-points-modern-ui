import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_dialog.dart';

/// Predefined dialog configurations for common use cases
class DialogPresets {
  /// Shows a delete confirmation dialog
  ///
  /// Returns `true` if user confirmed deletion, `false` if cancelled
  static Future<bool?> showDeleteConfirmation(
    BuildContext context, {
    String? itemName,
  }) {
    return SavePointsDialog.show(
      context,
      title: 'Delete ${itemName ?? 'Item'}?',
      message: itemName != null
          ? 'Are you sure you want to delete "$itemName"? This action cannot be undone.'
          : 'Are you sure you want to delete this item? This action cannot be undone.',
      icon: Icons.delete_outline,
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
      icon: Icons.logout,
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
    return SavePointsDialog.show(
      context,
      title: 'Discard Changes?',
      message: 'You have unsaved changes. Are you sure you want to discard them?',
      icon: Icons.warning_amber,
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
    return SavePointsDialog.show(
      context,
      title: 'Clear All ${itemType ?? 'Items'}?',
      message: 'Are you sure you want to clear all ${itemType?.toLowerCase() ?? 'items'}? This action cannot be undone.',
      icon: Icons.clear_all,
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
      icon: Icons.help_outline,
      iconColor: Colors.blue,
      confirmText: confirmText,
      cancelText: cancelText,
      showCancelButton: true,
    );
  }

  /// Shows a "Feature not available" dialog
  static Future<bool?> showFeatureNotAvailable(BuildContext context) {
    return SavePointsDialog.show(
      context,
      title: 'Feature Not Available',
      message: 'This feature is currently under development and will be available soon.',
      icon: Icons.construction,
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
    return SavePointsDialog.show(
      context,
      title: 'Update Available',
      message: version != null
          ? 'A new version ($version) is available. Would you like to update now?'
          : 'A new version is available. Would you like to update now?',
      icon: Icons.system_update,
      iconColor: Colors.green,
      confirmText: 'Update',
      cancelText: 'Later',
      showCancelButton: true,
    );
  }
}

