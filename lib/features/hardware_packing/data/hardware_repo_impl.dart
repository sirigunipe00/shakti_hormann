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
        return data.map((e) => HardwarePacking.fromJson(e)).toList();
      },
      reqParams: {
        'filters': jsonEncode(filters),
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
    List<String> mesImages = [];

    final imageFile = form.mesStickerImage;

    if (imageFile != null) {
      final compressedBytes = await _compressImage(imageFile);

      if (compressedBytes != null) {
        final base64 = base64Encode(compressedBytes);

        mesImages.add(base64);
      }
    }
    String? formattedDate;
    try {
      if (form.captueDate != null && form.captueDate!.isNotEmpty) {
        final parsed = DateFormat('dd.MM.yyyy').parse(form.captueDate!);
        formattedDate = DateFormat('yyyy-MM-dd').format(parsed);
      }
    } catch (_) {
      formattedDate = form.captueDate;
    }

    final Map<String, dynamic> requestBody = {
      'sales_order_no': form.salesOrderNo ?? '',
      'print_date': formattedDate ?? '',
      'mes_number': form.mesSystem ?? '',
      'box_count': form.boxCount ?? 0,
      'remarks': form.remarks ?? '',
      'mes_images': mesImages,
      'items':
          lines
              .map(
                (item) => {
                  'product_name': item.productName ?? '',
                  'description': item.productName ?? '',
                  'qty_on_sticker': item.qtySticker ?? 0,
                  'uom': item.uom ?? '',
                  'sap_material_code': item.materialCode ?? '',
                  'mes_qr__barcode_value': item.mesBarCode ?? '',
                },
              )
              .toList(),
    };

    final config = RequestConfig(
      url: Urls.createHardware,
      parser: (json) {
        final message = json['message']['message'] as String;
        final data = json['message']['data'] as Map<String, dynamic>;
        final docNo = data['hardware_packing_id'] as String;
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

    final mesImages = <String>[];
    final seenPaths = <String>{};

    Future<void> addImage(File? file) async {
      if (file == null || !file.existsSync()) return;
      if (!seenPaths.add(file.path)) return;

      final compressedBytes = await _compressImage(file);
      if (compressedBytes == null) return;
      mesImages.add(
        'data:image/jpeg;base64,${base64Encode(compressedBytes)}',
      );
    }

    await addImage(form.mesStickerImage);
    for (final item in lines) {
      await addImage(item.mesStickerImage);
    }

    final Map<String, dynamic> requestBody = {
      'hardware_packing_id': name,
      'mes_images': mesImages,
      'items': lines
          .map(
            (item) => {
              'product_name': item.materialCode ?? item.productName ?? '',
              'description': item.productName ?? '',
              'qty_on_sticker': item.qtySticker ?? 0,
              'uom': item.uom ?? '',
            },
          )
          .toList(),
    };

    final config = RequestConfig(
      url: Urls.updateHardware,
      parser: (json) {
        final message = json['message'];
        if (message is Map<String, dynamic>) {
          final status = message['status'] as int?;
          final text = message['message'] as String? ?? 'Update failed';
          if (status != null && status >= 300) {
            throw Failure(error: text, title: 'Update Failed', status: status);
          }
          final data = message['data'];
          final docNo = data is Map<String, dynamic>
              ? (data['hardware_packing_id'] as String? ?? name)
              : name;
          return Pair(text, docNo);
        }
        return Pair(message as String, name);
      },
      body: jsonEncode(requestBody),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('updateHardware.....$config');

    final response = await post(config);
    return response.processAsync((r) async {
      return right(Pair(r.data!.first, r.data!.second));
    });
  }

  @override
  AsyncValueOf<Pair<String,String>> submitHardware(String name) async {
    final requestBody = {'hardware_packing_id': name};

    final config = RequestConfig(
      url: Urls.submitHardware,
       parser: (json) {
        final message = json['message']['message'] as String;

        final data = json['message']['data'] as Map<String, dynamic>;

        final docNo = data['name'] as String;

        return Pair(message, docNo);
      },
      body: jsonEncode(requestBody),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('submitHardware....$config');

    final response = await post(config);
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
          return HardwarePackingItem.fromJson(json['message']);
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
        'order_by': 'creation desc',
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
          return listdata.map((e) => HardwareItem.fromJson(e)).toList();
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
