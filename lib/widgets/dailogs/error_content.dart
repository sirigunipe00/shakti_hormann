import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/widgets/dailogs/app_popup_card.dart';

class ErrorContent extends StatelessWidget {
  const ErrorContent({
    super.key,
    this.title,
    required this.content,
    required this.onTapDismiss,
    this.buttonText = 'OK',
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
    final nav = Navigator.of(context, rootNavigator: true);
    if (nav.canPop()) {
      nav.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPopupCard(
      title: title.containsValidValue ? title! : 'Error',
      icon: Icons.error_outline_rounded,
      iconBackground: const Color(0xFFFEE2E2),
      iconColor: const Color(0xFFE11D48),
      onClose: () => _close(context),
      body: Text(content, textAlign: TextAlign.center),
      singleAction: true,
      confirmText: buttonText,
      confirmIcon: Icons.close_rounded,
      confirmColor: const Color(0xFFE11D48),
      onConfirm: () => _close(context),
    );
  }
}
