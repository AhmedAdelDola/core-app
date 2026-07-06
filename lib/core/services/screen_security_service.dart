import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ScreenSecurityService {
  static const MethodChannel _channel = MethodChannel(
    'elhanbly/screen_security',
  );

  static Future<void> enable() async {
    if (kIsWeb) return;

    try {
      await _channel.invokeMethod<void>('enable');
    } on PlatformException catch (error) {
      debugPrint('Unable to enable screen security: ${error.message}');
    } on MissingPluginException {
      debugPrint('Screen security channel is not available on this platform.');
    }
  }
}
