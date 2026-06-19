import 'package:flutter/material.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/savepoints_snackbar.dart';

/// Predefined snackbar configurations for common use cases
class SnackbarPresets {
  /// Shows a "Copied to clipboard" snackbar
  static void showCopiedToClipboard(BuildContext context) {
    SavePointsSnackbar.showSuccess(
      context,
      title: 'Copied!',
      subtitle: 'Copied to clipboard',
      duration: const Duration(seconds: 2),
    );
  }

  /// Shows a "No internet connection" snackbar
  static void showNoInternet(BuildContext context) {
    SavePointsSnackbar.showError(
      context,
      title: 'No Internet',
      subtitle: 'Please check your connection',
      showProgressIndicator: true,
    );
  }

  /// Shows a "Loading" snackbar
  static void showLoading(BuildContext context, {String? message}) {
    SavePointsSnackbar.show(
      context,
      title: message ?? 'Loading...',
      subtitle: 'Please wait',
      type: SnackbarType.info,
      showProgressIndicator: true,
      duration: const Duration(seconds: 30), // Long duration for loading
    );
  }

  /// Shows a "Saved successfully" snackbar
  static void showSaved(BuildContext context) {
    SavePointsSnackbar.showSuccess(
      context,
      title: 'Saved!',
      subtitle: 'Your changes have been saved',
      showProgressIndicator: true,
    );
  }

  /// Shows a "Deleted successfully" snackbar
  static void showDeleted(BuildContext context) {
    SavePointsSnackbar.showSuccess(
      context,
      title: 'Deleted',
      subtitle: 'Item has been removed',
      showProgressIndicator: true,
    );
  }

  /// Shows a "Updated successfully" snackbar
  static void showUpdated(BuildContext context) {
    SavePointsSnackbar.showSuccess(
      context,
      title: 'Updated!',
      subtitle: 'Changes have been applied',
      showProgressIndicator: true,
    );
  }

  /// Shows a "Coming soon" snackbar
  static void showComingSoon(BuildContext context) {
    SavePointsSnackbar.show(
      context,
      title: 'Coming Soon',
      subtitle: 'This feature is under development',
      type: SnackbarType.info,
    );
  }

  /// Shows a "Permission denied" snackbar
  static void showPermissionDenied(BuildContext context) {
    SavePointsSnackbar.showError(
      context,
      title: 'Permission Denied',
      subtitle: 'Please grant the required permission',
    );
  }

  /// Shows a "Try again" snackbar with action
  static void showTryAgain(
    BuildContext context, {
    required VoidCallback onRetry,
  }) {
    SavePointsSnackbar.showError(
      context,
      title: 'Failed',
      subtitle: 'Something went wrong',
      actionLabel: 'Retry',
      onActionPressed: onRetry,
    );
  }
}
