import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/forklift/data/forklift_repo.dart';
import 'package:shakti_hormann/features/forklift/model/forklift_models.dart';

@LazySingleton(as: ForkliftRepo)
class ForkliftRepoImpl extends BaseApiRepository implements ForkliftRepo {
  const ForkliftRepoImpl(super.client);

  static const _friendlyUnavailable =
      'Forklift service is temporarily unavailable on the server. Please tap Retry.';

  /// UAT has mixed workers (some missing methods / returning 500).
  /// Race a few parallel calls so we hit a healthy worker without long waits.
  Future<Either<Failure, T>> _retry<T>(
    Future<Either<Failure, T>> Function() call, {
    int rounds = 4,
    int parallel = 3,
  }) async {
    Either<Failure, T>? last;
    for (var round = 0; round < rounds; round++) {
      final results = await Future.wait(
        List.generate(parallel, (_) => call()),
      );
      for (final result in results) {
        if (result.isRight()) return result;
        last = result;
      }
      if (round < rounds - 1) {
        await Future<void>.delayed(Duration(milliseconds: 80 + (round * 40)));
      }
    }
    return left(Failure(error: _friendlyError(last)));
  }

  String _friendlyError(Either<Failure, dynamic>? last) {
    final raw = last?.fold((l) => l.error, (_) => '') ?? '';
    final lower = raw.toLowerCase();
    if (lower.contains('has no attribute') ||
        lower.contains('failed to get method') ||
        lower.contains('could not load forklift') ||
        lower.contains('validationerror')) {
      return _friendlyUnavailable;
    }
    if (raw.trim().isEmpty) return _friendlyUnavailable;
    return raw;
  }

  Map<String, dynamic> _dataOf(Map<String, dynamic> json) {
    final message = json['message'];
    if (message is Map<String, dynamic>) {
      final data = message['data'];
      if (data is Map<String, dynamic>) return data;
      return message;
    }
    return json;
  }

  Map<String, String> _stringParams(Map<String, dynamic> body) {
    return body.map((k, v) => MapEntry(k, '$v'));
  }

  @override
  AsyncValueOf<ForkliftHomeSummary> getHomeSummary() {
    return _retry(
      () => executeSafely(() async {
        final config = RequestConfig<ForkliftHomeSummary>(
          url: Urls.getForkliftHomeSummary,
          parser: (json) => ForkliftHomeSummary.fromJson(_dataOf(json)),
          reqParams: const <String, dynamic>{},
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        );
        final response = await post(config);
        return response.process((r) => right(r.data!));
      }),
      rounds: 2,
      parallel: 2,
    );
  }

  @override
  AsyncValueOf<List<ForkliftSession>> fetchOperatorLogs({
    String? search,
    String? status,
    int page = 1,
    int pageSize = 50,
  }) {
    // List should fail fast — avoid 4×3 parallel races that hang the spinner.
    return _retry(
      () => executeSafely(() async {
        final body = <String, dynamic>{
          'page': page,
          'page_size': pageSize,
          if (search != null && search.trim().isNotEmpty)
            'search': search.trim(),
          if (status != null &&
              status.trim().isNotEmpty &&
              status.toLowerCase() != 'all')
            'status': status.trim(),
        };
        final config = RequestConfig<List<ForkliftSession>>(
          url: Urls.getForkliftOperatorLogs,
          parser: (json) =>
              ForkliftLogsResult.fromJson(_dataOf(json)).logs,
          // Frappe method APIs are more reliable with query/form params
          // than a JSON body on the current UAT workers.
          reqParams: _stringParams(body),
        );
        final response = await post(config);
        return response.process((r) => right(r.data!));
      }),
      rounds: 2,
      parallel: 1,
    );
  }

  @override
  AsyncValueOf<ForkliftLogDetailResult> getOperatorLogDetail(String logName) {
    return _retry(() => executeSafely(() async {
          final config = RequestConfig<ForkliftLogDetailResult>(
            url: Urls.getForkliftOperatorLogDetail,
            parser: (json) => ForkliftLogDetailResult.fromData(_dataOf(json)),
            reqParams: {'log': logName},
          );
          final response = await post(config);
          return response.process((r) => right(r.data!));
        }));
  }

  @override
  AsyncValueOf<ForkliftSession?> getMySession() {
    return _retry(
      () => executeSafely(() async {
        final config = RequestConfig<ForkliftSession?>(
          url: Urls.getMyForkliftSession,
          parser: (json) {
            final data = _dataOf(json);
            final session = data['session'];
            if (session is Map<String, dynamic>) {
              return ForkliftSession.fromJson(session);
            }
            return null;
          },
          reqParams: const <String, dynamic>{},
        );
        final response = await post(config);
        return response.process((r) => right(r.data));
      }),
      rounds: 2,
      parallel: 2,
    );
  }

