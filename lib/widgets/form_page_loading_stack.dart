import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

/// Binds a busy flag to the shared centered form loading overlay.
class FormBusyOverlayBinder extends StatefulWidget {
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
  State<FormBusyOverlayBinder> createState() => _FormBusyOverlayBinderState();
}

class _FormBusyOverlayBinderState extends State<FormBusyOverlayBinder> {
  bool _overlayShownByThis = false;

  @override
  void initState() {
    super.initState();
    _scheduleSyncOverlay();
  }

  @override
  void didUpdateWidget(covariant FormBusyOverlayBinder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isBusy && !widget.isBusy && _overlayShownByThis) {
      FormLoadingOverlay.hide();
      _overlayShownByThis = false;
      return;
    }
    if (oldWidget.isBusy != widget.isBusy ||
        oldWidget.message != widget.message ||
        oldWidget.statusLabel != widget.statusLabel) {
      _scheduleSyncOverlay();
    }
  }

  void _scheduleSyncOverlay() {
    SchedulerBinding.instance.addPostFrameCallback((_) => _syncOverlay());
  }

  void _syncOverlay() {
    if (!mounted) return;

    if (widget.isBusy) {
      if (_overlayShownByThis) return;
      FormLoadingOverlay.show(
        context,
        message: widget.message,
        statusLabel: widget.statusLabel ?? 'Processing...',
      );
      _overlayShownByThis = true;
      return;
    }

    if (_overlayShownByThis) {
      FormLoadingOverlay.hide();
      _overlayShownByThis = false;
    }
  }

  @override
  void dispose() {
    if (_overlayShownByThis) {
      FormLoadingOverlay.forceHide();
      _overlayShownByThis = false;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
