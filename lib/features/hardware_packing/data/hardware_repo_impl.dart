import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/hardware_packing/data/hardware_repo.dart';
import 'package:shakti_hormann/features/hardware_packing/model/hardware_item.dart';
import 'package:shakti_hormann/features/hardware_packing/model/hardware_packing.dart';
import 'package:shakti_hormann/features/hardware_packing/model/hardware_packing_item.dart';

@LazySingleton(as: HardWareRepo)
class HardWareRepoImp extends BaseApiRepository implements HardWareRepo {
  HardWareRepoImp(super.dio);

  @override
  AsyncValueOf<List<HardwarePacking>> fetchHardware(
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
        ..add(['sales_order_no', 'like', '%$search%']);
    }
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'] as List<dynamic>;
        return data.map((e) => HardwarePacking.fromJson(e)).toList();
      },
      reqParams: {
        'filters': jsonEncode(filters),
        if (orFilters.isNotEmpty) 'or_filters': jsonEncode(orFilters),
        'limit_start': start,
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'Hardware Packing',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig....$requestConfig');

    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<Pair<String, String>> createHardware(
    HardwarePacking form,
    List<HardwareItem> lines,
  ) async {
    String? formattedDate;
    try {
      if (form.captueDate != null && form.captueDate!.isNotEmpty) {
        final parsed = DateFormat('dd.MM.yyyy').parse(form.captueDate!);
        formattedDate = DateFormat('yyyy-MM-dd').format(parsed);
      }
    } catch (_) {
      formattedDate = form.captueDate;
    }

    final captures = await _buildMesCaptures(lines);

    final Map<String, dynamic> requestBody = {
      'sales_order_no': form.salesOrderNo ?? '',
      'print_date': formattedDate ?? '',
      'remarks': form.remarks ?? '',
      'captures': captures,
    };

    final config = RequestConfig(
      url: Urls.createHardware,
      parser: (json) => _parseHardwareResponse(json, fallbackId: ''),
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
  AsyncValueOf<Pair<String, String>> updateHardware(
    HardwarePacking form,
    List<HardwareItem> lines,
  ) async {
    final name = form.name;
    if (name == null || name.isEmpty) {
      return left(
        const Failure(
          error: 'Hardware packing id missing for update',
          title: 'Update Failed',
          status: 0,
        ),
      );
    }

    final captures = await _buildMesCaptures(lines);

    final Map<String, dynamic> requestBody = {
      'hardware_packing_id': name,
      'captures': captures,
    };

    final config = RequestConfig(
      url: Urls.updateHardware,
      parser: (json) => _parseHardwareResponse(json, fallbackId: name),
      body: jsonEncode(requestBody),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('updateHardware.....$config');

    final response = await post(config);
    return response.processAsync((r) async {
      return right(Pair(r.data!.first, r.data!.second));
    });
  }

  Future<List<Map<String, dynamic>>> _buildMesCaptures(
    List<HardwareItem> lines,
  ) async {
    final grouped = <String, List<HardwareItem>>{};
    for (final item in lines) {
      grouped.putIfAbsent(_mesCaptureKey(item), () => []).add(item);
    }

    final captures = <Map<String, dynamic>>[];
    for (final group in grouped.values) {
      final first = group.first;
      var imagePayload = '';
      final imageFile = first.mesStickerImage;
      if (imageFile != null) {
        final compressedBytes = await _compressImage(imageFile);
        if (compressedBytes != null) {
          imagePayload =
              'data:image/jpeg;base64,${base64Encode(compressedBytes)}';
        }
      }

      final mesNumber = first.mesNumber ?? first.mesBarCode ?? '';
      captures.add({
        'box': first.box ?? '',
        'page': first.page ?? '',
        'box_type': first.boxType ?? '',
        'mes_number': mesNumber,
        'image': imagePayload,
        'items':
            group
                .map(
                  (item) => {
                    'sap_code': item.materialCode ?? '',
                    'description': item.productName ?? '',
                    'qty': item.qtySticker ?? 0,
                    'uom': item.uom ?? '',
                  },
                )
                .toList(),
      });
    }
    return captures;
  }

  String _mesCaptureKey(HardwareItem item) {
    return [
      item.mesNumber ?? item.mesBarCode ?? '',
      item.box ?? '',
      item.page ?? '',
      item.boxType ?? '',
      item.mesStickerImage?.path ?? item.mesStcikerImage ?? '',
    ].join('|');
  }

  @override
  AsyncValueOf<Pair<String, String>> addHardwareCapture({
    required String hardwarePackingId,
    required List<HardwareItem> lines,
  }) async {
    if (lines.isEmpty) {
      return left(
        const Failure(
          error: 'No capture data to add',
          title: 'MISSING_FIELDS',
          status: 0,
        ),
      );
    }

    final captures = await _buildMesCaptures(lines);
    if (captures.isEmpty) {
      return left(
        const Failure(
          error: 'Unable to build capture payload',
          title: 'MISSING_FIELDS',
          status: 0,
        ),
      );
    }

    final capture = captures.first;
    final requestBody = {
      'hardware_packing_id': hardwarePackingId,
      'box': capture['box'],
      'page': capture['page'],
      'mes_number': capture['mes_number'],
      'image': capture['image'],
      'box_type': capture['box_type'],
      'items': capture['items'],
    };

    final config = RequestConfig(
      url: Urls.addHardwareCapture,
      parser: (json) =>
          _parseHardwareResponse(json, fallbackId: hardwarePackingId),
      body: jsonEncode(requestBody),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('addHardwareCapture.....$config');
    final response = await post(config);
    return response.processAsync((r) async {
      return right(Pair(r.data!.first, r.data!.second));
    });
  }

  Pair<String, String> _parseHardwareResponse(
    Map<String, dynamic> json, {
    required String fallbackId,
  }) {
    final message = json['message'];
    if (message is Map<String, dynamic>) {
      final ok = message['ok'] == true;
      final status = message['status'] as int?;
      final code = message['code'] as String? ?? '';
      final text = message['message'] as String? ?? 'Request failed';
      if (!ok || (status != null && status >= 300) || _isHardwareErrorCode(code)) {
        throw Exception(_formatHardwareError(code, text, message['data']));
      }
      final data = message['data'];
      String docNo = fallbackId;
      String hint = '';
      if (data is Map<String, dynamic>) {
        docNo = data['hardware_packing_id'] as String? ??
            data['name'] as String? ??
            fallbackId;
        final coverage = data['capture_coverage'];
        if (coverage is Map<String, dynamic>) {
          hint = coverage['next_hint'] as String? ?? '';
        }
      }
      final combined = hint.isNotEmpty ? '$text\n$hint' : text;
      return Pair(combined, docNo);
    }
    return Pair(message as String, fallbackId);
  }

  bool _isHardwareErrorCode(String code) {
    return const {
      'MISSING_FIELDS',
      'MES_MISMATCH',
      'DUPLICATE_MES',
      'DUPLICATE_CAPTURE',
      'PAGES_INCOMPLETE',
      'BOXES_INCOMPLETE',
    }.contains(code);
  }

  String _formatHardwareError(String code, String text, dynamic data) {
    final buffer = StringBuffer(text);
    if (data is Map<String, dynamic>) {
      if (code == 'MISSING_FIELDS' && data['missing'] != null) {
        buffer.write('\nMissing: ${data['missing']}');
      }
      if (code == 'DUPLICATE_MES' && data['existing_record'] != null) {
        buffer.write('\nExisting record: ${data['existing_record']}');
      }
      final coverage = data['capture_coverage'];
      if (coverage is Map<String, dynamic> &&
          coverage['next_hint'] is String &&
          (coverage['next_hint'] as String).isNotEmpty) {
        buffer.write('\n${coverage['next_hint']}');
      }
    }
    return buffer.toString();
  }

  Map<String, dynamic> _normalizeOcrPayload(Map<String, dynamic> data) {
    String label({
      required Map<String, dynamic> source,
      required String labelKey,
      required String fallbackKey,
      required String noKey,
      required String totalKey,
    }) {
      final labeled = source[labelKey]?.toString().trim() ?? '';
      if (labeled.isNotEmpty) return labeled;
      final fallback = source[fallbackKey]?.toString().trim() ?? '';
      if (fallback.isNotEmpty) return fallback;
      final no = source[noKey];
      final total = source[totalKey];
      if (no != null && total != null) return '$no/$total';
      return '';
    }

    String boxOf(Map<String, dynamic> source) => label(
      source: source,
      labelKey: 'box_label',
      fallbackKey: 'box',
      noKey: 'box_no',
      totalKey: 'box_total',
    );

    String pageOf(Map<String, dynamic> source) => label(
      source: source,
      labelKey: 'page_label',
      fallbackKey: 'page',
      noKey: 'page_no',
      totalKey: 'page_total',
    );

    final parentBox = boxOf(data);
    final parentPage = pageOf(data);
    final items = (data['items'] as List<dynamic>?)
        ?.whereType<Map>()
        .map((raw) {
          final e = Map<String, dynamic>.from(raw);
          final itemBox = boxOf(e);
          final itemPage = pageOf(e);
          e['box'] = itemBox.isNotEmpty ? itemBox : parentBox;
          e['page'] = itemPage.isNotEmpty ? itemPage : parentPage;
          e['mes_number'] = e['mes_number'] ?? data['mes_number'];
          e['box_type'] = e['box_type'] ?? data['box_type'];
          e['qty'] = e['qty'] ?? e['qty_on_sticker'];
          e['sap_code'] = e['sap_code'] ?? e['product_name'];
          e['description'] = e['description'] ?? e['product_name'];
          return e;
        })
        .toList();

    data['box'] = parentBox;
    data['page'] = parentPage;
    if (items != null) data['items'] = items;
    return data;
  }

@override
AsyncValueOf<Pair<String, String>> submitHardware(String name) async {
  final requestBody = {'hardware_packing_id': name};

  final config = RequestConfig(
    url: Urls.submitHardware,
    parser: (json) => _parseHardwareResponse(json, fallbackId: name),
    body: jsonEncode(requestBody),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );

  $logger.devLog('submitHardware....$config');
  

  final response = await post(config);
  $logger.devLog('submithardware.....$response');
  return response.process((r) => right(r.data!));
}

  @override
  AsyncValueOf<HardwarePackingItem> fetchHardwareItems(
    String base64Image,
  ) async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.getMesValues,
        parser: (json) {
          final raw = Map<String, dynamic>.from(json as Map);
          final message = raw['message'];
          final map = message is Map
              ? Map<String, dynamic>.from(message)
              : raw;
          final payload = map['data'] is Map
              ? Map<String, dynamic>.from(map['data'] as Map)
              : map;
          return HardwarePackingItem.fromJson(_normalizeOcrPayload(payload));
        },
        body: jsonEncode({'base64_image': base64Image}),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      final response = await post(config);

      $logger.devLog('config:$config');

      return response.process((r) => right(r.data!));
    });
  }

  Future<Uint8List?> _compressImage(File file) async {
    try {
      if (!file.existsSync()) {
        $logger.error('Image file does not exist: ${file.path}');
        return null;
      }

      return await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        quality: 40,
        format: CompressFormat.jpeg,
      );
    } catch (e) {
      $logger.error('Compression Error: $e');
      return null;
    }
  }

  @override
  AsyncValueOf<List<HardwareItem>> fetchItems(String name) async {
    return await executeSafely(() async {
      final reqParams = {
        'limit_start': 0,
        'limit_page_length': 'None',
        'order_by': 'idx asc',
        'doctype': 'Hardware Packing Lines',
        'parent': 'Hardware Packing',
        'fields': jsonEncode(['*']),
        'filters': jsonEncode([
          ['parent', '=', name],
        ]),
      };

      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata
              .whereType<Map>()
              .map(
                (e) => HardwareItem.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList();
        },

        reqParams: reqParams,

        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      final response = await get(config);
      $logger.devLog('response.....$response');
      return response.processAsync((r) async {
        return right((r.data!));
      });
    });
  }
}
