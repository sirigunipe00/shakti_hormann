import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/dailogs/app_popup_card.dart';

class DialogWidget extends StatelessWidget {
  const DialogWidget({
    super.key,
    required this.content,
    required this.buttonText,
    required this.onTapDismiss,
    required this.dialogType,
    this.title,
    this.onTapConfirm,
    this.confirmBtnText,
    this.body,
    this.icon,
    this.iconBackground,
    this.iconColor,
    this.confirmIcon,
    this.confirmColor,
    this.showClose = true,
  });

  final String? title;
  final String content;
  final Widget? body;
  final String buttonText;
  final VoidCallback onTapDismiss;
  final DialogType dialogType;
  final VoidCallback? onTapConfirm;
  final String? confirmBtnText;
  final IconData? icon;
  final Color? iconBackground;
  final Color? iconColor;
  final IconData? confirmIcon;
  final Color? confirmColor;
  final bool showClose;

  bool get _isConfirm => dialogType == DialogType.confirmRetry;

  @override
  Widget build(BuildContext context) {
    final isConfirm = _isConfirm;

    return AppPopupCard(
      title: title.containsValidValue
          ? title!
          : (isConfirm ? 'Confirm' : 'Notice'),
      icon: icon ??
          (isConfirm
              ? Icons.help_outline_rounded
              : Icons.info_outline_rounded),
      iconBackground: iconBackground ?? const Color(0xFFE8F0FE),
      iconColor: iconColor ?? AppColors.darkBlue,
      showClose: showClose,
      body: body ?? Text(content, textAlign: TextAlign.center),
      singleAction: !isConfirm,
      cancelText: isConfirm ? buttonText : null,
      onCancel: isConfirm
          ? () {
              onTapDismiss();
            }
          : null,
      confirmText: isConfirm ? (confirmBtnText ?? 'Confirm') : buttonText,
      confirmIcon: confirmIcon ??
          (isConfirm ? Icons.check_rounded : Icons.check_circle_outline_rounded),
      confirmColor: confirmColor ?? AppColors.darkBlue,
      onConfirm: () {
        if (isConfirm) {
          (onTapConfirm ?? onTapDismiss)();
        } else {
          // Single-action notice: pop this dialog route directly.
          final nav = Navigator.of(context, rootNavigator: true);
          if (nav.canPop()) nav.pop();
        }
      },
      onClose: () {
        if (isConfirm) {
          onTapDismiss();
        } else {
          final nav = Navigator.of(context, rootNavigator: true);
          if (nav.canPop()) nav.pop();
        }
      },
    );
  }
}
