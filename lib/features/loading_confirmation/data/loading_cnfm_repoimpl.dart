import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';
import 'package:shakti_hormann/features/loading_confirmation/data/loading_cnfm_repo.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/item_model.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/loading_cnfm.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/logistic.dart';

@LazySingleton(as: LoadingCnfmRepo)
class LoadingCnfmRepoimpl extends BaseApiRepository implements LoadingCnfmRepo {
  const LoadingCnfmRepoimpl(super.client);

@override
AsyncValueOf<List<LoadingCnfmForm>> fetchLoadingList(
  int start,
  String? docStatus,
  String? search,
  String? salesOrder,
) async {
  final filters = <List<dynamic>>[];



  if (salesOrder != null && salesOrder.isNotEmpty) {
    final childConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) => json['message'] as List<dynamic>,
      reqParams: {
        'doctype': 'Logistic Planning and Confirmation Lines',
        'parent':'Vehicle Reporting and Dispatch Loading',
        'filters': jsonEncode([
          ['sales_order', '=', salesOrder],
          ['parenttype', '=', 'Vehicle Reporting and Dispatch Loading']
        ]),
        'fields': jsonEncode(['parent']), 
        'limit_page_length': 'None'
      },
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    final childResponse = await get(childConfig);


final result = childResponse.process((r) => right(r.data ?? []));

    if (result.isLeft()) {
      return right([]);
    }

    final childData = result.getOrElse(() => []);

    final parentList = (childData)
        .map((e) => e['parent'])
        .where((e) => e != null)
        .toSet()
        .toList();

    if (parentList.isEmpty) {
      return right([]);
    }


    filters.add(['name', 'in', parentList]);
  }



  if (salesOrder == null || salesOrder.isEmpty) {
    

    if (docStatus.isNotNull && docStatus != '4' && docStatus != '1') {
      filters
        ..add(['status', '=', docStatus])
        ..add(['docstatus', '!=', 1]);
    } else if (docStatus == '1') {
      filters.add(['docstatus', '=', 1]);
    }


    if (search != null && search.isNotEmpty) {
      filters.add(['name', 'like', '%$search%']);
    }


    final users = $sl.get<LoggedInUser>();
    final hasRole = users.roles!.any((r) => r.role == 'Admin Role-SH');

    final plantName = user().plantName;

    if (!hasRole && plantName != null && plantName.isNotEmpty) {
      filters.add(['plant_name', '=', plantName]);
    }
  }



  $logger.devLog('FINAL FILTERS ---> $filters');



