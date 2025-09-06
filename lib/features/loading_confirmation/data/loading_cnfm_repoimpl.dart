import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/loading_confirmation/data/loading_cnfm_repo.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/item_model.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/loading_cnfm.dart';

@LazySingleton(as: LoadingCnfmRepo)
class LoadingCnfmRepoimpl extends BaseApiRepository implements LoadingCnfmRepo {
  const LoadingCnfmRepoimpl(super.client);

  @override
  AsyncValueOf<List<LoadingCnfmForm>> fetchLoadingList(
    int start,
    String? docStatus,
    String? serach,
  ) async {
    final filters = <List<dynamic>>[];


    if (docStatus.isNotNull && docStatus != '4' && docStatus != '1') {
      filters
        ..add(['status', '=', docStatus])
        ..add(['docstatus', '!=',  1]);
    } else if( docStatus == '1') {
      filters
        .add(['docstatus', '=',  1]);

    }

    if (serach != null && serach.isNotEmpty) {
      filters.add(['name', 'like', '%$serach%']);
    }
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'];
        final listdata = data as List<dynamic>;
        return listdata.map((e) => LoadingCnfmForm.fromJson(e)).toList();
      },
      reqParams: {
        'filters': jsonEncode(filters),
        'limit_start': start,
        'limit': 20,
        'order_by': 'creation desc',
        'doctype': 'Vehicle Reporting and Dispatch Loading',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    $logger.devLog('requestConfig....$requestConfig');
    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<List<ItemModel>> fetchItemList(String name) async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => ItemModel.fromJson(e)).toList();
        },
        reqParams: {
          'limit': 20,
          'order_by': 'creation desc',
          'doctype': 'Item',
          'fields': ['*'],
        },
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      $logger.devLog('Itemlist.....$config');
      final response = await get(config);
      return response.processAsync((r) async {
        return right((r.data!));
      });
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
          final vehiclefrontcompressedBytes =
              await FlutterImageCompress.compressWithFile(
                e.imageFile!.path,
                quality: 50,
              );

          map['loaded_item_photo'] =
              vehiclefrontcompressedBytes == null
                  ? null
                  : base64Encode(vehiclefrontcompressedBytes);
        } else if (e.loadedItemPhoto != null && e.loadedItemPhoto!.isNotEmpty) {
          try {
            final baseUrl = 'http://65.21.243.18:8000';
            final uri = Uri.parse('$baseUrl${e.loadedItemPhoto}');

            final response = await http.get(uri);
            if (response.statusCode == 200) {
              final bytes = response.bodyBytes;
              map['loaded_item_photo'] = base64Encode(bytes);
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

    final cleanedJson = removeNullValues({'name': name, 'items': cleanedItems});
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.createLoadingConfirmation,
        parser: (json) {
          final data = json['message']['message'] as String;
          return Pair(data, '');
        },
        body: jsonEncode(cleanedJson),
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
  AsyncValueOf<Pair<String, String>> submitLoading(
    String name,
  ) async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.submitLoadingConfirmation,
        parser: (json) {
          final data = json['message']['message'] as String;
          return Pair(data, '');
        },
        body: jsonEncode({
          'name': name
        }),
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
          return listdata.map((e) => ItemModel.fromJson(e)).toList();
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
