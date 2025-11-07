import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_exit/model/sales_invoice_form.dart';
import 'package:shakti_hormann/features/proof_of_delivery/data/pod_repo.dart';
import 'package:shakti_hormann/features/proof_of_delivery/model/proof_of_delivery.dart';

@LazySingleton(as: ProofOfDeliveryRepo)
class PodRepoImpl extends BaseApiRepository implements ProofOfDeliveryRepo {
  const PodRepoImpl(super.client);
  @override
  AsyncValueOf<List<ProofOfDelivery>> fetchPod(
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
         final plantName = user().plantName;
  if (plantName != null && plantName.isNotEmpty) {
    filters.add(['plant_name', '=', plantName]); 
   
  }
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'] as List<dynamic>;
        return data.map((e) => ProofOfDelivery.fromJson(e)).toList();
      },
      reqParams: {
        'filters': jsonEncode(filters),
        'limit_start': start,
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'Proof of Delivery',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig....$requestConfig');

    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<Pair<String, String>> createPod(ProofOfDelivery form) async {
    final formJson = form.toJson();

    formJson['status'] = 'Draft';

    Uint8List? podphotocompressedBytes;
    Uint8List? unloading1compressedBytes;
    Uint8List? unloading2compressedBytes;

    if (form.podPhotoImg != null) {
      final filePath = form.podPhotoImg!.path;
      podphotocompressedBytes = await FlutterImageCompress.compressWithFile(
        filePath,
        quality: 50,
      );
    } else if (form.podPhoto != null) {
      podphotocompressedBytes = await fetchAndConvertToBase64(
        form.podPhoto ?? '',
      );
    }

    if (form.unloadingPhotoImg1 != null) {
      final filePath = form.unloadingPhotoImg1!.path;
      unloading1compressedBytes = await FlutterImageCompress.compressWithFile(
        filePath,
        quality: 50,
      );
    } else if (form.unloadingPhoto1 != null) {
      unloading1compressedBytes = await fetchAndConvertToBase64(
        form.unloadingPhoto1 ?? '',
      );
    }

    if (form.unloadingPhotoImg2 != null) {
      final filePath = form.unloadingPhotoImg2!.path;
      unloading2compressedBytes = await FlutterImageCompress.compressWithFile(
        filePath,
        quality: 50,
      );
    } else if (form.unloadingPhoto2 != null) {
      unloading2compressedBytes = await fetchAndConvertToBase64(
        form.unloadingPhoto2 ?? '',
      );
    }

    final config = RequestConfig(
      url: Urls.createproofOfDelivery,
      parser: (json) {
        final data = json['message']['data']['name'] as String;
        return Pair(data, '');
      },

      body: jsonEncode({
        'plant_name': form.plantName,
        'pod_date': form.podDate,
        'sales_invoice_no': form.salesInvoice,
        'sales_invoice_date': form.salesInvoiceDate,
        'geo_longitude': form.geoLongitude,
        'geo_latitude': form.geoLatitude,
        'pod_photo':
            podphotocompressedBytes == null
                ? null
                : base64Encode(podphotocompressedBytes),
        'unloading_photo_1':
            unloading1compressedBytes == null
                ? null
                : base64Encode(unloading1compressedBytes),
        'unloading_photo_2':
            unloading2compressedBytes == null
                ? null
                : base64Encode(unloading2compressedBytes),
      }),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig.....$config');

    final response = await post(config);
    return response.processAsync((r) async {
      return right(Pair(r.data!.first, r.data!.second));
    });
  }

  @override
  AsyncValueOf<Pair<String, String>> submitPod(ProofOfDelivery form) async {
    final formJson = form.toJson();
    formJson['status'] = 'Draft';

    Uint8List? podphotocompressedBytes;
    Uint8List? unloading1compressedBytes;
    Uint8List? unloading2compressedBytes;

    if (form.podPhotoImg != null) {
      final filePath = form.podPhotoImg!.path;
      podphotocompressedBytes = await FlutterImageCompress.compressWithFile(
        filePath,
        quality: 50,
      );
    } else if (form.podPhoto != null) {
      podphotocompressedBytes = await fetchAndConvertToBase64(
        form.podPhoto ?? '',
      );
    }

    if (form.unloadingPhotoImg1 != null) {
      final filePath = form.unloadingPhotoImg1!.path;
      unloading1compressedBytes = await FlutterImageCompress.compressWithFile(
        filePath,
        quality: 50,
      );
    } else if (form.unloadingPhoto1 != null) {
      unloading1compressedBytes = await fetchAndConvertToBase64(
        form.unloadingPhoto1 ?? '',
      );
    }

    if (form.unloadingPhotoImg2 != null) {
      final filePath = form.unloadingPhotoImg2!.path;
      unloading2compressedBytes = await FlutterImageCompress.compressWithFile(
        filePath,
        quality: 50,
      );
    } else if (form.unloadingPhoto2 != null) {
      unloading2compressedBytes = await fetchAndConvertToBase64(
        form.unloadingPhoto2 ?? '',
      );
    }

    final config = RequestConfig(
      url: Urls.submitproofOfDelivery,
      parser: (json) {
        final message = json['message'] as Map<String, dynamic>;
        final data = message['data'] as Map<String, dynamic>;
        final docName = data['name'] as String;
        final msg = message['message'] as String? ?? '';
        return Pair(docName, msg);
      },
      body: jsonEncode({
        'docname': form.name,
        'plant_name': form.plantName,
        'pod_date': form.podDate,
        'sales_invoice_no': form.salesInvoice,
        'sales_invoice_date': form.salesInvoiceDate, 
        'geo_longitude': form.geoLongitude,
        'geo_latitude': form.geoLatitude,
        'pod_photo':
            podphotocompressedBytes == null
                ? null
                : base64Encode(podphotocompressedBytes),
        'unloading_photo_1':
            unloading1compressedBytes == null
                ? null
                : base64Encode(unloading1compressedBytes),
        'unloading_photo_2':
            unloading2compressedBytes == null
                ? null
                : base64Encode(unloading2compressedBytes),
      }),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig.....$config');

    final response = await post(config);
    return response.processAsync((r) async {
      return right(r.data!);
    });
  }

  @override
  AsyncValueOf<List<SalesInvoiceForm>> fetchSalesInvoice(String name) async {
    return await executeSafely(() async {
       final plantName = user().plantName;
      //  final filters = <List<dynamic>>[];

   

      final reqParams = {
         'filters': [
          ['pod', '=', '0'],
          if (plantName != null && plantName.isNotEmpty)
            ['company', '=', plantName],
        ],
        'limit_start': 0,
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'SAP Sales Invoice',
       'fields': jsonEncode(['*']),   
     
      };

   

      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => SalesInvoiceForm.fromJson(e)).toList();
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

Future<Uint8List?> fetchAndConvertToBase64(String relativePath) async {
  if (p.extension(relativePath).isEmpty) {
    return null;
  }

  final String url = Urls.filepath(relativePath);

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load file: ${response.statusCode}');
  }
}

}
