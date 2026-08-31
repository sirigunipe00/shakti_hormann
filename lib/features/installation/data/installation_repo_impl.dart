import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/installation/data/installation_repo.dart';
import 'package:shakti_hormann/features/installation/model/installation_line_items.dart';
import 'package:shakti_hormann/features/installation/model/installation_model.dart';

@LazySingleton(as: InstallationRepo)
class InstallationRepoImpl extends BaseApiRepository implements InstallationRepo {
  const InstallationRepoImpl(super.client);
  @override
  AsyncValueOf<List<InstallationModel>> fetchInstallation(
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
        return data.map((e) => InstallationModel.fromJson(e)).toList();
      },
      reqParams: {
        'filters': jsonEncode(filters),
        if (orFilters.isNotEmpty) 'or_filters': jsonEncode(orFilters),
        'limit_start': start,
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'Installation Entry',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig....$requestConfig');

    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<InstallationCreateResult> createInstallation(
    InstallationModel form,
  ) async {
    final formJson = form.toJson();
    formJson['status'] = 'Draft';

    final Map<String, dynamic> requestBody = {
      'sales_order_no': form.salesOrderNo,
      'no_of_boxes': form.noOfBoxes,
    };

    final config = RequestConfig(
      url: Urls.createInstallation,
      parser: (json) {
        final message = json['message']['message'] as String;
        final data = json['message']['data'] as Map<String, dynamic>;
        final docNo = data['name'] as String;
        final rawItems = data['item'] as List<dynamic>? ?? [];
        final items = rawItems
            .whereType<Map<String, dynamic>>()
            .map(InstallationLineItems.fromJson)
            .toList();
        return InstallationCreateResult(
          message: message,
          name: docNo,
          items: items,
        );
      },
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
  AsyncValueOf<Pair<String,String>> updateInstallation(String name, {List<Map<String, String>>? images, int? noOfBoxes}) async {
    final requestBody = <String, dynamic>{'name': name};
    if (images != null && images.isNotEmpty) {
      requestBody['images'] = images;
    }
    if (noOfBoxes != null) {
      requestBody['no_of_boxes'] = noOfBoxes;
    }

    final config = RequestConfig(
      url: Urls.updateInstallation,
       parser: (json) {
        final message = json['message']['message'] as String;

        final data = json['message']['data'] as Map<String, dynamic>;

        final docNo = data['name'] as String;

        return Pair(message, docNo);
      },
      body: jsonEncode(requestBody),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('updateInstallation....$config');

    final response = await post(config);
    return response.process((r) => right(r.data!));
  }
@override
AsyncValueOf<String> printinstallationSticker(String id) async {
  final Map<String, dynamic> requestBody = {
    'docname': id,
  };

  final config = RequestConfig(
    url: Urls.printinstalltionStciker,
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
  AsyncValueOf<Pair<String,String>> submitInstallation(String name) async {
    final requestBody = {'name': name};

    final config = RequestConfig(
      url: Urls.submitInstallation, 
      // parser: (json) => json['message']['message'] as String,
       parser: (json) {
        final message = json['message']['message'] as String;

        final data = json['message']['data'] as Map<String, dynamic>;

        final docNo = data['name'] as String;

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
  AsyncValueOf<List<InstallationLineItems>> fetchInstallationLines(String itemName) async {
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'] as List<dynamic>;

        return data.map((e) => InstallationLineItems.fromJson(e)).toList();
      },

      reqParams: {
        'filters': jsonEncode([
          ['parent', '=', itemName],
        ]),
        'limit_page_length': 'None',
        'limit_start': 0,
        'order_by': 'idx asc',
        'doctype': 'Installation Entry Lines',
        'parent': 'Installation Entry',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }
}
