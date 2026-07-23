import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/pallet_creation/data/pallet_repo.dart';
import 'package:shakti_hormann/features/pallet_creation/model/pallet_items.dart';
import 'package:shakti_hormann/features/pallet_creation/model/pallet_model.dart';

@LazySingleton(as: PalletRepo)
class PalletRepoImpl extends BaseApiRepository implements PalletRepo {
  PalletRepoImpl(super.dio);

  @override
  AsyncValueOf<List<PalletModel>> fetchPallet(
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
        return data.map((e) => PalletModel.fromJson(e)).toList();
      },
      reqParams: {
        'filters': jsonEncode(filters),
        'limit_start': start,
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'Pallet',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig....$requestConfig');

    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }
      @override
  AsyncValueOf<List<SalesOrderForm>> salesOrder() async {
    return await executeSafely(() async {
      final reqParams = {
        'limit_start': 0,
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'SAP Sales Order',
        'fields': ['*'],
        // 'filters': jsonEncode(filters),
      };

      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => SalesOrderForm.fromJson(e)).toList();
        },
        reqParams: reqParams,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      $logger.devLog('salesinvoice.....$config');
      final response = await get(config);
      return response.processAsync((r) async {
        return right((r.data!));
      });
    });
  }

  @override
  AsyncValueOf<Pair<String, String>> createPallet(
    PalletModel form,
    List<PalletItems> lines,
  ) async {
    final config = RequestConfig(
      url: Urls.createPallet,
      parser: (json) {
        final result = json['message'] as Map<String, dynamic>;
        final message = result['message'] as String? ?? '';
        final data = result['data'] as Map<String, dynamic>?;

        return Pair(message, data?['pallet_id'] as String? ?? '');
      },
      body: jsonEncode({
        'sales_order': form.salesOrder,
        'pallet_details':
            lines
                .map(
                  (e) => {
                    'product_type': e.productType,
                    'size': e.size,
                    'no_of_pallets': e.noOfPallets,
                  },
                )
                .toList(),
      }),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    final response = await post(config);
    $logger.devLog('config.....$config');

    return response.processAsync((r) async {
      return right(r.data!);
    });
  }

  @override
  AsyncValueOf<Pair<String, String>> updatePallet(
    PalletModel form,
    List<PalletItems> lines,
  ) async {
    final config = RequestConfig(
      url: Urls.updatePallet,
      parser: (json) {
        final result = json['message'] as Map<String, dynamic>;
        final message = result['message'] as String? ?? '';
        final data = result['data'] as Map<String, dynamic>?;

        return Pair(message, data?['pallet_id'] as String? ?? '');
      },
      body: jsonEncode({
        'pallet_id': form.name,
        'pallet_details':
            lines.map((e) {
              final map = <String, dynamic>{};
              if (e.idx != null) {
                map['idx'] = e.idx;
                map['no_of_pallets'] = e.noOfPallets;
              } else {
                map['product_type'] = e.productType;
                map['size'] = e.size;
                map['no_of_pallets'] = e.noOfPallets;
              }

              return map;
            }).toList(),
      }),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    final response = await post(config);
    $logger.devLog('config.....$config');

    return response.processAsync((r) async {
      return right(r.data!);
    });
  }

  @override
  AsyncValueOf<List<PalletItems>> fetchPalletItems(String name) async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => PalletItems.fromJson(e)).toList();
        },
        reqParams: {
          'filters': [
            ['parent', '=', name],
          ],
          'limit_start': 0,
          'limit_page_length': 'None',
          'oreder_by': 'creat desc',
          'doctype': 'Pallet Details',
          'parent': 'Pallet',
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
}
