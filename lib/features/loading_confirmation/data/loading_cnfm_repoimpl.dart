import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
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

    if (docStatus != null && docStatus != '4') {
      filters
        ..add(['status', '=', docStatus])
        ..add(['docstatus', '!=', 2]);
    }

    if (serach != null && serach.isNotEmpty) {
      filters.add(['name', 'like', '%$serach%']);
    }
    filters.add(['status', '=', 'Reported']);
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
    LoadingCnfmForm form,
  ) async {
    return await executeSafely(() async {
    final config = RequestConfig(
        url: Urls.createLoadingConfirmation,
        parser: (json) {
          final data =
              json['message']['data']['name']
                  as String;
          return Pair(data, '');
        },
        body: jsonEncode({
          'name':form.name,
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
}
