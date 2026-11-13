import 'package:flutter/material.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/dailogs/dialog_content.dart';
import 'package:shakti_hormann/widgets/dailogs/error_content.dart';
import 'package:shakti_hormann/widgets/dailogs/success_content.dart';
import 'package:shakti_hormann/widgets/form_submit_loading_overlay.dart';

enum DialogType { normal, error, confirmRetry }

class AppDialog {
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required String content,
    required VoidCallback onTapOkay,
    DialogType type = DialogType.normal,
    String buttonText = 'Okay',
    bool barrierDismissible = true,
    IconData? icon,
    Color? iconBackground,
    Color? iconColor,
    IconData? confirmIcon,
    Color? confirmColor,
  }) async {
    await FormLoadingOverlay.dismissBeforeDialog();
    if (!context.mounted) return null;
    return showGeneralDialog<T?>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dialog',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      useRootNavigator: true,
      transitionDuration: const Duration(milliseconds: 220),
      transitionBuilder: _fadeScale,
      pageBuilder: (_, __, ___) => DialogWidget(
        title: title,
        content: content,
        buttonText: buttonText,
        onTapDismiss: onTapOkay,
        dialogType: type,
        icon: icon,
        iconBackground: iconBackground,
        iconColor: iconColor,
        confirmIcon: confirmIcon,
        confirmColor: confirmColor,
        showClose: barrierDismissible,
      ),
    );
  }

  static Future<T?> showErrorDialog<T>(
    BuildContext context, {
    String? title,
    required String content,
    required VoidCallback onTapDismiss,
    bool barrierDismissible = true,
    String buttonText = 'OK',
  }) async {
    await FormLoadingOverlay.dismissBeforeDialog();
    if (!context.mounted) return null;
    return showGeneralDialog<T?>(
      context: context,
      barrierLabel: 'ErrorDialog',
      useRootNavigator: true,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 220),
      transitionBuilder: _fadeScale,
      pageBuilder: (_, __, ___) => ErrorContent(
        title: title,
        content: content,
        buttonText: buttonText,
        onTapDismiss: onTapDismiss,
      ),
    );
  }

  static Future<T?> showSuccessDialog<T>(
    BuildContext context, {
    String? title,
    required String content,
    required VoidCallback onTapDismiss,
    String buttonText = 'Thank you',
  }) async {
    await FormLoadingOverlay.dismissBeforeDialog();
    if (!context.mounted) return null;
    return showGeneralDialog<T>(
      context: context,
      barrierLabel: 'SuccessDialog',
      useRootNavigator: true,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 220),
      transitionBuilder: _fadeScale,
      pageBuilder: (_, __, ___) => SuccessContent(
        title: title,
        content: content,
        buttonText: buttonText,
        onTapDismiss: onTapDismiss,
      ),
    );
  }

  static Future<T?> askForConfirmation<T>(
    BuildContext context, {
    String? title,
    required String content,
    required VoidCallback onTapDismiss,
    String buttonText = 'Cancel',
    bool barrierDismissible = true,
    String confirmBtnText = 'Okay',
    required VoidCallback onTapConfirm,
    IconData? icon,
    Color? iconBackground,
    Color? iconColor,
    IconData? confirmIcon,
    Color? confirmColor,
    Widget? body,
  }) async {
    await FormLoadingOverlay.dismissBeforeDialog();
    if (!context.mounted) return null;
    return showGeneralDialog<T>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'ConfirmationDialog',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 220),
      transitionBuilder: _fadeScale,
      pageBuilder: (_, __, ___) => DialogWidget(
        title: title,
        content: content,
        body: body,
        buttonText: buttonText,
        onTapDismiss: onTapDismiss,
        dialogType: DialogType.confirmRetry,
        confirmBtnText: confirmBtnText,
        onTapConfirm: onTapConfirm,
        icon: icon,
        iconBackground: iconBackground,
        iconColor: iconColor,
        confirmIcon: confirmIcon,
        confirmColor: confirmColor,
      ),
    );
  }

  /// Print Stickers confirm — matches the reference Hormann print popup.
  static Future<bool?> confirmPrintStickers(
    BuildContext context, {
    required int stickerCount,
    required String salesOrderNo,
  }) {
    final countLabel = stickerCount.toString().padLeft(2, '0');

    return askForConfirmation<bool>(
      context,
      title: 'Print Stickers?',
      content: '',
      buttonText: 'Cancel',
      confirmBtnText: 'Print',
      icon: Icons.print_rounded,
      iconBackground: const Color(0xFFE8F0FE),
      iconColor: AppColors.darkBlue,
      confirmIcon: Icons.print_rounded,
      confirmColor: AppColors.darkBlue,
      body: Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: 'Do you want to print '),
            TextSpan(
              text: countLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.darkBlue,
              ),
            ),
            const TextSpan(text: ' stickers for '),
            TextSpan(
              text: salesOrderNo,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.darkBlue,
              ),
            ),
            const TextSpan(text: '?'),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      onTapDismiss: () {
        Navigator.of(context).pop(false);
      },
      onTapConfirm: () {
        Navigator.of(context).pop(true);
      },
    );
  }

  /// Freeze quantity confirm used by Frame / Shutter packing.
  static Future<bool?> confirmFreezeQuantity(BuildContext context) {
    return askForConfirmation<bool>(
      context,
      title: 'Freeze Quantity?',
      content:
          'Once frozen you will not be able to change the inputs. '
          'The sticker will be printed automatically.',
      buttonText: 'Cancel',
      confirmBtnText: 'Freeze',
      icon: Icons.lock_outline_rounded,
      iconBackground: const Color(0xFFFEE2E2),
      iconColor: const Color(0xFFE11D48),
      confirmIcon: Icons.lock_rounded,
      confirmColor: AppColors.darkBlue,
      onTapDismiss: () {
        Navigator.of(context).pop(false);
      },
      onTapConfirm: () {
        Navigator.of(context).pop(true);
      },
    );
  }

  /// Generic yes/no confirm that returns a bool (Cancel → false, Confirm → true).
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String content,
    String cancelText = 'Cancel',
    String confirmText = 'Confirm',
    IconData icon = Icons.help_outline_rounded,
    Color iconBackground = const Color(0xFFE8F0FE),
    Color iconColor = AppColors.darkBlue,
    IconData? confirmIcon,
    Color confirmColor = AppColors.darkBlue,
    Widget? body,
  }) {
    return askForConfirmation<bool>(
      context,
      title: title,
      content: content,
      body: body,
      buttonText: cancelText,
      confirmBtnText: confirmText,
      icon: icon,
      iconBackground: iconBackground,
      iconColor: iconColor,
      confirmIcon: confirmIcon,
      confirmColor: confirmColor,
      onTapDismiss: () => Navigator.of(context).pop(false),
      onTapConfirm: () => Navigator.of(context).pop(true),
    );
  }

  static Widget _fadeScale(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.94, end: 1).animate(curved),
        child: child,
      ),
    );
  }
}
