import 'dart:convert';
import 'package:shakti_hormann/core/core.dart';

typedef ApiObjectParser<T> = T Function(Map<String, dynamic>);

abstract class ApiResponseParser<T> {
  ApiResponse<T> parse(
      String response, ApiObjectParser<T> parser, String defErrorMessage);
}

class FrappeApiResponseParser<T> implements ApiResponseParser<T> {
  @override
  ApiResponse<T> parse(
    String apiResponse,
    ApiObjectParser<T> parser,
    String defErrorMessage,
  ) {
    try {
      final response = json.decode(apiResponse) as Map<String, dynamic>;
      final message = response['message'];
      if (message is List<dynamic>) {
        final res = parser(response);
        return ApiResponse.success(res);
      }
      final messageObj = response['message'];
      if (messageObj is Map<String, dynamic>) {
        if (messageObj.containsKey('status')) {
          final status = messageObj['status'];
          // Some APIs return numeric 200; others return "success" (e.g. get_loaded_items).
          final isSuccess = status == 200 ||
              (status is String &&
                  status.toLowerCase() == 'success');
          if (isSuccess) {
            final result = parser(response);
            return ApiResponse.success(result);
          }
          final rawMessage = messageObj['message'];
          final code = messageObj['code'] as String?;
          final data = messageObj['data'];
          final popup =
              data is Map ? data['popup_message'] as String? : null;
          final buffer = StringBuffer(
            popup != null && popup.isNotEmpty
                ? popup
                : rawMessage is String && rawMessage.isNotEmpty
                ? rawMessage
                : defErrorMessage,
          );
          if (code == 'DUPLICATE_MES' &&
              data is Map &&
              data['existing_record'] != null) {
            buffer.write('\nExisting record: ${data['existing_record']}');
          }
          if (code == 'ALREADY_STORED' && data is Map) {
            final zone = data['current_zone'];
            if (zone != null && zone.toString().isNotEmpty) {
              buffer.write('\nCurrent zone: $zone');
            }
            buffer.write('\nUse Zone Transfer to move this pallet.');
          }
          if (code == 'SAME_ZONE' && data is Map) {
            final zone = data['current_zone'];
            if (zone != null && zone.toString().isNotEmpty) {
              buffer.write('\nCurrent zone: $zone');
            }
          }
          final mappedStatus = status == 409 ? 409 : 400;
          return ApiResponse.failure(buffer.toString(), status: mappedStatus);
        }
        if (response.containsKey('_server_messages')) {
          final serverMsgs =
              json.decode(response['_server_messages']) as List<dynamic>;
          if (serverMsgs.isNotEmpty) {
            final messageData = json.decode(serverMsgs.first);
            final errorMsg = messageData['message'];
            return ApiResponse.failure(errorMsg, status: 400);
          }
        }
      } else if (messageObj is String) {
        final result = parser(response);
        return ApiResponse.success(result);
      }

      final result = parser(response);
      return ApiResponse.success(result);
    } on Exception catch (e, st) {
      $logger.error('[ResponseParser]', e, st);
      throw Exception(e);
    }
  }
}

class Errors {
  static String get noInternet => 'Please check your internet connection';
  static String get emptyApiResponse => 'Received empty response from server';
  static String get defaultApiErrorMessage =>
      'Unfortunately something went wrong. Please try again a moment later';
  static String get unknown => 'Unknown error occurred';
  static String get connectionIssue =>
      'Could not connect to server. Please check your internet';
  static String get internalServerError => 'Internal Server Error';
  static String get unauthorized =>
      'Looks like you do not have access to this information';
  static String get invalidcredentials =>
      'Wrong credentials.\nInvalid Username or Password';
  static String get clientError =>
      'Unfortunately we could not complete the request.';
  static String get responseIsNotValidJson => 'Invalid json response';
  static String get unrecognizedResponse => 'Unsupported response format';
  static String get gatewayTimeout =>
      'Server is taking too long to respond. Please try again later.';
  // Login
  static String get invalidUser => 'Invalid User';
}
