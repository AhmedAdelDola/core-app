import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class EmulatorDetectionService {
  Future<bool> isEmulator() async {
    if (!Platform.isAndroid) return false;
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      if (!info.isPhysicalDevice) return true;
      final brand = info.brand.toLowerCase();
      final model = info.model.toLowerCase();
      final fingerprint = info.fingerprint.toLowerCase();
      if (brand.contains('generic') || brand == 'unknown') return true;
      if (fingerprint.contains('generic') || fingerprint.contains('test-keys')) return true;
      if (model.contains('emulator') || model.contains('sdk_gphone') || 
          model.contains('android sdk built for x86')) return true;
      return false;
    } catch (_) {
      return false;
    }
  }
}
