import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const MethodChannel _flutterToastChannel =
    MethodChannel('PonnamKarthik/fluttertoast');

void mockFlutterToastChannel() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_flutterToastChannel, (_) async => true);
}

void resetFlutterToastChannel() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_flutterToastChannel, null);
}
