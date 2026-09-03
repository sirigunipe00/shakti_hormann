import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_entry/model/attachement.dart';
import 'package:shakti_hormann/features/pallet_creation/model/pallet_model.dart';
import 'package:shakti_hormann/features/shutter_packing/data/shutter_packaging_repo.dart';
import 'package:shakti_hormann/features/shutter_packing/model/items.dart';
import 'package:shakti_hormann/features/shutter_packing/model/pallet_size.dart';
import 'package:shakti_hormann/features/shutter_packing/model/shutter_lines.dart';
import 'package:shakti_hormann/features/shutter_packing/model/shutter_packing.dart';

@LazySingleton(as: ShutterPackingRepo)
class ShutterPackingRepoImpl extends BaseApiRepository
    implements ShutterPackingRepo {
  ShutterPackingRepoImpl(super.dio);

  @override
  AsyncValueOf<List<ShutterPacking>> fetchShutterPacking(
    int start,
    String? status,
    String? search,
  ) async {
    final filters = <List<dynamic>>[];
    final orFilters = <List<dynamic>>[];

    switch ((status ?? '').trim().toLowerCase()) {
      case 'draft':
        filters.add(['docstatus', '=', 0]);
      case 'submitted':
        filters.add(['docstatus', '=', 1]);
      case 'unallocated':
        filters.add(['allocation_status', '=', 'Unallocated']);
      case 'allocated':
        filters.add(['allocation_status', '=', 'Allocated']);
      case 'dispatched':
        filters.add(['allocation_status', '=', 'Dispatched']);  
      case 'all':
      case '':
        break;
      default:
        filters.add(['docstatus', '=', 0]);
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
        return data.map((e) => ShutterPacking.fromJson(e)).toList();
      },
      reqParams: {
        'filters': jsonEncode(filters),
        if (orFilters.isNotEmpty) 'or_filters': jsonEncode(orFilters),
        'limit_start': start,
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'Shutter Packing',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig....$requestConfig');

    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<List<PalletSize>> getPalletSize() async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => PalletSize.fromJson(e)).toList();
        },
        reqParams: {
          'limit_start': 0,
          'limit_page_length': 'None',
          'oreder_by': 'creat desc',
          'doctype': 'Pallet Size',
        },

        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      final response = await get(config);
      $logger.devLog('pallet size.....$response');
      return response.processAsync((r) async {
        return right((r.data!));
      });
    });
  }

  @override
  AsyncValueOf<List<PalletModel>> getSales({
    String q = '',
    int limit = 50,
    int offset = 0,
  }) async {
    return await executeSafely(() async {
      final requestBody = <String, dynamic>{
        'product_type': 'Shutter',
        'q': q,
        'limit': limit,
        'offset': offset,
      };

      final config = RequestConfig(
        url: Urls.getPackingSalesOrders,
        parser: (json) => _parsePackingSalesOrders(json),
        body: jsonEncode(requestBody),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      $logger.devLog('get_packing_sales_orders.....$config');
      final response = await post(config);
      return response.processAsync((r) async {
        return right(r.data!);
      });
    });
  }

  List<PalletModel> _parsePackingSalesOrders(Map<String, dynamic> json) {
    final message = json['message'];
    List<dynamic> raw = const [];

    if (message is List) {
      raw = message;
    } else if (message is Map<String, dynamic>) {
      final data = message['data'];
      if (data is List) {
        raw = data;
      } else if (data is Map<String, dynamic>) {
        raw = (data['orders'] as List?) ??
            (data['sales_orders'] as List?) ??
            (data['data'] as List?) ??
            const [];
      }
    }

    final seen = <String>{};
    final out = <PalletModel>[];
    for (final item in raw) {
      if (item is! Map) continue;
      final map = Map<String, dynamic>.from(item);
      final so = (map['sales_order'] ?? map['name'] ?? '').toString().trim();
      if (so.isEmpty || seen.contains(so)) continue;
      seen.add(so);
      out.add(
        PalletModel(
          salesOrder: so,
          name: so,
          customerName: map['customer_name'] as String?,
          orderDate: map['order_date'] as String?,
        ),
      );
    }
    return out;
  }

  @override
  AsyncValueOf<List<Items>> fetchItems(String itemName, String index) async {
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'] as List<dynamic>;
        return data.map((e) => Items.fromJson(e)).toList();
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
  AsyncValueOf<List<ShutterLines>> fetchShutterLines(String itemName) async {
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'] as List<dynamic>;

        return data.map((e) => ShutterLines.fromJson(e)).toList();
      },

      reqParams: {
        'filters': jsonEncode([
          ['parent', '=', itemName],
        ]),
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'Shutter Packing Lines',
        'parent': 'Shutter Packing',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<String> printShutterSticker(String shutterPackingId) async {
    final Map<String, dynamic> requestBody = {'docname': shutterPackingId};

    final config = RequestConfig(
      url: Urls.printShutterSticker,
      parser: (json) {
        final message = json['message'] as Map<String, dynamic>;
        final status = message['status'] as int?;
        final text = message['message'] as String? ?? 'Unknown error';
        if (status != null && status >= 300) {
          throw Failure(error: text, title: 'Print Failed', status: status);
        }

        return text;
      },
      body: jsonEncode(requestBody),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('printShutterSticker requestConfig.....$config');

    final response = await post(config);
    $logger.devLog('response.......$response');
    return response.processAsync((r) async {
      return right(r.data!);
    });
  }

  @override
  AsyncValueOf<List<String>> getShutterPalletCode(String salesOrder) async {
    final config = RequestConfig(
      url: Urls.getPalletCode,
      reqParams: {'sales_order': salesOrder, 'product_type': 'Shutter'},
      parser: (json) {
        final data = json['message']['data'];
        if (data is! List) return <String>[];

        return data
            .whereType<Map>()
            .map((e) => e['pallet_code']?.toString() ?? '')
            .where((code) => code.isNotEmpty)
            .toList();
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    final response = await get(config);

    return response.processAsync((r) async => right(r.data!));
  }

  @override
  AsyncValueOf<List<AttachementInvoices>> fetchAttachments(
    String gateEntryId,
  ) async {
    return await executeSafely(() async {
      final filters = [
        ['attached_to_doctype', '=', 'Shutter Packing'],
        ['attached_to_name', '=', gateEntryId],
      ];

      final config = RequestConfig(
        url: Urls.getList,
        parser: (json) {
          final data = json['message'] as List<dynamic>;
          return data.map((e) => AttachementInvoices.fromJson(e)).toList();
        },
        reqParams: {
          'doctype': 'File',
          'filters': jsonEncode(filters),
          'fields': jsonEncode([
            'file_url',
            'attached_to_doctype',
            'attached_to_name',
            'attached_to_field',
          ]),
        },
      );

      final response = await get(config);
      $logger.devLog('fetchAttachments response.....$response');
      return response.process((r) => right(r.data!));
    });
  }

  @override
  AsyncValueOf<Pair<String, String>> createShutter(
    ShutterPacking form,
    List<ShutterLines> lines,
  ) async {
    final requestBody = <String, dynamic>{
      'sales_order': form.salesOrder,
      'pallet_code': form.palletCode,
    };
    if (form.remarks != null && form.remarks!.trim().isNotEmpty) {
      requestBody['remarks'] = form.remarks;
    }

    final config = RequestConfig(
      url: Urls.createShutter,
      parser: (json) {
        final message = json['message']['message'] as String;
        final data = json['message']['data'] as Map<String, dynamic>;
        final docNo = data['shutter_packing_id'] as String;
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
  AsyncValueOf<Pair<String, String>> updateShutter(
    ShutterPacking form,
    List<ShutterLines> lines,
  ) async {
    final itemsJson = <Map<String, dynamic>>[];

    for (final line in lines) {
      List<String>? shutterPhotoBase64List;

      final images = line.shutterPhotoImg;
      if (images != null && images.isNotEmpty) {
        shutterPhotoBase64List = [];
        for (final file in images) {
          final compressed = await FlutterImageCompress.compressWithFile(
            file.path,
            quality: 50,
          );
          if (compressed != null) {
            shutterPhotoBase64List.add(base64Encode(compressed));
          }
        }
      }

      final item = <String, dynamic>{
        'shutter_barcode__qr': line.shutterBarcodeQr,
        'item_code': line.itemCode,
        'sales_order': line.salesOrder ?? form.salesOrder,
      };
      if (shutterPhotoBase64List != null && shutterPhotoBase64List.isNotEmpty) {
        item['shutter_photo'] = shutterPhotoBase64List;
      }
      itemsJson.add(item);
    }

    final requestBody = {'shutter_packing_id': form.name, 'items': itemsJson};
    final config = RequestConfig(
      url: Urls.updateShutter,
      parser: (json) {
        final data = json['message']['message'] as String;
        return Pair(data, form.name ?? '');
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
  AsyncValueOf<Pair<String, String>> freezeShutter(
    String shutterPackingId,
  ) async {
    final requestBody = {
      'shutter_packing_id': shutterPackingId,
      'freeze_quantity': 1,
    };

    final config = RequestConfig(
      url: Urls.updateShutter,
      parser: (json) {
        final message = json['message'];
        if (message is Map<String, dynamic>) {
          final ok = message['ok'] as bool?;
          final status = message['status'] as int?;
          final text = message['message'] as String? ?? 'Freeze failed';
          if (ok == false || (status != null && status >= 300)) {
            throw Failure(error: text, title: 'Freeze Failed', status: status);
          }
          return Pair(text, shutterPackingId);
        }
        return Pair(message.toString(), shutterPackingId);
      },
      body: jsonEncode(requestBody),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('freezeShutter requestConfig.....$config');

    final response = await post(config);
    return response.processAsync((r) async {
      return right(Pair(r.data!.first, r.data!.second));
    });
  }

  @override
  AsyncValueOf<Pair<String, String>> submitShutter(ShutterPacking form) async {
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
        url: Urls.submitShutter,
        parser: (json) {
          return Pair(json['message']['message'] as String, '');
        },
        body: jsonEncode({
          'shutter_packing_id': form.name,
          'pallet_photo':
              palletcompressedBytes == null
                  ? null
                  : 'data:image/jpeg;base64,${base64Encode(palletcompressedBytes)}',
        }),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      final response = await post(config);
      $logger.devLog('response.......$response');

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
