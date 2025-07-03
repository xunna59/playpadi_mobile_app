import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

Future<Map<String, String>> getDeviceInfo() async {
  final deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    return {
      'type': 'Android',
      'name': '${androidInfo.manufacturer} ${androidInfo.model}',
    };
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return {'type': 'iOS', 'name': '${iosInfo.name} ${iosInfo.model}'};
  } else {
    return {'type': 'Unknown', 'name': 'Unknown Device'};
  }
}
