import 'dart:convert';
import 'dart:io';

import 'package:shakti_hormann/core/consts/urls.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/logger/app_logger.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';

class FrappeSessionResult {
  const FrappeSessionResult({
    required this.sid,
    required this.host,
    required this.origin,
    required this.reportUrl,
    this.cookies = const {},
  });

  final String sid;
  final String host;
  final String origin;
  final Uri reportUrl;
  final Map<String, String> cookies;
}

/// Creates a Frappe desk session (`sid`) so WebViews can open `/app` pages
/// without prompting the user to log in again.
abstract final class FrappeSession {
  static const reportPath = '/app/where-is-my-material';

  static String get origin {
    final base = Urls.baseUrl.replaceAll(RegExp(r'/api/?$'), '');
    return base.endsWith('/') ? base.substring(0, base.length - 1) : base;
  }

  static Uri get reportUri => Uri.parse('$origin$reportPath');

  static Future<FrappeSessionResult> createDeskSession() async {
    if (!$sl.isRegistered<LoggedInUser>()) {
      throw StateError('No logged-in user available for ERPNext session.');
    }

    final user = $sl<LoggedInUser>();
    final usr = _resolveUsername(user);
    final pwd = user.password?.trim() ?? '';

    if (usr.isEmpty || pwd.isEmpty) {
      throw StateError(
        'Missing credentials for ERPNext session. Please log in again.',
      );
    }

    final loginUri = Uri.parse('$origin/api/method/login');
    final client = HttpClient();
    try {
      final request = await client.postUrl(loginUri);
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        'application/x-www-form-urlencoded',
      );
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.write(
        'usr=${Uri.encodeQueryComponent(usr)}&pwd=${Uri.encodeQueryComponent(pwd)}',
      );

      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      $logger.devLog(
        '[FrappeSession] login status=${response.statusCode} body=${body.length > 200 ? body.substring(0, 200) : body}',
      );

      final cookieMap = <String, String>{};
      for (final cookie in response.cookies) {
        if (cookie.name.isNotEmpty && cookie.value.isNotEmpty) {
          cookieMap[cookie.name] = cookie.value;
        }
      }
      final setCookie = response.headers[HttpHeaders.setCookieHeader];
      if (setCookie != null) {
        for (final raw in setCookie) {
          final match = RegExp(r'^\s*([^=;\s]+)=([^;]*)').firstMatch(raw);
          if (match != null) {
            cookieMap[match.group(1)!] = match.group(2)!;
          }
        }
      }

      final sid = cookieMap['sid'] ?? _extractSidFromBody(body);
      if (sid == null || sid.isEmpty || sid.toLowerCase() == 'guest') {
        $logger.error(
          '[FrappeSession] login failed status=${response.statusCode} body=$body',
        );
        throw StateError(
          'Could not open ERPNext session. Please check your credentials.',
        );
      }

      cookieMap['sid'] = sid;

      return FrappeSessionResult(
        sid: sid,
        host: loginUri.host,
        origin: origin,
        reportUrl: reportUri,
        cookies: cookieMap,
      );
    } finally {
      client.close(force: true);
    }
  }

  static String _resolveUsername(LoggedInUser user) {
    final candidates = [
      user.email,
      user.username,
      user.name,
    ];
    for (final value in candidates) {
      final trimmed = value?.trim() ?? '';
      if (trimmed.isNotEmpty) return trimmed;
    }
    return '';
  }

  static String? _extractSidFromBody(String body) {
    try {
      final json = jsonDecode(body);
      if (json is Map<String, dynamic>) {
        final message = json['message'];
        if (message is Map && message['sid'] is String) {
          return message['sid'] as String;
        }
        if (json['sid'] is String) {
          return json['sid'] as String;
        }
      }
    } catch (_) {}
    return null;
  }
}
