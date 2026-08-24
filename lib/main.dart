import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smartdoor/home/pages/home_page.dart';
import 'package:smartdoor/home/providers/timeout_prov.dart';
import 'package:smartdoor/main_theme.dart';
import 'package:smartdoor/registration/pages/registration_page.dart';
import 'package:smartdoor/settings/api/config.dart';
import 'package:smartdoor/settings/pages/settings_page.dart';

Future<void> main() async {
  final appdir = await getApplicationSupportDirectory();
  final conf = Config.fromDir(appdir.path);
  runApp(
    ProviderScope(
      overrides: [timeoutProv.overrideWith((ref) => conf.timeout * 1000)],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MainTheme.lightTheme,
      darkTheme: MainTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(),
        '/registration': (context) => RegistrationPage(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}
