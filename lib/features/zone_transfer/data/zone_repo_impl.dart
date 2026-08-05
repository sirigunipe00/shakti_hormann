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
  AsyncValueOf<Pair<String,String>> createZone(Storage form) async{
    final formJson = form.toJson();
    formJson['status'] = ['Draft'];
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
    final Map<String, dynamic> requestBody = {
      'pallet__box_qr_scan': form.palletBoxQr,
      'old_zone_qr': form.oldZone,
      'zone_qr': form.zoneQr,
      'location_photo': zonecompressedBytes == null
              ? null
              : base64Encode(zonecompressedBytes)
    };
    final config = RequestConfig(
      url: Urls.storageAllocation,
      parser: (json) {
       final message = json['message']['message'] as String;

        final data = json['message']['data'] as Map<String, dynamic>;

        final docNo = data['storage_zone_id'] as String;
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
  @override
  AsyncValueOf<List<Storage>> fetchSales(String palletNo) async {
     final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'] as List<dynamic>;
        return data.map((e) => Storage.fromJson(e)).toList();
      },
      reqParams: {
        'doctype': 'Storage Zone',
        'fields': jsonEncode(['*']),
        'filters': jsonEncode([
          ['pallet__box_qr_scan', '=', palletNo],
          ]),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }
    
  }
