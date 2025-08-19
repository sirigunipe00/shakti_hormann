import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/transport_confirmation/data/transport_confrimation_repo.dart';
import 'package:shakti_hormann/features/transport_confirmation/model/transport_confirmation_form.dart';

@LazySingleton(as: TransportConfrimationRepo)
class TransportCnfrmRepoimpl extends BaseApiRepository
    implements TransportConfrimationRepo {
  const TransportCnfrmRepoimpl(super.client);

  @override
  AsyncValueOf<List<TransportConfirmationForm>> fetchTransports(
    int start,
    String? status,
    String? serach,
  ) async {
      final filters = <List<dynamic>>[];

  if (status != null && status != 4) {
    filters.add(['status', '=', status]);
  }

  if (serach != null && serach.isNotEmpty) {
    filters.add(['name', 'like', '%$serach%']); 
  }
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'];
        final listdata = data as List<dynamic>;
        return listdata
            .map((e) => TransportConfirmationForm.fromJson(e))
            .toList();
      },
      reqParams: {
        'filters': jsonEncode(filters),
        'limit_start': start,
        'limit': 20,
        'order_by': 'creation desc',
        'doctype': 'Logistic Planning and Confirmation',
        'fields': ['*'],
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    $logger.devLog('requestConfig....$requestConfig');
    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<Pair<String, String>> submitTransport(
    TransportConfirmationForm form,
  ) async {
    return await executeSafely(() async {
      String formatEstimatedArrival(String time) {
        final now = DateTime.now();
        final parts = time.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final dateTime = DateTime(now.year, now.month, now.day, hour, minute);
        return DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);
      }

      final config = RequestConfig(
        url: Urls.updateTransport,
        parser: (json) {
          final data = json['message']['data']['logistic_request_id'] as String;
          return Pair(data, '');
        },

        body: jsonEncode({
          'logistic_request_id': form.name,
          'status': 'Transporter Confirmed',
          'transporter_confirmation_date': form.requestedDeliveryDate,
          'driver_name': form.driverName,
          'vehicle_number': form.vehicleNumber,
          'estimated_arrival': formatEstimatedArrival(
            form.estimatedArrival ?? '',
          ),

          'driver_contact': form.driverContact,
          'transporter_remarks': form.transporterRemarks,
        }),

        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      $logger.devLog('requestConfig.....$config');

      final response = await post(config);

      $logger.devLog('response.....$response');

      return response.processAsync((r) async {
        return right(r.data!);
      });
    });
  }

  @override
  AsyncValueOf<Pair<String, String>> rejectTransport(
    TransportConfirmationForm form,
  ) async {
    return await executeSafely(() async {
      $logger.devLog(form);
      final formData = removeNullValues(form.toJson());
      const keysToRemove = ['name', 'creation', 'modified', 'modified_by'];
      for (String key in keysToRemove) {
        formData.remove(key);
      }

      final requestConfig = RequestConfig(
        url: Urls.updateTransport,
        parser: (json) {
          final message = json['message']['message'] as String;
          return Pair(message, '');
        },
        body: jsonEncode({
          'logistic_request_id': form.name,
          'status': 'Transporter Rejected',
          'reject_reason': form.rejectReason,
        }),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      $logger.devLog(requestConfig);

      final response = await post(requestConfig);
      return response.process((r) => right(r.data!));
    });
  }
}
