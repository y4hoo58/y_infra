import 'package:flutter/material.dart';

import '../../core/theme/y_infra_colors.dart';

/// Mixin providing convenience methods to show success, error, warning, and default snack bars.
mixin SnackBarY {
  void displaySuccessSnack({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: context.yColors.successColor,
      ),
    );
  }

  void displayErrorSnack({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void displayWarningSnack({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: context.yColors.warningColor,
      ),
    );
  }

  void displaySnack({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
