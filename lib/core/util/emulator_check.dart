import 'package:flutter/services.dart';

class EmulatorCheck {
  static const MethodChannel _channel =
      MethodChannel('security/emulator_check');

  /// Returns true if native side thinks this device is an emulator.
  static Future<bool> isEmulator() async {
    try {
      final result = await _channel.invokeMethod<bool>('isEmulator');
      return result ?? false;
    } catch (e) {
      // If channel fails, assume not emulator (or you can choose to block)
      return false;
    }
  }
}
