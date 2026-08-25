import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

class Config {
  int connTimeout, doorTimeout;

  static const configFile = 'config.json';

  static Config fromDir(String dir) {
    final conf = File(path.join(dir, configFile));
    if (!conf.existsSync()) return Config();
    final confJson = Map<String, dynamic>.from(
      jsonDecode(conf.readAsStringSync()) as Map,
    );
    return Config(
      doorTimeout: confJson['doorTimeout'] ?? 2000,
      connTimeout: confJson['connTimeout'] ?? 2000,
    );
  }

  Config({this.connTimeout = 2000, this.doorTimeout = 2000});

  void saveToDir(String dir) {
    final conf = File(path.join(dir, configFile));
    conf.writeAsStringSync(
      jsonEncode({'connTimeout': connTimeout, 'doorTimeout': doorTimeout}),
      flush: true,
    );
  }
}
