import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../di.dart';
import 'fcm_model.dart';
import 'local_notifications.dart';

abstract class AppFirebaseMessaging {
  static Future<void> setForegroundNotificationPresentationOptions() async {
    return await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  static Future<void> getToken() async {
    try {
      final String? fcmToken = await FirebaseMessaging.instance.getToken();
      injectFCMToken(fcmToken);
      // log('FCM token: ${fcmToken.toString()}');
    } on FirebaseException catch (e) {
      log('FCM getToken: Error: ${e.toString()}');
    }
  }

  static void onTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((String fcmToken) {
      injectFCMToken(fcmToken);
      log('FCM onTokenRefresh: ${fcmToken.toString()}');
    });
  }

  static void onMessage(LocalNotificationService service) {
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      if (event.data.isNotEmpty) {
        log('FCM onMessage: ${event.notification?.title}');
        log('FCM onMessageOpenedApp body: ${event.notification?.body}');
        log('FCM onMessageOpenedApp notification: ${event.notification}');
        log('FCM onMessageOpenedApp data anotherData: ${event.data['anotherData']}');
        final fcm = json.decode(event.data['anotherData']);
        final data = FCMModel.fromJson(fcm);
        log('FCM onMessageOpenedApp data type: ${data.type}');
        //navigateNotification(type: data.type);
      }

      _showLocalNotification(service, event);
    });
  }

  static void getInitialMessage(LocalNotificationService service) {
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null) {
        log('FCM onMessage: ${message.notification?.title}');
        log('FCM onMessageOpenedApp body: ${message.notification?.body}');
        log('FCM onMessageOpenedApp notification: ${message.notification}');
        log('FCM onMessageOpenedApp data anotherData: ${message.data['anotherData']}');
        final fcm = json.decode(message.data['anotherData']);
        final data = FCMModel.fromJson(fcm);
        log('FCM onMessageOpenedApp data type: ${data.type}');
        navigateNotification(data: data);
      }

      //_showLocalNotification(service, message!);
    });
  }

  static void onMessageOpenedApp(LocalNotificationService service) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      if (event.data.isNotEmpty) {
        log('FCM onMessage: ${event.notification?.title}');
        log('FCM onMessageOpenedApp body: ${event.notification?.body}');
        log('FCM onMessageOpenedApp notification: ${event.notification}');
        log('FCM onMessageOpenedApp data anotherData: ${event.data['anotherData']}');
        final fcm = json.decode(event.data['anotherData']);
        final data = FCMModel.fromJson(fcm);
        log('FCM onMessageOpenedApp data type: ${data.type}');

        navigateNotification(data: data);
      }

      // _showLocalNotification(service, event);
    });
  }

  // static void subscribeToTopic(String topic) {
  //   FirebaseMessaging.instance.subscribeToTopic(topic).then((value) {
  //     log('FCM subscribeToTopic: Success');
  //   }).catchError((error) {
  //     log('FCM subscribeToTopic: Error: ${error.toString()}');
  //   });
  // }

  static void _showLocalNotification(LocalNotificationService service, RemoteMessage event) {
    String title = event.notification?.title ?? '';
    String body = event.notification?.body ?? '';
    final fcm = json.decode(event.data['anotherData']);
    final data = FCMModel.fromJson(fcm);
    _handleOnCancelTrip(data);
    service.showNotification(id: 100, title: title, body: body);
  }
}

void _handleOnCancelTrip(FCMModel data) {
  // if (data.type == 'cancel_trip') {
  // OnCancelTripSubscription.pushUpdate();
  // }
}

void navigateNotification({required FCMModel data}) {}
