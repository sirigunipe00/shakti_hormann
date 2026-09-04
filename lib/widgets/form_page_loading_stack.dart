import 'package:flutter/material.dart';
import 'package:shakti_hormann/widgets/form_submit_loading_overlay.dart';

/// Form-level loading: keeps [child] visible and shows a small door overlay
/// on top while [isLoading] is true. Lifecycle follows the API flag only.
class FormPageLoadingStack extends StatelessWidget {
  const FormPageLoadingStack({
    super.key,
    required this.isLoading,
    required this.child,
    this.message = 'Please wait...',
    this.statusLabel,
  });

  final bool isLoading;
  final Widget child;
  final String message;
  final String? statusLabel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        if (isLoading)
          FormSubmitLoadingOverlay(
            message: message,
            statusLabel: statusLabel,
            overForm: true,
          ),
      ],
    );
  }
}

/// Binds a busy flag to a form-contained loading overlay (not full-screen).
class FormBusyOverlayBinder extends StatelessWidget {
  const FormBusyOverlayBinder({
    super.key,
    required this.isBusy,
    required this.child,
    this.message = 'Please wait...',
    this.statusLabel,
  });

  final bool isBusy;
  final Widget child;
  final String message;
  final String? statusLabel;

  @override
  Widget build(BuildContext context) {
    return FormPageLoadingStack(
      isLoading: isBusy,
      message: message,
      statusLabel: statusLabel,
      child: child,
    );
  }
}
