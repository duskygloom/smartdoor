import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartdoor/home/providers/wifi_prov.dart';

class BigButton extends StatefulWidget {
  const BigButton({super.key, required this.iconData, required this.onPressed});

  final IconData iconData;
  final Future<void> Function() onPressed;

  @override
  State<BigButton> createState() => _BigButtonState();
}

class _BigButtonState extends State<BigButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shape: CircleBorder(),
      child: Consumer(
        builder: (context, ref, child) {
          final connected = ref.watch(connectedProv);
          final onPressedFn = connected
              ? () async {
                  setState(() {
                    loading = true;
                  });
                  await widget.onPressed();
                  if (mounted) {
                    setState(() {
                      loading = false;
                    });
                  }
                }
              : null;

          return IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                connected
                    ? ColorScheme.of(context).primaryContainer
                    : ColorScheme.of(context).surfaceBright,
              ),
              foregroundColor: WidgetStatePropertyAll(
                ColorScheme.of(context).onPrimaryContainer,
              ),
              shape: WidgetStatePropertyAll(CircleBorder()),
            ),
            onPressed: onPressedFn,
            icon: loading
                ? _SizedSpinner()
                : Icon(widget.iconData, size: kDefaultFontSize * 4),
            padding: EdgeInsets.all(kDefaultFontSize * 2),
          );
        },
      ),
    );
  }
}

class _SizedSpinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: kDefaultFontSize * 2,
      child: Center(
        child: CircularProgressIndicator(strokeCap: StrokeCap.round),
      ),
    );
  }
}
