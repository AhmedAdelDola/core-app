import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ScreenSecurityService {
  static const MethodChannel _channel = MethodChannel(
    'elhanbly/screen_security',
  );

  static final List<void Function(bool isRecording)> _listeners = [];
  static bool _initialized = false;
  static bool _isCurrentlyRecording = false;

  static bool get isCurrentlyRecording => _isCurrentlyRecording;

  /// Initializes the method call listener for screen recording changes
  static void init() {
    if (_initialized || kIsWeb) return;
    _initialized = true;

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onScreenRecordingChanged') {
        final bool isRecording = (call.arguments as bool?) ?? false;
        _isCurrentlyRecording = isRecording;
        for (final listener in List.of(_listeners)) {
          try {
            listener(isRecording);
          } catch (e) {
            debugPrint('Error in screen security listener: $e');
          }
        }
      }
    });
  }

  /// Adds a listener that triggers whenever screen recording starts or stops
  static void addListener(void Function(bool isRecording) listener) {
    init();
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  /// Removes a screen recording listener
  static void removeListener(void Function(bool isRecording) listener) {
    _listeners.remove(listener);
  }

  /// Checks if screen recording or screen mirroring is currently active
  static Future<bool> isScreenRecording() async {
    if (kIsWeb) return false;
    init();
    try {
      final res = await _channel.invokeMethod<bool>('isScreenRecording');
      _isCurrentlyRecording = res ?? false;
      return _isCurrentlyRecording;
    } catch (e) {
      debugPrint('Error checking isScreenRecording: $e');
      return false;
    }
  }

  /// Enables FLAG_SECURE (video blackout) and ALLOW_CAPTURE_BY_NONE (audio mute in recording)
  static Future<void> enable() async {
    if (kIsWeb) return;
    init();

    try {
      await _channel.invokeMethod<void>('enable');
    } on PlatformException catch (error) {
      debugPrint('Unable to enable screen security: ${error.message}');
    } on MissingPluginException {
      debugPrint('Screen security channel is not available on this platform.');
    }
  }

  /// Disables FLAG_SECURE and restores default audio capture policy
  static Future<void> disable() async {
    if (kIsWeb) return;

    try {
      await _channel.invokeMethod<void>('disable');
    } on PlatformException catch (error) {
      debugPrint('Unable to disable screen security: ${error.message}');
    } on MissingPluginException {
      debugPrint('Screen security channel is not available on this platform.');
    }
  }
}
