import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_entry_form.dart';
import 'package:shakti_hormann/features/hardware_packing/data/hardware_repo.dart';


@LazySingleton(as: HardWareRepo)
class HardWareRepoImp extends BaseApiRepository implements HardWareRepo{
  HardWareRepoImp(super.dio);

  @override
  AsyncValueOf<List<GateEntryForm>> fetchHardware(
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

    // final users = $sl.get<LoggedInUser>();
    // final hasRole = users.roles!.any((r) => r.role == 'Admin Role-SH');

    // final plantName = user().plantName;

    // if (!hasRole && plantName != null && plantName.isNotEmpty) {
    //   filters.add(['plant_name', '=', plantName]);
    // }
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'] as List<dynamic>;
        return data.map((e) => GateEntryForm.fromJson(e)).toList();
      },
      reqParams: {
        'filters': jsonEncode(filters),
        'limit_start': start,
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'Gate Entry',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig....$requestConfig');

    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }
    
  }
