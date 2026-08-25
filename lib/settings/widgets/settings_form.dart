import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smartdoor/settings/providers/timeout_prov.dart';
import 'package:smartdoor/settings/api/config.dart';
import 'package:smartdoor/settings/widgets/timeout_slider.dart';

class SettingsForm extends StatelessWidget {
  const SettingsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Door timeout', style: TextTheme.of(context).bodyLarge),
              _DoorTimeoutSlider(),
              SizedBox(height: 10),
              Text(
                'Connection timeout',
                style: TextTheme.of(context).bodyLarge,
              ),
              _ConnTimeoutSlider(),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConnTimeoutSlider extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = (ref.watch(connTimeoutProv) / 1000).clamp(2, 10);
    return TimeoutSlider(
      minLimit: 2,
      maxLimit: 10,
      value: value.toDouble(),
      divisions: 4,
      onChanged: (value) async {
        ref.read(connTimeoutProv.notifier).state = value.toInt() * 1000;
        getApplicationSupportDirectory().then((dir) {
          final conf = Config.fromDir(dir.path)
            ..connTimeout = value.toInt() * 1000;
          conf.saveToDir(dir.path);
        });
      },
    );
  }
}

class _DoorTimeoutSlider extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = (ref.watch(doorTimeoutProv) / 1000).clamp(2, 10);
    return TimeoutSlider(
      minLimit: 2,
      maxLimit: 10,
      value: value.toDouble(),
      divisions: 4,
      onChanged: (value) async {
        ref.read(doorTimeoutProv.notifier).state = value.toInt() * 1000;
        getApplicationSupportDirectory().then((dir) {
          final conf = Config.fromDir(dir.path)
            ..doorTimeout = value.toInt() * 1000;
          conf.saveToDir(dir.path);
        });
      },
    );
  }
}
