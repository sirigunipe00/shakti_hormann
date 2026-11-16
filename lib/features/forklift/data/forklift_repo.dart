import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/forklift/model/forklift_models.dart';

abstract class ForkliftRepo {
  AsyncValueOf<ForkliftHomeSummary> getHomeSummary();

  AsyncValueOf<List<ForkliftSession>> fetchOperatorLogs({
    String? search,
    String? status,
    int page = 1,
    int pageSize = 50,
  });

  AsyncValueOf<ForkliftLogDetailResult> getOperatorLogDetail(String logName);

  AsyncValueOf<ForkliftSession?> getMySession();

  AsyncValueOf<ForkliftStatusListResult> getStatusList({
    String? search,
    String? status,
    String? plantName,
  });

  AsyncValueOf<ForkliftDetailResult> getForkliftDetail(String forklift);

  AsyncValueOf<ForkliftScanResult> scanForklift({
    required String qrText,
    String? deviceId,
  });

  AsyncValueOf<ForkliftLoginResult> markLogin({
    required String qrText,
    required String idempotencyKey,
    String? deviceId,
    String? appVersion,
  });

  /// Logout always requires a scanned forklift QR (`qr_text`).
  /// "No Scan" / logout-without-scan is blocked by the API (`SCAN_REQUIRED`).
  AsyncValueOf<ForkliftLogoutResult> markLogout({
    required String logName,
    required String idempotencyKey,
    required String qrText,
  });
}
