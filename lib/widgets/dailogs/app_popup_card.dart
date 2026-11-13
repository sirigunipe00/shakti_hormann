import 'package:flutter/material.dart';
import 'package:shakti_hormann/styles/app_color.dart';

/// Shared visual shell for app popups (success / error / confirm / print).
/// Clean flat card — no gradients, light shadow, clear actions.
class AppPopupCard extends StatelessWidget {
  const AppPopupCard({
    super.key,
    required this.title,
    required this.body,
    required this.icon,
    this.iconBackground = const Color(0xFFE8F0FE),
    this.iconColor = AppColors.darkBlue,
    this.showClose = true,
    this.onClose,
    this.cancelText,
    this.onCancel,
    this.confirmText,
    this.onConfirm,
    this.confirmIcon,
    this.confirmColor = AppColors.darkBlue,
    this.cancelIsDestructive = true,
    this.singleAction = false,
  });

  final String title;
  final Widget body;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final bool showClose;
  final VoidCallback? onClose;

  final String? cancelText;
  final VoidCallback? onCancel;
  final String? confirmText;
  final VoidCallback? onConfirm;
  final IconData? confirmIcon;
  final Color confirmColor;
  final bool cancelIsDestructive;

  /// When true, only the primary (confirm) button is shown full-width.
  final bool singleAction;

  static const _ink = Color(0xFF163A6B);
  static const _muted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final cancelLabel = cancelText;
    final confirmLabel = confirmText;

    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 28,
                width: double.infinity,
                child: showClose
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: onClose ??
                              () => Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).maybePop(),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.close_rounded,
                              size: 20,
                              color: _muted,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: iconColor),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                  fontFamily: 'Urbanist',
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: _muted,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Urbanist',
                ),
                textAlign: TextAlign.center,
                child: body,
              ),
              const SizedBox(height: 18),
                      if (singleAction && confirmLabel != null)
                        AppPopupPrimaryButton(
                          label: confirmLabel,
                          icon: confirmIcon,
                          color: confirmColor,
                          onPressed: onConfirm,
                        )
                      else
                        Row(
                          children: [
                            if (cancelLabel != null) ...[
                              Expanded(
                                child: AppPopupCancelButton(
                                  label: cancelLabel,
                                  destructive: cancelIsDestructive,
                                  onPressed: onCancel ??
                                      () => Navigator.of(
                                            context,
                                            rootNavigator: true,
                                          ).maybePop(),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                            if (confirmLabel != null)
                              Expanded(
                                child: AppPopupPrimaryButton(
                                  label: confirmLabel,
                                  icon: confirmIcon,
                                  color: confirmColor,
                                  onPressed: onConfirm,
                                ),
                              ),
                          ],
                        ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Flat white shell for form / content dialogs — same chrome as [AppPopupCard].
class AppFormDialogShell extends StatelessWidget {
  const AppFormDialogShell({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.icon = Icons.edit_outlined,
    this.iconBackground = const Color(0xFFE8F0FE),
    this.iconColor = AppColors.darkBlue,
    this.showClose = true,
    this.onClose,
    this.cancelText = 'Cancel',
    this.onCancel,
    this.confirmText,
    this.onConfirm,
    this.confirmIcon,
    this.confirmColor = AppColors.darkBlue,
    this.cancelIsDestructive = false,
    this.maxWidth = 360,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final bool showClose;
  final VoidCallback? onClose;
  final String? cancelText;
  final VoidCallback? onCancel;
  final String? confirmText;
  final VoidCallback? onConfirm;
  final IconData? confirmIcon;
  final Color confirmColor;
  final bool cancelIsDestructive;
  final double maxWidth;

  static const _ink = Color(0xFF163A6B);
  static const _muted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final keyboard = media.viewInsets.bottom;
    final maxDialogHeight =
        media.size.height - media.padding.vertical - keyboard - 32;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        keyboard > 0 ? 12 : 24,
      ),
      child: Container(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: maxDialogHeight.clamp(280.0, media.size.height),
          ),
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 22, color: iconColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: _ink,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: _muted,
                              fontFamily: 'Urbanist',
                              height: 1.3,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (showClose)
                    InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onClose ?? () => Navigator.of(context).maybePop(),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: _muted,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Flexible(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: child,
                ),
              ),
              if (cancelText != null || confirmText != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (cancelText != null) ...[
                      Expanded(
                        child: AppPopupCancelButton(
                          label: cancelText!,
                          destructive: cancelIsDestructive,
                          onPressed: onCancel ??
                              () => Navigator.of(context).maybePop(),
                        ),
                      ),
                      if (confirmText != null) const SizedBox(width: 10),
                    ],
                    if (confirmText != null)
                      Expanded(
                        child: AppPopupPrimaryButton(
                          label: confirmText!,
                          icon: confirmIcon,
                          color: confirmColor,
                          onPressed: onConfirm,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
    );
  }
}

/// Soft chip used inside popup body copy (e.g. SO number, counts).
class AppPopupChip extends StatelessWidget {
  const AppPopupChip({
    super.key,
    required this.label,
    this.background = const Color(0xFFE8F0FE),
    this.foreground = AppColors.darkBlue,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontWeight: FontWeight.w700,
          fontSize: 13,
          fontFamily: 'Urbanist',
        ),
      ),
    );
  }
}

class AppPopupCancelButton extends StatelessWidget {
  const AppPopupCancelButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.destructive = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color =
        destructive ? const Color(0xFFDC2626) : const Color(0xFF64748B);
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.55)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            fontFamily: 'Urbanist',
            color: color,
          ),
        ),
      ),
    );
  }
}

class AppPopupPrimaryButton extends StatelessWidget {
  const AppPopupPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.darkBlue,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          disabledBackgroundColor: color.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: Colors.white),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  fontFamily: 'Urbanist',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
