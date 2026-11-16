import 'dart:math';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/utils/device_info_mixin.dart';
import 'package:shakti_hormann/features/forklift/data/forklift_repo.dart';
import 'package:shakti_hormann/features/forklift/model/forklift_models.dart';
import 'package:shakti_hormann/features/forklift/presentation/ui/create/forklift_operator_detail.dart';
import 'package:shakti_hormann/features/forklift/presentation/ui/create/new_forklift_operator.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class ForkliftScanOutcome {
  const ForkliftScanOutcome({
    this.loggedIn = false,
    this.loggedOut = false,
    this.session,
  });

  final bool loggedIn;
  final bool loggedOut;
  final ForkliftSession? session;
}

/// Shared QR scan → start/stop branching used by + New and detail Logout.
class ForkliftScanFlow {
  static String newIdempotencyKey() {
    final r = Random();
    String hex(int n) =>
        List.generate(n, (_) => r.nextInt(16).toRadixString(16)).join();
    return '${hex(8)}-${hex(4)}-4${hex(3)}-a${hex(3)}-${hex(12)}';
  }

  static Future<ForkliftScanOutcome?> open(
    BuildContext context, {
    String? preferStopForLog,
  }) async {
    final qr = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const _ForkliftQrCapturePage()),
    );
    if (!context.mounted) return null;
    if (qr == null || qr.trim().isEmpty || qr == '-1') return null;

    return handleQr(context, qr.trim(), preferStopForLog: preferStopForLog);
  }

  static Future<ForkliftScanOutcome?> handleQr(
    BuildContext context,
    String qrText, {
    String? preferStopForLog,
  }) async {
    final helper = _ScanDeviceHelper();
    final deviceId = await helper.deviceId();
    final repo = $sl.get<ForkliftRepo>();

    final scan = await repo.scanForklift(qrText: qrText, deviceId: deviceId);
    if (!context.mounted) return null;

    return scan.fold(
      (l) async {
        await AppDialog.showErrorDialog(
          context,
          title: 'Cannot use forklift',
          content: l.error,
          onTapDismiss: context.exit,
        );
        return null;
      },
      (result) async {
        // Active on another forklift — no Auto Switch / Continue login.
        if (result.isMustLogout) {
          return _openActiveSessionForLogout(
            context,
            message: result.popupMessage ??
                'You are still logged in on another forklift. Open that session and scan to log out first.',
            session: result.activeSessionForLogout,
          );
        }

        if (result.isStart) {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(
                'Log in to ${result.forklift?.displayNo ?? 'forklift'}?',
              ),
              content: Text(
                result.popupMessage ??
                    'Forklift is free. Confirm to mark login.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Continue'),
                ),
              ],
            ),
          );
          if (confirmed != true || !context.mounted) return null;

          final formResult = await Navigator.push<Object?>(
            context,
            MaterialPageRoute(
              builder: (_) => NewForkliftOperatorPage(
                qrText: qrText,
                forklift: result.forklift ?? const ForkliftInfo(),
                operator: result.operator,
              ),
            ),
          );
          if (!context.mounted) return null;
          if (formResult is ForkliftSession) {
            return ForkliftScanOutcome(loggedIn: true, session: formResult);
          }
          // Change Forklift → scan again.
          if (formResult == true) {
            return open(context);
          }
          return null;
        }

        if (result.isStop) {
          final logName = result.log?.name ?? preferStopForLog;
          final startedRaw = result.log?.loginDatetime ??
              result.since ??
              ((result.log?.loginDate != null &&
                      result.log?.loginTime != null)
                  ? '${result.log!.loginDate} ${result.log!.loginTime}'
                  : result.log?.loginTime) ??
              '';
          final started = DFU.ddMMyyyyAmPmFromStr(startedRaw);
          final used = result.log?.duration ??
              result.forklift?.runningDuration ??
              '';
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(
                'Logout from ${result.forklift?.displayNo ?? 'forklift'}?',
              ),
              content: Text(
                'You started at ${started.isEmpty ? '—' : started}. Used so far: ${used.isEmpty ? '—' : used}.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
          if (confirmed != true || !context.mounted) return null;
          if (logName == null || logName.isEmpty) {
            await AppDialog.showErrorDialog(
              context,
              title: 'Error',
              content: 'Missing session id for logout.',
              onTapDismiss: context.exit,
            );
            return null;
          }
          if (qrText.trim().isEmpty) {
            await AppDialog.showErrorDialog(
              context,
              title: 'Scan required',
              content:
                  'Logout without scan is not allowed. Scan the QR sticker on the forklift to log out.',
              onTapDismiss: context.exit,
            );
            return null;
          }

          final logout = await repo.markLogout(
            logName: logName,
            idempotencyKey: newIdempotencyKey(),
            qrText: qrText,
          );
          if (!context.mounted) return null;
          return logout.fold(
            (l) async {
              final msg = l.error;
              final scanRequired = msg.toLowerCase().contains('scan') ||
                  msg.toUpperCase().contains('SCAN_REQUIRED');
              await AppDialog.showErrorDialog(
                context,
                title: scanRequired ? 'Scan required' : 'Logout failed',
                content: msg,
                onTapDismiss: context.exit,
              );
              return null;
            },
            (r) async {
              await AppDialog.showSuccessDialog(
                context,
                title: 'Logout Marked',
                content: r.popupMessage ??
                    'Logged out from ${r.forklift?.displayNo ?? ''}. Used ${r.log?.duration ?? ''}.',
                onTapDismiss: context.exit,
              );
              return ForkliftScanOutcome(
                loggedOut: true,
                session: r.log,
              );
            },
          );
        }

        await AppDialog.showErrorDialog(
          context,
          title: 'Scan result',
          content: result.popupMessage ?? 'Unhandled scan action.',
          onTapDismiss: context.exit,
        );
        return null;
      },
    );
  }

  /// Show API message and open the active session (record_link) for logout.
  static Future<ForkliftScanOutcome?> openActiveSessionForLogout(
    BuildContext context, {
    required String message,
    ForkliftSession? session,
  }) {
    return _openActiveSessionForLogout(
      context,
      message: message,
      session: session,
    );
  }

  static Future<ForkliftScanOutcome?> _openActiveSessionForLogout(
    BuildContext context, {
    required String message,
    ForkliftSession? session,
  }) async {
    final logName = session?.name?.trim() ?? '';
    final open = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout required'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: logName.isEmpty ? null : () => Navigator.pop(ctx, true),
            child: Text(
              logName.isEmpty ? 'No session link' : 'Open $logName',
            ),
          ),
        ],
      ),
    );
    if (open != true || !context.mounted) return null;
    if (logName.isEmpty) {
      await AppDialog.showErrorDialog(
        context,
        title: 'Missing session',
        content: 'No active session link was returned. Try again or open your session from the list.',
        onTapDismiss: context.exit,
      );
      return null;
    }

    await Navigator.push<Object?>(
      context,
      MaterialPageRoute(
        builder: (_) => ForkliftOperatorDetailPage(
          session: session ?? ForkliftSession(name: logName),
        ),
      ),
    );
    return null;
  }
}

