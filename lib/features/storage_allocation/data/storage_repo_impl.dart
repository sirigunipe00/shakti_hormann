import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/storage_allocation/data/storage_repo.dart';
import 'package:shakti_hormann/features/storage_allocation/model/pallet_details.dart';
import 'package:shakti_hormann/features/storage_allocation/model/storage.dart';

@LazySingleton(as: StorageRepo)
class StorageRepoImp extends BaseApiRepository implements StorageRepo {
  StorageRepoImp(super.dio);

  @override
  AsyncValueOf<List<Storage>> fetchStorage(
    int start,
    int? docStatus,
    String? search,
  ) async {
    final filters = <List<dynamic>>[];
    final orFilters = <List<dynamic>>[];

    if (docStatus != null && docStatus != 2) {
      filters.add(['docstatus', '=', docStatus]);
    }

    if (search != null && search.isNotEmpty) {
      orFilters
        ..add(['name', 'like', '%$search%'])
        ..add(['sales_order', 'like', '%$search%']);
    }

    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'] as List<dynamic>;
        return data.map((e) => Storage.fromJson(e)).toList();
      },
      reqParams: {
        'filters': jsonEncode(filters),
        if (orFilters.isNotEmpty) 'or_filters': jsonEncode(orFilters),
        'limit_start': start,
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'Storage Zone',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig....$requestConfig');

    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }
  @override
  AsyncValueOf<Pair<String,String>> createStorage(Storage form) async {
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
    final Map<String, dynamic> requestBody = {
      'pallet__box_qr_scan': form.palletBoxQr,
      'zone_qr': form.zoneQr,
      'location_photo': photo,
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

    $logger.devLog('requestConfig.....$config');

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
AsyncValueOf<PalletDetails> fetchSales(String palletNo) async {
  final requestConfig = RequestConfig(
    url: Urls.getSales, 
    parser: (json) {
      return PalletDetails.fromJson(
        json['message'] as Map<String, dynamic>,
      );
    },
    reqParams: {
      'pallet_no': palletNo,
    },
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    },
  );

  final response = await get(requestConfig);
  return response.process((r) => right(r.data!));
}

  
}

