import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ScreenSecurityState {
  final bool isRecording;
  final bool isMirroring;
  final bool isExternalDisplay;
  final bool isProtected;

  const ScreenSecurityState({
    this.isRecording = false,
    this.isMirroring = false,
    this.isExternalDisplay = false,
    this.isProtected = false,
  });

  bool get isCompromised => isRecording || isMirroring || isExternalDisplay;

  factory ScreenSecurityState.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return const ScreenSecurityState();
    return ScreenSecurityState(
      isRecording: (map['isRecording'] as bool?) ?? false,
      isMirroring: (map['isMirroring'] as bool?) ?? false,
      isExternalDisplay: (map['isExternalDisplay'] as bool?) ?? false,
      isProtected: (map['isProtected'] as bool?) ?? false,
    );
  }

  @override
  String toString() =>
      'ScreenSecurityState(isRecording: $isRecording, isMirroring: $isMirroring, isExternalDisplay: $isExternalDisplay, isProtected: $isProtected)';
}

class ScreenSecurityService {
  static const MethodChannel _channel = MethodChannel(
    'core_app/screen_security',
  );

  static final List<void Function(bool isRecording)> _recordingListeners = [];
  static final List<VoidCallback> _screenshotListeners = [];
  static final List<void Function(ScreenSecurityState state)> _stateListeners = [];

  static bool _initialized = false;
  static bool _isCurrentlyRecording = false;
  static ScreenSecurityState _currentState = const ScreenSecurityState();

  static bool get isCurrentlyRecording => _isCurrentlyRecording;
  static ScreenSecurityState get currentState => _currentState;

  /// Initializes the method call listener for screen recording, screenshot, and security state events
  static void init() {
    if (_initialized || kIsWeb) return;
    _initialized = true;

    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onScreenRecordingChanged':
          final bool isRecording = (call.arguments as bool?) ?? false;
          _isCurrentlyRecording = isRecording;
          for (final listener in List.of(_recordingListeners)) {
            try {
              listener(isRecording);
            } catch (e) {
              debugPrint('Error in screen security recording listener: $e');
            }
          }
          break;

        case 'onScreenshotTaken':
          for (final listener in List.of(_screenshotListeners)) {
            try {
              listener();
            } catch (e) {
              debugPrint('Error in screen security screenshot listener: $e');
            }
          }
          break;

        case 'onSecurityStateChanged':
          if (call.arguments is Map) {
            final state = ScreenSecurityState.fromMap(
              call.arguments as Map<dynamic, dynamic>,
            );
            _currentState = state;
            _isCurrentlyRecording = state.isCompromised;
            for (final listener in List.of(_stateListeners)) {
              try {
                listener(state);
              } catch (e) {
                debugPrint('Error in screen security state listener: $e');
              }
            }
          }
          break;

        default:
          break;
      }
    });
  }

  /// Adds a listener that triggers whenever screen recording starts or stops
  static void addListener(void Function(bool isRecording) listener) {
    init();
    if (!_recordingListeners.contains(listener)) {
      _recordingListeners.add(listener);
    }
  }

  /// Removes a screen recording listener
  static void removeListener(void Function(bool isRecording) listener) {
    _recordingListeners.remove(listener);
  }

  /// Adds a listener that triggers when a screenshot is taken
  static void addScreenshotListener(VoidCallback listener) {
    init();
    if (!_screenshotListeners.contains(listener)) {
      _screenshotListeners.add(listener);
    }
  }

  /// Removes a screenshot listener
  static void removeScreenshotListener(VoidCallback listener) {
    _screenshotListeners.remove(listener);
  }

  /// Adds a listener that triggers when full security state changes (recording, mirroring, external display)
  static void addSecurityStateListener(
    void Function(ScreenSecurityState state) listener,
  ) {
    init();
    if (!_stateListeners.contains(listener)) {
      _stateListeners.add(listener);
    }
  }

  /// Removes a security state listener
  static void removeSecurityStateListener(
    void Function(ScreenSecurityState state) listener,
  ) {
    _stateListeners.remove(listener);
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

  /// Gets complete security state from the native platform
  static Future<ScreenSecurityState> getSecurityState() async {
    if (kIsWeb) return const ScreenSecurityState();
    init();
    try {
      final res = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'getSecurityState',
      );
      final state = ScreenSecurityState.fromMap(res);
      _currentState = state;
      _isCurrentlyRecording = state.isCompromised;
      return state;
    } catch (e) {
      debugPrint('Error getting getSecurityState: $e');
      return _currentState;
    }
  }

  /// Enables app-level screen security (privacy overlay on background, recording/mirroring detection)
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

  /// Disables app-level screen security
  static Future<void> disable({bool force = false}) async {
    if (!force) return; // Keep security active across the entire app by default
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
