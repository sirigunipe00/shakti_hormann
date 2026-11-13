import 'dart:convert';

class RestUtils {
  static Uri constructUri(String baseUrl, [Map<String, dynamic>? params]) {
    final url = baseUrl
        .replaceAll('https://', '')
        .replaceAll('http://', '');

    final Map<String, dynamic> urlParams = {};
    params?.forEach((key, value) {
      if (value is List) {
        // Nested filter lists (e.g. [["user","=","a@b.com"]]) must be JSON
        // encoded — Dart's `is List<List<String?>>` check is unreliable here
        // and previously dropped filters entirely.
        urlParams[key] = jsonEncode(value);
      } else {
        urlParams[key] = value;
      }
    });
    final encodedParams = encodeParams(urlParams);
    final scheme = baseUrl.startsWith('http://') ? 'http' : 'https';
    final fullUrl = '$scheme://$url$encodedParams';
    return Uri.parse(fullUrl);
  }

  static String encodeParams(Map<String, dynamic> params) {
    var s = '';
    params.forEach((key, value) {
      final urlEncode = Uri.encodeComponent(value.toString());
      s += '${s == '' ? '?' : '&'}$key=$urlEncode';
    });

    return s;
  }
}