  final requestConfig = RequestConfig(
    url: Urls.getList,
    parser: (json) {
      final data = json['message'] as List<dynamic>;
      return data.map((e) => LoadingCnfmForm.fromJson(e)).toList();
    },
    reqParams: {
      'filters': jsonEncode(filters),
      'limit_start': start,
      'limit_page_length': 'None',
      'order_by': 'creation desc',
      'doctype': 'Vehicle Reporting and Dispatch Loading',
      'fields': jsonEncode(['*']),
    },
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    },
  );

  final response = await get(requestConfig);

  return response.process((r) => right(r.data!));
}


  @override
  AsyncValueOf<List<ItemModel>> fetchItemList(
    List<LogisticModel> salesOrders,
  ) async {
    return await executeSafely(() async {
      final salesOrderIds =
          salesOrders
              .where((e) => e.name != null && e.name!.isNotEmpty)
              .map((e) => e.name!)
              .toList();

      final config = RequestConfig(
        url: Urls.getList,
        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          final items = listdata.map((e) => ItemModel.fromJson(e)).toList();
          $logger.devLog(
            'Fetched ${items.length} items for ${salesOrderIds.length} sales orders: $salesOrderIds',
          );
          return items;
        },

        body: jsonEncode({
          'filters': [
            ['parent', 'in', salesOrderIds],
          ],
          'limit_start': 0,
          'limit_page_length': 'None',
          'order_by': 'creation desc',
          'doctype': 'SAP Sales Order Items',
          'parent': 'SAP Sales Order',
          'fields': ['*'],
        }),

        // reqParams:
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      $logger.devLog('Fetching items for: $salesOrderIds');

      final response = await post(config);
      return response.processAsync((r) async => right(r.data!));
    });
  }

  @override
  AsyncValueOf<Pair<String, String>> createLoadingCnfm(
    List<ItemModel> items,
    String name,
  ) async {
    final cleanedItems = await Future.wait(
      items.map((e) async {
        final map = removeNullValues(e.toJson());

        if (map.containsKey('sample_quantity')) {
          map['qty_loaded'] = map['sample_quantity'];
          map.remove('sample_quantity');
        }

        if (e.imageFile != null) {
          final compressed = await FlutterImageCompress.compressWithFile(
            e.imageFile!.path,
            quality: 50,
          );

          map['loaded_item_photo'] =
              compressed == null ? null : base64Encode(compressed);
        } else if (e.loadedItemPhoto != null && e.loadedItemPhoto!.isNotEmpty) {
          try {
            final base = Urls.baseUrl.replaceAll('/api', '');
            final uri = Uri.parse('$base${e.loadedItemPhoto}');

            final response = await http.get(uri);
            if (response.statusCode == 200) {
              map['loaded_item_photo'] = base64Encode(response.bodyBytes);
            } else {
              map['loaded_item_photo'] = null;
            }
          } catch (err) {
            map['loaded_item_photo'] = null;
          }
        }

        return map;
      }),
    );

    final cleanedJson = {'name': name, 'items': cleanedItems};

    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.createLoadingConfirmation,
        parser: (json) {
          final message = json['message']['message'] as String;
          return Pair(message, '');
        },
        body: jsonEncode(cleanedJson),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      final response = await post(config);
      $logger.devLog('createloading.......$config');
      return response.processAsync((r) async => right(r.data!));
    });
  }

  @override
  AsyncValueOf<Pair<String, String>> updateLoadingCnfm(
    List<ItemModel> items,
    String name,
  ) async {


    final cleanedItems = await Future.wait(
      items.map((e) async {
        final map = removeNullValues(e.toJson());

        if (map.containsKey('sample_quantity')) {
          map['qty_loaded'] = map['sample_quantity'];
          map.remove('sample_quantity');
        }

        if (e.name != null && e.name!.isNotEmpty) {
          map['name'] = e.name;
          map['item_row_name'] = e.name;
        } else {
          map['name'] = '';
          map['item_row_name'] = '';
        }

        if (e.imageFile != null) {
          final compressed = await FlutterImageCompress.compressWithFile(
            e.imageFile!.path,
            quality: 50,
          );
          map['loaded_item_photo'] =
              compressed == null ? null : base64Encode(compressed);
        } else if (e.loadedItemPhoto != null && e.loadedItemPhoto!.isNotEmpty) {
          try {
            final base = Urls.baseUrl.replaceAll('/api', '');
            final uri = Uri.parse('$base${e.loadedItemPhoto}');
            final response = await http.get(uri);
            if (response.statusCode == 200) {
              map['loaded_item_photo'] = base64Encode(response.bodyBytes);
            } else {
              map['loaded_item_photo'] = null;
            }
          } catch (_) {
            map['loaded_item_photo'] = null;
          }
        }


        map.removeWhere(
          (key, value) =>
              value == null ||
              (value is String && value.trim().isEmpty) ||
              value == 'null',
        );
        return map;
      }),
    );

    final cleanedJson = {'vr_name': name, 'items': cleanedItems};

    $logger.devLog('updateLoadingCnfm payload: ${jsonEncode(cleanedJson)}');

    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.updateLoading,
        parser: (json) {
          final message = json['message']['message'] as String;
          return Pair(message, '');
        },
        body: jsonEncode(cleanedJson),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      final response = await post(config);
      $logger.devLog('updatelodaing.........$config');
      return response.processAsync((r) async => right(r.data!));
    });
  }

  @override
  AsyncValueOf<List<LogisticModel>> fetchLogisticList(String name) async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => LogisticModel.fromJson(e)).toList();
        },
        reqParams: {
          'filters': [
            ['parent', '=', name],
          ],
          'limit_start': 0,
          'limit_page_length': 'None',
          'oreder_by': 'creat desc',
          'doctype': 'Logistic Planning and Confirmation Lines',
          'parent': 'Vehicle Reporting and Dispatch Loading',
          'fields': ['*'],
        },

        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      final response = await get(config);
      $logger.devLog('response.....$response');
      return response.processAsync((r) async {
        return right((r.data!));
      });
    });
  }

  @override
  AsyncValueOf<Pair<String, String>> submitLoading(String name) async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.submitLoadingConfirmation,
        parser: (json) {
          final data = json['message']['message'] as String;
          return Pair(data, '');
        },
        body: jsonEncode({'name': name}),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      $logger.devLog('requestConfig.....$config');

      final response = await post(config);

      return response.processAsync((r) async {
        return right(r.data!);
      });
    });
  }

  @override
  AsyncValueOf<List<ItemModel>> getItems(String name) async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.getLodedItems,

        parser: (json) {
          final data = json['message']['data'];
          final listdata = data as List<dynamic>;

          return listdata
              .map(
                (e) => ItemModel.fromJson(
                  e,
                ).copyWith(itemrowName: e['name'] ?? ''),
              )
              .toList();
        },

        reqParams: {'docname': name},
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      $logger.devLog('Itemlist config.....$config');
      final response = await get(config);

      $logger.devLog('Itemlist response.....$response');

      return response.processAsync((r) async {
        return right((r.data!));
      });
    });
  }
}
