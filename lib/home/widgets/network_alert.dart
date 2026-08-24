import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smartdoor/home/providers/timeout_prov.dart';
import 'package:smartdoor/home/providers/wifi_prov.dart';

class NetworkAlert extends ConsumerStatefulWidget {
  const NetworkAlert({super.key});

  @override
  ConsumerState<NetworkAlert> createState() => _NetworkAlertState();
}

class _NetworkAlertState extends ConsumerState<NetworkAlert> {
  late final conn = Connectivity();
  late final connStream = conn.onConnectivityChanged;
  late StreamSubscription<List<ConnectivityResult>> resultsListener;
  String? wifiName;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    resultsListener = connStream.listen((results) async {
      if (results.contains(ConnectivityResult.wifi)) {
        try {
          wifiName = await fetchWifiName(ref.read(timeoutProv));
          ref.read(connectedProv.notifier).state =
              wifiName == ref.read(wifiSsidProv);
          errorMessage = null;
        } catch (e) {
          if (e is TimeoutException) {
            errorMessage = 'Timeout!';
          } else if (e is StateError) {
            errorMessage = 'Location permission is required :<';
          } else {
            errorMessage = 'Failed to detect wifi :<';
          }
          ref.read(connectedProv.notifier).state = false;
        } finally {
          if (mounted) setState(() {});
        }
      } else {
        ref.read(connectedProv.notifier).state = false;
        if (mounted) {
          setState(() {
            wifiName = null;
            errorMessage = 'Turn on Wi-Fi';
          });
        }
      }
    });
  }

  @override
  void dispose() {
    resultsListener.cancel().then((_) {});
    super.dispose();
  }

  Future<String?> fetchWifiName(int timeout) async {
    final info = NetworkInfo();
    String? wifiName;
    if (Platform.isAndroid && await Permission.locationWhenInUse.isGranted) {
      wifiName = await info.getWifiName();
      wifiName = wifiName?.substring(1, wifiName.length - 1);
    } else if (Platform.isAndroid) {
      final status = await Permission.locationWhenInUse.request();
      if (status == PermissionStatus.granted) {
        wifiName = await info.getWifiName();
        wifiName = wifiName?.substring(1, wifiName.length - 1);
      } else {
        throw StateError('need location permission');
      }
    } else if (Platform.isLinux) {
      wifiName = await info.getWifiName();
    } else {
      throw UnimplementedError('feature not implemented for this os');
    }
    return wifiName;
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return _NetworkAlertContainer(
        text: errorMessage!,
        backgroundColor: ColorScheme.of(context).error,
        foregroundColor: ColorScheme.of(context).onError,
      );
    } else if (wifiName == ref.read(wifiSsidProv)) {
      return _NetworkAlertContainer(
        text: 'Connected to $wifiName!',
        backgroundColor: ColorScheme.of(context).primary,
        foregroundColor: ColorScheme.of(context).onPrimary,
      );
    } else {
      return _NetworkAlertContainer(
        text: 'Connect to ${ref.read(wifiSsidProv)}',
        backgroundColor: ColorScheme.of(context).error,
        foregroundColor: ColorScheme.of(context).onError,
      );
    }
  }
}

class _NetworkAlertContainer extends StatelessWidget {
  const _NetworkAlertContainer({
    required this.text,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String text;
  final Color backgroundColor, foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: backgroundColor,
      child: Text(
        text,
        style: TextTheme.of(
          context,
        ).bodyLarge?.copyWith(color: foregroundColor),
        textAlign: TextAlign.center,
      ),
    );
  }
}
