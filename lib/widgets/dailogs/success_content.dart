import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/dailogs/app_popup_card.dart';

class SuccessContent extends StatelessWidget {
  const SuccessContent({
    super.key,
    this.title,
    required this.content,
    required this.onTapDismiss,
    this.buttonText = 'Thank you',
    /// Kept for call-site compatibility; icon is rendered by [AppPopupCard].
    this.imagePath,
  });

  final String? title;
  final String content;
  final String? imagePath;
  final String buttonText;
  /// Kept for call-site compatibility. Dismiss always pops this dialog route;
  /// do not use this for Navigator pops (e.g. `context.exit`).
  final VoidCallback onTapDismiss;

  void _close(BuildContext context) {
    // Always pop the dialog route itself. Call-site `context.exit` uses the
    // page context and can fail to dismiss when root/nested navigators differ.
    final nav = Navigator.of(context, rootNavigator: true);
    if (nav.canPop()) {
      nav.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPopupCard(
      title: title.containsValidValue ? title! : 'Success',
      icon: Icons.check_rounded,
      iconBackground: const Color(0xFFDCFCE7),
      iconColor: AppColors.green,
      onClose: () => _close(context),
      body: Text(content, textAlign: TextAlign.center),
      singleAction: true,
      confirmText: buttonText,
      confirmIcon: Icons.check_circle_outline_rounded,
      confirmColor: AppColors.green,
      onConfirm: () => _close(context),
    );
  }
}
