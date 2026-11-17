import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shakti_hormann/core/logger/app_logger.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/dailogs/app_popup_card.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:terminate_restart/terminate_restart.dart';

/// Checks for Shorebird patches while the app is open.
///
/// Default Shorebird auto-update only runs once per process start. This listener
/// also checks on resume and on a timer, so a patch published while the user is
/// already in the app can still download and show the restart popup.
class ShorebirdUpdateListener extends StatefulWidget {
  const ShorebirdUpdateListener({super.key, required this.child});

  final Widget child;

  @override
  State<ShorebirdUpdateListener> createState() =>
      _ShorebirdUpdateListenerState();
}

class _ShorebirdUpdateListenerState extends State<ShorebirdUpdateListener>
    with WidgetsBindingObserver {
  static const _prefsKey = 'shorebird_last_restarted_for_patch';
  static const _checkInterval = Duration(minutes: 5);

  final _updater = ShorebirdUpdater();
  Timer? _timer;
  bool _checking = false;
  bool _dialogVisible = false;
  int? _laterForPatch;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_checkForShorebirdUpdate());
    });
    _timer = Timer.periodic(_checkInterval, (_) {
      unawaited(_checkForShorebirdUpdate());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_checkForShorebirdUpdate());
    }
  }

  Future<void> _checkForShorebirdUpdate() async {
    if (_checking || !mounted) return;
    if (!_updater.isAvailable) return;

    _checking = true;
    try {
      var status = await _updater.checkForUpdate();

      if (status == UpdateStatus.outdated) {
        try {
          await _updater.update();
        } on UpdateException catch (e) {
          $logger.info(
            '[Shorebird] update failed: ${e.message} (${e.reason})',
          );
          return;
        }
        status = await _updater.checkForUpdate();
      }

      if (status != UpdateStatus.restartRequired || !mounted) return;

      final current = (await _updater.readCurrentPatch())?.number ?? 0;
      final next = (await _updater.readNextPatch())?.number ?? 0;
      if (next == 0 || next == current) return;

      final prefs = await SharedPreferences.getInstance();
      final lastRestartedFor = prefs.getInt(_prefsKey) ?? 0;
      if (next == lastRestartedFor) return;
      if (_laterForPatch == next) return;

      await _showRestartDialog(nextPatch: next);
    } catch (e, st) {
      $logger.error('[Shorebird] check failed', e, st);
    } finally {
      _checking = false;
    }
  }

  Future<void> _showRestartDialog({required int nextPatch}) async {
    if (_dialogVisible || !mounted) return;
    _dialogVisible = true;

    try {
      await showDialog<void>(
        context: context,
        useRootNavigator: true,
        barrierDismissible: false,
        builder: (dialogContext) {
          return PopScope(
            canPop: false,
            child: AppPopupCard(
              title: 'Update Ready',
              icon: Icons.system_update_alt_rounded,
              iconBackground: const Color(0xFFE8F0FE),
              iconColor: AppColors.darkBlue,
              showClose: false,
              body: const Text(
                'A new update is ready. Restart the app to apply it.',
                textAlign: TextAlign.center,
              ),
              cancelText: 'Later',
              confirmText: 'Restart now',
              confirmIcon: Icons.refresh_rounded,
              confirmColor: AppColors.darkBlue,
              cancelIsDestructive: false,
              onCancel: () {
                _laterForPatch = nextPatch;
                Navigator.of(dialogContext).pop();
              },
              onConfirm: () async {
                Navigator.of(dialogContext).pop();
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt(_prefsKey, nextPatch);
                await TerminateRestart.instance.restartApp(
                  options: const TerminateRestartOptions(terminate: true),
                );
              },
            ),
          );
        },
      );
    } finally {
      _dialogVisible = false;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
