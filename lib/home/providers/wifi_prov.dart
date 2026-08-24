import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final wifiSsidProv = Provider((ref) => 'smartdoorV1');

final connectedProv = StateProvider((ref) => false);
