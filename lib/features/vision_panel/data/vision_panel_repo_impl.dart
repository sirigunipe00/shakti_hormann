import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/vision_panel/data/vision_panel_repo.dart';
import 'package:shakti_hormann/features/vision_panel/model/product_type.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_items.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_model.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_panel_entry_lines.dart';

@LazySingleton(as: VisionPanelRepo)
class VisionPanelRepoImpl extends BaseApiRepository implements VisionPanelRepo {
  const VisionPanelRepoImpl(super.client);
  @override
  AsyncValueOf<List<VisionModel>> fetchPanels(
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
        return data.map((e) => VisionModel.fromJson(e)).toList();
      },
      reqParams: {
        'filters': jsonEncode(filters),
        'limit_start': start,
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'Vision Panel',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig....$requestConfig');

    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<Pair<String, String>> createVision(
    VisionModel form,
    List<VisionItems> lines,
  ) async {
    final formJson = form.toJson();
    formJson['status'] = 'Draft';

    final Map<String, dynamic> requestBody = {
      'sales_order_no': form.salesOrderNo,
      // 'pallet_code': form.palletCode,
      'items': lines,
    };

    final config = RequestConfig(
      url: Urls.createVision,
      parser: (json) {
        final message = json['message']['message'] as String;

        final data = json['message']['data'] as Map<String, dynamic>;

        final docNo = data['vision_panel_id'] as String;

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
  AsyncValueOf<String> updateVision(
     String name, {
     String? productType,
     int? noOfBoxes,
     required List<String> images,
   }) async {
    final requestBody = {
      'vision_panel_id': name,
      'items': images
          .map((images) => {'images': images})
          .toList(),
    };
 
    final config = RequestConfig(
      url: Urls.updateVision,
      parser: (json) => json['message']['message'] as String,
      body: jsonEncode(requestBody),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
 
    $logger.devLog('updateInstallation....$config');
 
    final response = await post(config);
    return response.process((r) => right(r.data!));
  }
@override
AsyncValueOf<String> printVisionSticker(String id) async {
  final Map<String, dynamic> requestBody = {
    'docname': id,
  };

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
  return response.processAsync((r) async {
    return right(r.data!);
  });
}
  @override
  AsyncValueOf<String> submitVision(String name) async {
    final requestBody = {'name': name};

    final config = RequestConfig(
      url: Urls.submitVision, 
      parser: (json) => json['message']['message'] as String,
      body: jsonEncode(requestBody),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('submitInstallation....$config');

    final response = await post(config);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<List<VisionItems>> fetchVisionLines(String itemName) async {
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
  final data = json['message'] as List<dynamic>;

  final items = data.map((e) => VisionItems.fromJson(e)).toList()

  ..sort((a, b) => (a.creation ?? '').compareTo(b.creation ?? ''));

  return items;
},
      reqParams: {
        'filters': jsonEncode([
          ['parent', '=', itemName],
        ]),
        'limit': 20,
        'order_by': 'idx asc',
        'doctype': 'Vision Panel Lines',
        'parent': 'Vision Panel',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }
    @override
  AsyncValueOf<List<VisionPanelEntryLines>> fetchVisionEntryLines(String itemName) async {
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'] as List<dynamic>;

        return data.map((e) => VisionPanelEntryLines.fromJson(e)).toList();
      },

      reqParams: {
        'filters': jsonEncode([
          ['parent', '=', itemName],
        ]),
        'limit': 20,
        'order_by': 'creation desc',
        'doctype': 'Vision Panel Entry Lines',
        'parent': 'Vision Panel',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }
   @override
  AsyncValueOf<List<ProductType>> fetchProduct() async {
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'] as List<dynamic>;

        return data.map((e) => ProductType.fromJson(e)).toList();
      },

      reqParams: {
        'limit': 20,
        'order_by': 'creation desc',
        'doctype': 'Product Type',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }
}