class _ScanDeviceHelper with DeviceInfoMixin {
  Future<String> deviceId() async {
    try {
      final info = await getDeviceInfo();
      return info.deviceUniqueId;
    } catch (_) {
      return 'flutter-device';
    }
  }

  Future<String> appVersion() async {
    try {
      final p = await PackageInfo.fromPlatform();
      return p.version;
    } catch (_) {
      return '1.0.0';
    }
  }
}

/// Camera scan with a manual QR fallback for emulators / no-camera devices.
class _ForkliftQrCapturePage extends StatelessWidget {
  const _ForkliftQrCapturePage();

  Future<void> _scanCamera(BuildContext context) async {
    final qr = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const SimpleBarcodeScannerPage(
          scanType: ScanType.qr,
          appBarTitle: 'Scan Forklift QR',
          isShowFlashIcon: true,
        ),
      ),
    );
    if (!context.mounted) return;
    if (qr == null || qr.trim().isEmpty || qr == '-1') return;
    Navigator.pop(context, qr.trim());
  }

  Future<void> _enterManual(BuildContext context) async {
    final controller = TextEditingController();
    final qr = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter Forklift QR'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            hintText: 'Paste or type QR / Forklift ID',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    if (qr == null || qr.isEmpty) return;
    Navigator.pop(context, qr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        foregroundColor: Colors.white,
        title: const Text(
          'Forklift QR',
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFF2A93B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8ECF4)),
              ),
              child: const Column(
                children: [
                  Icon(Icons.qr_code_2, size: 64, color: Color(0xFF2F6FE4)),
                  SizedBox(height: 12),
                  Text(
                    'Scan the forklift QR to mark login or logout.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14.5,
                      color: Color(0xFF3A4256),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _scanCamera(context),
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text(
                  'Scan with Camera',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Urbanist',
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.darkBlue,
                  side: const BorderSide(color: Color(0xFFC9D3E6)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _enterManual(context),
                icon: const Icon(Icons.keyboard_alt_outlined),
                label: const Text(
                  'Enter QR Manually',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Urbanist',
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              'Use manual entry on emulators or devices without a working camera.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 12.5,
                color: Colors.black.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
