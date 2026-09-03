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
        return data.map((e) => VisionModel.fromJson(e)).toList();
      },
      reqParams: {
        'filters': jsonEncode(filters),
        if (orFilters.isNotEmpty) 'or_filters': jsonEncode(orFilters),
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
  AsyncValueOf<VisionPanelSaveResult> createVision(
    VisionModel form,
    List<VisionItems> lines,
  ) async {
    final first = lines.first;
    final requestBody = {
      'sales_order_no': form.salesOrderNo,
      'items': [
        {
          'product_type': first.productType,
          'no_of_boxes': first.noOfBoxes,
        },
      ],
    };

    final config = RequestConfig(
      url: Urls.createVision,
      parser: _parseVisionSaveResult,
      body: jsonEncode(requestBody),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig.....$config');

    final response = await post(config);
    return response.processAsync((r) async {
      return right(r.data!);
    });
  }

  @override
  AsyncValueOf<List<VisionPanelEntryLines>> getVisionPanelBoxSequence({
    required String salesOrderNo,
    required int noOfBoxes,
  }) async {
    final config = RequestConfig(
      url: Urls.getVisionPanelBoxSequence,
      parser: (json) {
        final envelope = _requireVisionOk(json);
        final data = envelope['data'] as Map<String, dynamic>? ?? {};
        final rawBoxes = data['boxes'] as List<dynamic>? ?? [];
        return rawBoxes
            .whereType<Map<String, dynamic>>()
            .map(VisionPanelEntryLines.fromJson)
            .toList();
      },
      body: jsonEncode({
        'sales_order_no': salesOrderNo,
        'no_of_boxes': noOfBoxes,
      }),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('getVisionPanelBoxSequence....$config');
    final response = await post(config);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<VisionPanelSaveResult> updateVision(
    String name, {
    String? productType,
    int? noOfBoxes,
    List<Map<String, String>> images = const [],
  }) async {
    final requestBody = <String, dynamic>{
      'vision_panel_id': name,
    };
    if (images.isNotEmpty) {
      requestBody['images'] = images;
    } else if (productType != null) {
      requestBody['items'] = [
        {
          'product_type': productType,
          if (noOfBoxes != null) 'no_of_boxes': noOfBoxes,
        },
      ];
    }

    final config = RequestConfig(
      url: Urls.updateVision,
      parser: _parseVisionSaveResult,
      body: jsonEncode(requestBody),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('updateVision....$config');

    final response = await post(config);
    return response.process((r) => right(r.data!));
  }

  VisionPanelSaveResult _parseVisionSaveResult(Map<String, dynamic> json) {
    final envelope = _requireVisionOk(json);
    final text = envelope['message'] as String? ?? 'Success';
    final data = envelope['data'] as Map<String, dynamic>? ?? {};
    final docNo = data['vision_panel_id'] as String? ??
        data['name'] as String? ??
        '';
    final rawItems = data['items'] as List<dynamic>? ?? [];
    final rawLines =
        data['vision_panel_entry_lines'] as List<dynamic>? ?? [];
    final pending = data['pending_boxes'] as List<dynamic>? ?? [];
    final next = data['next_actions'] as List<dynamic>? ?? [];
    return VisionPanelSaveResult(
      message: text,
      name: docNo,
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map(VisionItems.fromJson)
          .toList(),
      entryLines: rawLines
          .whereType<Map<String, dynamic>>()
          .map(VisionPanelEntryLines.fromJson)
          .toList(),
      pendingBoxes: pending.map((e) => e.toString()).toList(),
      nextActions: next.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> _requireVisionOk(Map<String, dynamic> json) {
    final message = json['message'];
    if (message is Map<String, dynamic>) {
      final ok = message['ok'] == true;
      final status = message['status'] as int?;
      final text = message['message'] as String? ?? 'Request failed';
      if (!ok || (status != null && status >= 300)) {
        throw Exception(text);
      }
      return message;
    }
    throw Exception('Unsupported Vision Panel response');
  }

  @override
  AsyncValueOf<String> printVisionSticker(String id) async {
    final Map<String, dynamic> requestBody = {'docname': id};

    final config = RequestConfig(
      url: Urls.printVisionSticker,
      parser: (json) {
        final message = json['message'] as Map<String, dynamic>;
        final status = message['status'] as int?;
        final text = message['message'] as String? ?? 'Unknown error';
        if (status != null && status >= 300) {
          throw Exception(text);
        }

        return text;
      },
      body: jsonEncode(requestBody),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('printShutterSticker requestConfig.....$config');

    final response = await post(config);
    $logger.devLog('printShutterSticker response.....$response');
    return response.processAsync((r) async {
      return right(r.data!);
    });
  }

  @override
  AsyncValueOf<Pair<String,String>> submitVision(String name) async {
    final requestBody = {'vision_panel_id': name};

    final config = RequestConfig(
      url: Urls.submitVision,
      // parser: (json) => json['message']['message'] as String,
       parser: (json) {
        final message = json['message']['message'] as String;

        final data = json['message']['data'] as Map<String, dynamic>;

        final docNo = data['vision_panel_id'] as String;

        return Pair(message, docNo);
      },
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

        final items =
            data.map((e) => VisionItems.fromJson(e)).toList()
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
  AsyncValueOf<List<VisionPanelEntryLines>> fetchVisionEntryLines(
    String itemName,
  ) async {
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
        'limit': 100,
        'order_by': 'idx asc',
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
