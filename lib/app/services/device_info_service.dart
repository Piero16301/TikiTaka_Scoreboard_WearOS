import 'dart:async';

import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class DeviceInfoService {
  DeviceInfoService({required DeviceInfoRepository deviceInfoRepository})
      : _deviceInfoRepository = deviceInfoRepository;

  final DeviceInfoRepository _deviceInfoRepository;

  Future<void> initialize() async {
    final performance = getIt<PerformanceService>();
    final trace = performance.startTrace('device_info_service_initialization');
    await _deviceInfoRepository.initialize();
    performance.stopTrace(trace);
  }

  AppDeviceInfo get deviceInfo => _deviceInfoRepository.deviceInfo;

  AppPackageInfo get packageInfo => _deviceInfoRepository.packageInfo;
}
