import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/storage_allocation/model/storage.dart';
import 'package:shakti_hormann/features/zone_transfer/data/zone_repo.dart';

@LazySingleton(as: ZoneRepo)
class ZoneRepoImp extends BaseApiRepository implements ZoneRepo{
  ZoneRepoImp(super.dio);

  @override
  AsyncValueOf<List<Storage>> fetchZone(
    int start,
    int? docStatus,
    String? search,
  ) async {
    final filters = <List<dynamic>>[];

    if (docStatus != null && docStatus != 2) {
      filters.add(['docstatus', '=', docStatus]);
    }

    if (search != null && search.isNotEmpty) {
      filters.add(['name', 'like', '%$search%']);
    }
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'] as List<dynamic>;
        return data.map((e) => Storage.fromJson(e)).toList();
      },
      reqParams: {
        'filters': jsonEncode(filters),
        'limit_start': start,
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'Zone Transfer',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig....$requestConfig');

    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<Pair<String, String>> createZone(Storage form) async {
    Uint8List? zonecompressedBytes;

    if (form.locationPhotoImg != null) {
      final filePath = form.locationPhotoImg!.path;
      zonecompressedBytes = await FlutterImageCompress.compressWithFile(
        filePath,
        quality: 50,
      );
    } else if (form.locationPhoto != null) {
      zonecompressedBytes = await fetchAndConvertToBase64(
        form.locationPhoto ?? '',
      );
    }

    final photo = zonecompressedBytes == null
        ? null
        : 'data:image/jpeg;base64,${base64Encode(zonecompressedBytes)}';

    final requestBody = <String, dynamic>{
      'pallet__box_qr_scan': form.palletBoxQr,
      'new_zone_qr': form.zoneQr,
      'location_photo': photo,
    };
    if (form.remarks != null && form.remarks!.trim().isNotEmpty) {
      requestBody['remarks'] = form.remarks;
    }

    final config = RequestConfig(
      url: Urls.zoneTransfer,
      parser: (json) {
       final message = json['message']['message'] as String;

        final data = json['message']['data'] as Map<String, dynamic>;

        final docNo = data['zone_transfer_id'] as String;
        return Pair(message, docNo);
      },
      body: jsonEncode(requestBody),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('zone.....$config');

    final response = await post(config);
    return response.processAsync((r) async {
      return right(Pair(r.data!.first, r.data!.second));
    });
  }

  @override
  AsyncValueOf<ZonePalletScanResult> scanPalletForZoneTransfer(
    String palletQr,
  ) async {
    final config = RequestConfig(
      url: Urls.scanPalletForZoneTransfer,
      parser: (json) {
        final envelope = _requireZoneOk(json);
        final data = envelope['data'] as Map<String, dynamic>? ?? {};
        final isNew = data['is_new_pallet'] == true;
        final movement = (data['movement_count'] as num?)?.toInt() ?? 0;
        return ZonePalletScanResult(
          palletQr: data['pallet__box_qr_scan'] as String? ??
              data['scanned_qr'] as String? ??
              palletQr,
          salesOrder: data['sales_order'] as String?,
          totalQty: (data['total_qty'] as num?)?.toInt(),
          oldZoneName: data['old_zone_name'] as String? ??
              data['current_zone'] as String?,
          isNewPallet: isNew,
          movementCount: movement,
          transferCount: isNew ? 0 : (movement > 0 ? movement - 1 : 0),
          popupMessage: _zoneMessage(envelope),
        );
      },
      body: jsonEncode({'pallet__box_qr_scan': palletQr}),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('scanPalletForZoneTransfer....$config');
    final response = await post(config);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<int> getPalletTransferCount(String palletQr) async {
    final config = RequestConfig(
      url: Urls.getPalletMovementHistory,
      parser: (json) {
        final envelope = _requireZoneOk(json);
        final data = envelope['data'] as Map<String, dynamic>? ?? {};
        return (data['transfer_count'] as num?)?.toInt() ?? 0;
      },
      reqParams: {'pallet__box_qr_scan': palletQr},
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('getPalletMovementHistory....$config');
    final response = await get(config);
    return response.process((r) => right(r.data!));
  }

  Map<String, dynamic> _requireZoneOk(Map<String, dynamic> json) {
    final message = json['message'];
    if (message is Map<String, dynamic>) {
      final ok = message['ok'] == true;
      final status = message['status'] as int?;
      if (!ok || (status != null && status >= 300)) {
        throw Exception(_zoneMessage(message));
      }
      return message;
    }
    throw Exception('Unsupported Zone Transfer response');
  }

  String _zoneMessage(Map<String, dynamic> envelope) {
    final data = envelope['data'];
    if (data is Map<String, dynamic>) {
      final popup = data['popup_message'] as String?;
      if (popup != null && popup.isNotEmpty) return popup;
    }
    return envelope['message'] as String? ?? 'Request failed';
  }

  Future<Uint8List?> fetchAndConvertToBase64(String relativePath) async {
    if (p.extension(relativePath).isEmpty) {
      return null;
    }

    final String url = Urls.filepath(relativePath);

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load file: ${response.statusCode}');
    }
  }
}
