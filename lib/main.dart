import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/app/app.dart';
import 'core/app/init_services.dart';
import 'core/services/screen_security_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await initServices();
  runApp(MyApp());
}
