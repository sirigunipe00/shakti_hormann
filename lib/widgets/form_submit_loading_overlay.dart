import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shakti_hormann/widgets/door_loading_loop.dart';

/// Form loading overlay.
///
/// When [overForm] is true (default for form actions), the form stays visible
/// underneath a frosted glass layer with a complete door graphic.
class FormSubmitLoadingOverlay extends StatelessWidget {
  const FormSubmitLoadingOverlay({
    super.key,
    this.message = 'Please wait...',
    this.statusLabel,
    this.onFirstCycleComplete,
    this.overForm = false,
  });

  final String message;
  final String? statusLabel;
  final VoidCallback? onFirstCycleComplete;
  final bool overForm;

  static const _overFormDoorWidth = 180.0;

  @override
  Widget build(BuildContext context) {
    if (overForm) {
      return AbsorbPointer(
        absorbing: true,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: ColoredBox(
              color: Colors.black.withValues(alpha: 0.22),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white.withValues(alpha: 0.62),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.55),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                            child: DoorLoadingLoop(
                              width: _overFormDoorWidth,
                              fixedStatusLabel: statusLabel ?? message,
                              holdCompleteAssembly: true,
                              onFirstCycleComplete: onFirstCycleComplete,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return AbsorbPointer(
      absorbing: true,
      child: Material(
        color: Colors.white,
        child: DoorLoadingLoop(
          expand: true,
          fixedStatusLabel: statusLabel ?? message,
          holdCompleteAssembly: true,
          onFirstCycleComplete: onFirstCycleComplete,
        ),
      ),
    );
  }
}

/// Legacy root overlay helper. Prefer [FormPageLoadingStack] for form actions.
/// If used, inserts a form-style (overForm) overlay and dismisses immediately.
class FormLoadingOverlay {
  FormLoadingOverlay._();

  static OverlayEntry? _entry;
  static OverlayState? _overlayState;
  static int _refCount = 0;
  static String _message = 'Please wait...';
  static String? _statusLabel;
  static bool _updateScheduled = false;

  static bool get isShowing => _entry != null;

  static void show(
    BuildContext context, {
    String message = 'Please wait...',
    String? statusLabel,
  }) {
    _refCount++;
    _message = message;
    _statusLabel = statusLabel;
    _overlayState ??= Overlay.maybeOf(context, rootOverlay: true);

    if (_overlayState == null) {
      _scheduleApply();
      return;
    }

    if (_entry != null) {
      _entry!.markNeedsBuild();
      return;
    }

    _insertEntry();
  }

  static void _insertEntry() {
    _entry = OverlayEntry(
      builder:
          (_) => FormSubmitLoadingOverlay(
            message: _message,
            statusLabel: _statusLabel,
            overForm: true,
          ),
    );
    _overlayState!.insert(_entry!);
  }

  static void notifyCycleComplete() {}

  /// API finished — remove overlay immediately.
  static void hide() {
    if (_refCount <= 0) return;
    _refCount--;
    if (_refCount > 0) return;
    _teardown();
  }

  /// Tear down immediately (e.g. leaving the screen).
  static void forceHide() {
    _refCount = 0;
    _teardown();
  }

  /// Remove any root overlay before opening dialogs.
  static Future<void> dismissBeforeDialog() async {
    forceHide();
    await SchedulerBinding.instance.endOfFrame;
  }

  static void _scheduleApply() {
    if (_updateScheduled) return;
    _updateScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _updateScheduled = false;
      if (_refCount <= 0) {
        _teardown();
        return;
      }
      if (_overlayState == null) return;
      if (_entry != null) {
        _entry!.markNeedsBuild();
        return;
      }
      _insertEntry();
    });
  }

  static void _teardown() {
    _entry?.remove();
    _entry = null;
    _overlayState = null;
  }
}

String formLoadingMessageForLabel(String label, {String? loadingText}) {
  if (loadingText != null && loadingText.trim().isNotEmpty) {
    return loadingText.trim();
  }

  final normalized = label.toLowerCase();
  if (normalized.contains('submit')) return 'Submitting document...';
  if (normalized.contains('update')) return 'Updating document...';
  if (normalized.contains('approve') || normalized.contains('accept')) {
    return 'Processing approval...';
  }
  if (normalized.contains('reject')) return 'Processing rejection...';
  if (normalized.contains('save') || normalized.contains('create')) {
    return 'Saving document...';
  }
  return 'Please wait...';
}
