import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartdoor/home/api/door_api.dart';
import 'package:smartdoor/home/providers/timeout_prov.dart';
import 'package:smartdoor/home/providers/wifi_prov.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final adminCtrl = TextEditingController();
    final secretCtrl = TextEditingController();
    final userCtrl = TextEditingController();

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          TextFormField(
            controller: adminCtrl,
            decoration: InputDecoration(hintText: 'Admin'),
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.next,
          ),
          TextFormField(
            controller: secretCtrl,
            decoration: InputDecoration(hintText: 'Secret'),
            textAlign: TextAlign.center,
            obscureText: true,
            textInputAction: TextInputAction.next,
          ),
          TextFormField(
            controller: userCtrl,
            decoration: InputDecoration(hintText: 'Username'),
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.done,
          ),
          Spacer(),
          _SendButton(
            adminCtrl: adminCtrl,
            secretCtrl: secretCtrl,
            userCtrl: userCtrl,
          ),
        ],
      ),
    );
  }
}

class _SendButton extends ConsumerStatefulWidget {
  const _SendButton({
    required this.adminCtrl,
    required this.secretCtrl,
    required this.userCtrl,
  });

  final TextEditingController adminCtrl;
  final TextEditingController secretCtrl;
  final TextEditingController userCtrl;

  @override
  ConsumerState<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends ConsumerState<_SendButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final connected = ref.watch(connectedProv);

    return ElevatedButton(
      style: ButtonStyle(
        elevation: WidgetStatePropertyAll(2),
        backgroundColor: WidgetStatePropertyAll(
          connected
              ? ColorScheme.of(context).primaryContainer
              : ColorScheme.of(context).surfaceBright,
        ),
      ),
      onPressed: connected
          ? () async {
              setState(() {
                loading = true;
              });
              String status = '';
              try {
                final cookie = await DoorApi.register(
                  admin: widget.adminCtrl.text,
                  secret: widget.secretCtrl.text,
                  username: widget.userCtrl.text,
                  timeout: ref.read(timeoutProv),
                );
                if (cookie == '' && context.mounted) {
                  status = 'Could not fetch cookie :<';
                } else {
                  final storage = FlutterSecureStorage(
                    // aOptions: AndroidOptions.biometric(),
                  );
                  await storage
                      .write(key: 'cookie', value: cookie)
                      .timeout(Duration(milliseconds: ref.read(timeoutProv)));
                  status = 'Registered!';
                }
              } on TimeoutException {
                status = 'Timeout!';
              } catch (e) {
                status = 'Error x-x';
              }
              if (mounted) {
                setState(() {
                  loading = false;
                });
              }
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(status)));
              }
            }
          : null,
      child: loading
          ? SizedBox.square(
              dimension: kDefaultFontSize * 1.5,
              child: CircularProgressIndicator(strokeCap: StrokeCap.round),
            )
          : Text('Send'),
    );
  }
}
