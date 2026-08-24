import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

class Config {
  bool watchTutorial;
  int timeout;

  static const configFile = 'config.json';

  static Config fromDir(String dir) {
    final conf = File(path.join(dir, configFile));
    if (!conf.existsSync()) return Config(watchTutorial: false, timeout: 2);
    final confJson = Map<String, dynamic>.from(
      jsonDecode(conf.readAsStringSync()) as Map,
    );
    return Config(
      watchTutorial: confJson['watchTutorial'] ?? false,
      timeout: confJson['timeout'] ?? 2,
    );
  }

  Config({required this.watchTutorial, required this.timeout});

  void saveToDir(String dir) {
    final conf = File(path.join(dir, configFile));
    conf.writeAsStringSync(
      jsonEncode({'watchTutorial': watchTutorial, 'timeout': timeout}),
      flush: true,
    );
  }
}
