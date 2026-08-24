import 'package:flutter/material.dart';
import 'package:smartdoor/settings/widgets/settings_form.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings'), centerTitle: true),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Padding(padding: EdgeInsets.all(10), child: SettingsForm()),
        ),
      ),
    );
  }
}
