import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/vision_panel/data/vision_panel_repo.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_items.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_model.dart';

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
      // 'sales_order': form.salesOrder,
      // 'pallet_code': form.palletCode,
      'items': lines,
    };

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
  AsyncValueOf<List<VisionItems>> fetchVisionLines(String itemName) async {
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'] as List<dynamic>;

        return data.map((e) => VisionItems.fromJson(e)).toList();
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
}
