import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:smartdoor/home/api/door_api.dart';
import 'package:smartdoor/settings/providers/timeout_prov.dart';
import 'package:smartdoor/home/widgets/big_button.dart';
import 'package:smartdoor/home/widgets/network_alert.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SmartDoor V1'),
        centerTitle: true,
        actionsPadding: EdgeInsets.symmetric(horizontal: 8),
        actions: [
          IconButton(
            onPressed: () async {
              await Future.delayed(Duration(milliseconds: 200));
              if (context.mounted) {
                Navigator.pushNamed(context, '/registration');
              }
            },
            icon: Icon(Symbols.admin_panel_settings),
          ),
          IconButton(
            onPressed: () async {
              await Future.delayed(Duration(milliseconds: 200));
              if (context.mounted) {
                Navigator.pushNamed(context, '/settings');
              }
            },
            icon: Icon(Symbols.settings),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spacer(),
          SizedBox.square(
            dimension: kDefaultFontSize * 10,
            child: _LockButton(),
          ),
          Spacer(),
          NetworkAlert(),
        ],
      ),
    );
  }
}

class _LockButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BigButton(
      iconData: Symbols.lock,
      onPressed: () async {
        String status = '';
        try {
          final storage = FlutterSecureStorage(
            // aOptions: AndroidOptions.biometric(),
          );
          final cookie = await storage.read(key: 'cookie');
          if ((cookie == null || cookie.isEmpty) && context.mounted) {
            status = 'Register first!';
          } else {
            final ok = await DoorApi.unlock(
              cookie!,
              connTimeout: ref.read(connTimeoutProv),
              doorTimeout: ref.read(connTimeoutProv),
            );
            if (ok && context.mounted) {
              status = 'Unlocked!';
            } else if (context.mounted) {
              status = 'Could not unlock :<';
            }
          }
        } on TimeoutException {
          status = 'Timeout!';
        } on ClientException {
          status = 'Could not connect :<';
        } catch (e) {
          status = 'Error x-x';
        }
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(status)));
        }
      },
    );
  }
}
