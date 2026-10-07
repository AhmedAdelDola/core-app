import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class HeadphoneDetectorService {
  static const MethodChannel _channel = MethodChannel('elhanbly/headphone_detector');

  static final List<void Function(bool isConnected)> _listeners = [];
  static bool _initialized = false;
  static bool _isCurrentlyConnected = false;

  static bool get isCurrentlyConnected => _isCurrentlyConnected;

  /// Initializes the method call listener for headphone state changes
  static void init() {
    if (_initialized || kIsWeb) return;
    _initialized = true;

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onHeadphonesStateChanged') {
        final bool isConnected = (call.arguments as bool?) ?? false;
        _isCurrentlyConnected = isConnected;
        for (final listener in List.of(_listeners)) {
          try {
            listener(isConnected);
          } catch (e) {
            debugPrint('Error in headphone listener: $e');
          }
        }
      }
    });
  }

  /// Adds a listener that triggers whenever headphones or AirPods connect or disconnect
  static void addListener(void Function(bool isConnected) listener) {
    init();
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  /// Removes a headphone listener
  static void removeListener(void Function(bool isConnected) listener) {
    _listeners.remove(listener);
  }

  /// Checks if wired headphones, Bluetooth headset, or AirPods are connected
  static Future<bool> isHeadphonesConnected() async {
    if (kIsWeb) return true;
    init();
    try {
      final res = await _channel.invokeMethod<bool>('isHeadphonesConnected');
      _isCurrentlyConnected = res ?? false;
      return _isCurrentlyConnected;
    } catch (e) {
      debugPrint('Error checking isHeadphonesConnected: $e');
      return true; // Default fallback to allow playback in case of channel issues
    }
  }
}
