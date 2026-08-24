import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smartdoor/home/providers/timeout_prov.dart';
import 'package:smartdoor/settings/api/config.dart';

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
              Text('Timeout', style: TextTheme.of(context).bodyLarge),
              _TimeoutSlider(),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeoutSlider extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = (ref.watch(timeoutProv) / 1000).clamp(2, 10);
    return Column(
      children: [
        Slider(
          value: value.toDouble(),
          onChanged: (value) {
            ref.read(timeoutProv.notifier).state = value.toInt() * 1000;
            getApplicationSupportDirectory().then((dir) {
              final conf = Config.fromDir(dir.path)..timeout = value.toInt();
              conf.saveToDir(dir.path);
            });
          },
          min: 2,
          max: 10,
          divisions: 4,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('2'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  '${value.toInt()}s',
                  style: TextTheme.of(context).bodyLarge?.copyWith(
                    color: ColorScheme.of(context).primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text('10'),
            ],
          ),
        ),
      ],
    );
  }
}