  @override
  AsyncValueOf<ForkliftStatusListResult> getStatusList({
    String? search,
    String? status,
    String? plantName,
  }) {
    return _retry(() => executeSafely(() async {
          final body = <String, dynamic>{
            if (search != null && search.trim().isNotEmpty)
              'search': search.trim(),
            if (status != null &&
                status.trim().isNotEmpty &&
                status.toLowerCase() != 'all')
              'status': status.trim(),
            if (plantName != null && plantName.trim().isNotEmpty)
              'plant_name': plantName.trim(),
          };
          final config = RequestConfig<ForkliftStatusListResult>(
            url: Urls.getForkliftStatusList,
            parser: (json) => ForkliftStatusListResult.fromJson(_dataOf(json)),
            reqParams: _stringParams(body),
          );
          final response = await post(config);
          return response.process((r) => right(r.data!));
        }));
  }

  @override
  AsyncValueOf<ForkliftDetailResult> getForkliftDetail(String forklift) {
    return _retry(() => executeSafely(() async {
          final config = RequestConfig<ForkliftDetailResult>(
            url: Urls.getForkliftDetail,
            parser: (json) => ForkliftDetailResult.fromData(_dataOf(json)),
            reqParams: {'forklift': forklift},
          );
          final response = await post(config);
          return response.process((r) => right(r.data!));
        }));
  }

  @override
  AsyncValueOf<ForkliftScanResult> scanForklift({
    required String qrText,
    String? deviceId,
  }) {
    return _retry(() => executeSafely(() async {
          final body = <String, dynamic>{
            'qr_text': qrText,
            if (deviceId != null && deviceId.isNotEmpty) 'device_id': deviceId,
          };
          final config = RequestConfig<ForkliftScanResult>(
            url: Urls.scanForklift,
            parser: (json) {
              final message = json['message'];
              if (message is Map<String, dynamic>) {
                return ForkliftScanResult.fromMessage(message);
              }
              return const ForkliftScanResult(
                ok: false,
                popupMessage: 'Unexpected scan response',
              );
            },
            // Scan/login still accept JSON on healthy workers; keep JSON for
            // nested safety, but retry covers flaky UAT.
            body: jsonEncode(body),
            headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          );
          final response = await post(config);
          return response.process((r) => right(r.data!));
        }));
  }

  @override
  AsyncValueOf<ForkliftLoginResult> markLogin({
    required String qrText,
    required String idempotencyKey,
    String? deviceId,
    String? appVersion,
  }) {
    return _retry(() => executeSafely(() async {
          final body = <String, dynamic>{
            'qr_text': qrText,
            'idempotency_key': idempotencyKey,
            if (deviceId != null && deviceId.isNotEmpty) 'device_id': deviceId,
            if (appVersion != null && appVersion.isNotEmpty)
              'app_version': appVersion,
          };
          final config = RequestConfig<ForkliftLoginResult>(
            url: Urls.markForkliftLogin,
            parser: (json) {
              final message = json['message'];
              if (message is Map<String, dynamic>) {
                return ForkliftLoginResult.fromMessage(message);
              }
              return ForkliftLoginResult.fromData(_dataOf(json));
            },
            body: jsonEncode(body),
            headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          );
          final response = await post(config);
          return response.process((r) => right(r.data!));
        }));
  }

  @override
  AsyncValueOf<ForkliftLogoutResult> markLogout({
    required String logName,
    required String idempotencyKey,
    required String qrText,
  }) {
    final scanned = qrText.trim();
    if (scanned.isEmpty) {
      return Future.value(
        left(
          const Failure(
            error:
                'Logout without scan is not allowed. Scan the QR sticker on the forklift to log out.',
          ),
        ),
      );
    }

    return _retry(() => executeSafely(() async {
          final body = <String, dynamic>{
            'log': logName,
            'idempotency_key': idempotencyKey,
            'logout_method': 'QR Scan',
            'qr_text': scanned,
          };
          final config = RequestConfig<ForkliftLogoutResult>(
            url: Urls.markForkliftLogout,
            parser: (json) => ForkliftLogoutResult.fromData(_dataOf(json)),
            body: jsonEncode(body),
            headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          );
          final response = await post(config);
          return response.process((r) => right(r.data!));
        }));
  }
}
