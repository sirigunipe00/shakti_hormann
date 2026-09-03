import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shakti_hormann/widgets/door_loading_loop.dart';

/// Full-screen door graphic overlay — same visual as list-screen loading.
///
/// When [overForm] is true, the form stays visible underneath a dimmed
/// layer with a centered door graphic (form-page style, not list style).
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
        child: Material(
          color: Colors.black.withValues(alpha: 0.35),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 28),
                elevation: 10,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                  child: DoorLoadingLoop(
                    width: _overFormDoorWidth,
                    fixedStatusLabel: statusLabel ?? message,
                    onFirstCycleComplete: onFirstCycleComplete,
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
          onFirstCycleComplete: onFirstCycleComplete,
        ),
      ),
    );
  }
}

/// Root overlay for Create / Save / Submit.
///
/// Keeps the full door graphic visible until the API has finished **and**
/// at least one full animation cycle has played, then removes it so
/// success / error dialogs open only after the graphic.
class FormLoadingOverlay {
  FormLoadingOverlay._();

  static OverlayEntry? _entry;
  static OverlayState? _overlayState;
  static int _refCount = 0;
  static String _message = 'Please wait...';
  static String? _statusLabel;
  static bool _updateScheduled = false;

  static bool _cycleComplete = false;
  static Completer<void>? _cycleCompleter;
  static Future<void>? _inFlightDismiss;

  static bool get isShowing => _entry != null;

  static void show(
    BuildContext context, {
    String message = 'Please wait...',
    String? statusLabel,
  }) {
    final wasVisible = _entry != null;
    _refCount++;
    _message = message;
    _statusLabel = statusLabel;
    _overlayState ??= Overlay.maybeOf(context, rootOverlay: true);

    if (!wasVisible) {
      _cycleComplete = false;
      _cycleCompleter = Completer<void>();
      _inFlightDismiss = null;
    }

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
            onFirstCycleComplete: notifyCycleComplete,
          ),
    );
    _overlayState!.insert(_entry!);
  }

  /// Door loop finished one full cycle.
  static void notifyCycleComplete() {
    if (_cycleComplete) return;
    _cycleComplete = true;
    final c = _cycleCompleter;
    if (c != null && !c.isCompleted) {
      c.complete();
    }
  }

  /// API finished — dismiss after the full graphic cycle has been shown.
  static void hide() {
    if (_refCount <= 0) return;
    _refCount--;
    if (_refCount > 0) return;
    unawaited(_dismissAfterFullGraphic());
  }

  /// Tear down immediately (e.g. leaving the screen).
  static void forceHide() {
    _refCount = 0;
    _inFlightDismiss = null;
    _teardown();
  }

  /// Await full door graphic, remove overlay, then open dialogs.
  static Future<void> dismissBeforeDialog() async {
    _refCount = 0;
    await _dismissAfterFullGraphic();
    await SchedulerBinding.instance.endOfFrame;
  }

  static Future<void> _dismissAfterFullGraphic() {
    if (_entry == null) {
      return Future<void>.value();
    }
    return _inFlightDismiss ??= _runDismiss();
  }

  static Future<void> _runDismiss() async {
    if (!_cycleComplete) {
      try {
        await (_cycleCompleter?.future ?? Future<void>.value()).timeout(
          const Duration(milliseconds: 2200),
        );
      } catch (_) {
        // Never block dialogs forever if the cycle callback is missed.
      }
    }
    _teardown();
    _inFlightDismiss = null;
  }

  static void _scheduleApply() {
    if (_updateScheduled) return;
    _updateScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _updateScheduled = false;
      if (_refCount <= 0) {
        unawaited(_dismissAfterFullGraphic());
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
