import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/frame_packing/data/frame_packing_repo.dart';
import 'package:shakti_hormann/features/frame_packing/model/frame_items.dart';
import 'package:shakti_hormann/features/frame_packing/model/frame_lines.dart';
import 'package:shakti_hormann/features/frame_packing/model/frame_packing.dart';

@LazySingleton(as: FramePackingRepo)
class FramePackingRepoImpl extends BaseApiRepository
    implements FramePackingRepo {
  FramePackingRepoImpl(super.dio);

  @override
  AsyncValueOf<List<FramePacking>> fetchFramePacking(
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
        return data.map((e) => FramePacking.fromJson(e)).toList();
      },
      reqParams: {
        'filters': jsonEncode(filters),
        'limit_start': start,
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'Frame Packing',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig....$requestConfig');

    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<List<FrameItems>> fetchItems(
    String itemName,
    String index,
  ) async {
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'] as List<dynamic>;
        return data.map((e) => FrameItems.fromJson(e)).toList();
      },
      reqParams: {
        'doctype': 'SAP Sales Order Items',
        'parent': 'SAP Sales Order',
        'fields': jsonEncode(['*']),
        'filters': jsonEncode([
          ['parent', '=', itemName],
          ['idx', '=', index],
        ]),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<List<FrameLines>> fetchFrameLines(String itemName) async {
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'] as List<dynamic>;

        return data.map((e) => FrameLines.fromJson(e)).toList();
      },

      reqParams: {
        'filters': jsonEncode([
          ['parent', '=', itemName],
        ]),
        'limit': 20,
        'order_by': 'creation desc',
        'doctype': 'Frame Packing Lines',
        'parent': 'Frame Packing',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<Pair<String, String>> createFrame(
    FramePacking form,
    List<FrameLines> lines,
  ) async {
    final formJson = form.toJson();
    formJson['status'] = 'Draft';

    final Map<String, dynamic> requestBody = {'items': lines};

    final config = RequestConfig(
      url: Urls.createFrame,
      parser: (json) {
        final message = json['message']['message'] as String;

        final data = json['message']['data'] as Map<String, dynamic>;

        final docNo = data['frame_packing_id'] as String;

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

  @override
  AsyncValueOf<Pair<String, String>> updateFrame(
    FramePacking form,
    List<FrameLines> lines,
  ) async {
    final formJson = form.toJson();
    formJson['status'] = 'Draft';
    final itemsJson = <Map<String, dynamic>>[];

    for (final line in lines) {
      String? framePhotoBase64;

      if (line.shutterPhotoImg != null) {
        final compressed = await safeCompress(line.shutterPhotoImg!);

        if (compressed != null) {
          framePhotoBase64 = base64Encode(compressed);
        }
      } else if (line.shutterPhoto != null) {
        final bytes = await fetchAndConvertToBase64(line.shutterPhoto!);

        if (bytes != null) {
          framePhotoBase64 = base64Encode(bytes);
        }
      }

      final json = line.toJson();
      json['frame_photo'] = framePhotoBase64;

      itemsJson.add(json);
    }

    final requestBody = {'frame_packing_id': form.name, 'items': itemsJson};
    final config = RequestConfig(
      url: Urls.updateFrame,
      parser: (json) {
        final data = json['message']['message'] as String;

        return Pair(data, '');
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

  @override
  AsyncValueOf<Pair<String, String>> submitFrame(FramePacking form) async {
    return await executeSafely(() async {
      Uint8List? palletcompressedBytes;
      if (form.palletPhotoImg != null) {
        final filePath = form.palletPhotoImg!.path;
        palletcompressedBytes = await FlutterImageCompress.compressWithFile(
          filePath,
          quality: 50,
        );
      } else if (form.palletPhoto != null) {
        palletcompressedBytes = await fetchAndConvertToBase64(
          form.palletPhoto ?? '',
        );
      }
      final config = RequestConfig(
        url: Urls.submitFrame,
        parser: (json) {
          return Pair(
            json['message']['message'] as String,
            json['message']['status'].toString(),
          );
        },
        body: jsonEncode({
          'frame_packing_id': form.name,
          'pallet_photo':
              palletcompressedBytes == null
                  ? null
                  : base64Encode(palletcompressedBytes),
        }),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      final response = await post(config);

      return response.processAsync((r) async {
        return right(r.data!);
      });
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
}

Future<Uint8List?> safeCompress(File file) async {
  if (!file.existsSync()) {
    $logger.error('Image not found: ${file.path}');
    return null;
  }
  try {
    return await FlutterImageCompress.compressWithFile(
      file.path,
      quality: 50,
      minWidth: 1024,
      minHeight: 1024,
    );
  } catch (e, s) {
    $logger
      ..error('Compression failed: $e')
      ..error(s.toString());
    return null;
  }
}
