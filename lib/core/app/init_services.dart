import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../firebase_options.dart';
import '../consts/bloc_observer.dart';
import '../network/extensions/http_overrides.dart';
import '../services/di.dart';
import '../services/notifications/firebase_messaging.dart';
import '../services/notifications/local_notifications.dart';

Future<void> initServices() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();
  HttpOverrides.global = MyHttpOverrides();
  const isTakingScreenshots = bool.fromEnvironment('TAKING_SCREENSHOTS');
  if (!isTakingScreenshots) {
    await listenAppFirebaseMessaging();
  }
  Bloc.observer = BlocObserverService();
}

Future<void> listenAppFirebaseMessaging() async {
  final LocalNotificationService localNotificationService =
      di<LocalNotificationService>();
  await localNotificationService.initialize();
  AppFirebaseMessaging.setForegroundNotificationPresentationOptions();
  AppFirebaseMessaging.onMessage(localNotificationService);
  AppFirebaseMessaging.getInitialMessage(localNotificationService);
  AppFirebaseMessaging.onMessageOpenedApp(localNotificationService);
  AppFirebaseMessaging.getToken();
  AppFirebaseMessaging.onTokenRefresh();
  // AppFirebaseMessaging.subscribeToTopic('all');
}
