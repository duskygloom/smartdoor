import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class DoorApi {
  static const deviceIp = '192.168.4.1';

  static Future<String> register({
    required String admin,
    required String secret,
    required String username,
    int timeout = 2000,
  }) async {
    try {
      final r = await http
          .post(
            Uri.http(deviceIp, '/register', {
              'admin': admin,
              'secret': secret,
              'user': username,
            }),
          )
          .timeout(Duration(milliseconds: timeout));
      if (r.statusCode == 200 && r.headers.containsKey('set-cookie')) {
        return r.headers['set-cookie'] as String;
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  static Future<bool> unlock(String cookie, [int timeout = 2000]) async {
    final r = await http
        .post(Uri.http(deviceIp, '/open'), headers: {'cookie': cookie})
        .timeout(
          Duration(milliseconds: timeout),
          onTimeout: () {
            throw TimeoutException('timeout', Duration(milliseconds: timeout));
          },
        );
    if (r.statusCode != 200) return false;
    final rjson = Map<String, String>.from(jsonDecode(r.body) as Map);
    return rjson['status'] == 'success';
  }
}
