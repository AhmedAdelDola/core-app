// ignore: depend_on_referenced_packages
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter/material.dart';
import 'core/app/app.dart';
import 'core/app/init_services.dart';

/// Special entrypoint used ONLY for automated screenshot capture.
/// Enables FlutterDriver extension so [test_driver/screenshot_driver.dart]
/// can connect and take real screenshots via the Dart VM service.
Future<void> main() async {
  // Must be called before runApp when using FlutterDriver.
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(MyApp());
}
