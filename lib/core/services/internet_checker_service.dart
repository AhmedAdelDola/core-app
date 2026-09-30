import 'dart:async';
import 'dart:io';

class InternetCheckerService {
  Timer? _timer;
  final Function(bool isConnected) onStatusChanged;
  bool _lastStatus = true;

  InternetCheckerService({required this.onStatusChanged});

  void startChecking() {
    // Check immediately upon starting
    _checkInternet();
    // Periodic check every 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _checkInternet();
    });
  }

  Future<void> _checkInternet() async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }

    if (isConnected != _lastStatus) {
      _lastStatus = isConnected;
      onStatusChanged(isConnected);
    }
  }

  void stopChecking() {
    _timer?.cancel();
  }
}
