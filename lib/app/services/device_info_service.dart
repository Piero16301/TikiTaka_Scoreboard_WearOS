import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfoService {
  DeviceInfoService();

  late final AndroidDeviceInfo _androidInfo;
  late final PackageInfo _packageInfo;

  Future<void> initialize() async {
    _androidInfo = await DeviceInfoPlugin().androidInfo;
    _packageInfo = await PackageInfo.fromPlatform();
  }

  AndroidDeviceInfo get androidInfo => _androidInfo;

  PackageInfo get packageInfo => _packageInfo;
}
