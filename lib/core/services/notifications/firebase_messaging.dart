import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../navigator/named_navigator_impl.dart';
import '../../../feature/modules/home/home_section/courses_section/view/course_view/course_view.dart';
import '../../../feature/modules/home/home_section/lessons_section/widgets/session_screen.dart';
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
        log('FCM onMessage data: ${event.data}');
      }
      _showLocalNotification(service, event);
    });
  }

  static void getInitialMessage(LocalNotificationService service) {
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null && message.data.isNotEmpty) {
        log('FCM getInitialMessage data: ${message.data}');
        handleNotificationData(message.data);
      }
    });
  }

  static void onMessageOpenedApp(LocalNotificationService service) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      if (event.data.isNotEmpty) {
        log('FCM onMessageOpenedApp data: ${event.data}');
        handleNotificationData(event.data);
      }
    });
  }

  static void handleRawNotificationPayload(String payload) {
    try {
      final decoded = json.decode(payload);
      if (decoded is Map<String, dynamic>) {
        handleNotificationData(decoded);
      }
    } catch (e) {
      log('Error decoding notification payload: $e');
    }
  }

  static void handleNotificationData(Map<String, dynamic> rawData) {
    final data = _extractDataMap(rawData);
    final kind = data['kind']?.toString() ?? data['type']?.toString();

    if (kind == 'session_comment' || kind == 'course_comment') {
      final sessionId = data['session_id']?.toString() ?? data['sessionId']?.toString();
      final courseId = data['course_id']?.toString() ?? data['courseId']?.toString();
      final commentId = int.tryParse('${data['comment_id'] ?? data['commentId']}');
      final replyId = int.tryParse('${data['reply_id'] ?? data['replyId']}');

      if (sessionId != null && sessionId.isNotEmpty) {
        NamedNavigatorImpl.push(SessionDetilesScreen(
          id: int.tryParse(sessionId) ?? 0,
          title: '',
          subTitle: '',
          initialOpenComments: true,
          highlightCommentId: commentId,
          highlightReplyId: replyId,
        ));
      } else if (courseId != null && courseId.isNotEmpty) {
        NamedNavigatorImpl.push(CourseViewScreen(
          id: courseId,
        ));
      }
      return;
    }

    // Fallback to legacy FCMModel if type is present
    try {
      final fcmModel = FCMModel.fromJson(data);
      navigateNotification(data: fcmModel);
    } catch (e) {
      log('FCMModel fallback parse error: $e');
    }
  }

  static Map<String, dynamic> _extractDataMap(Map<String, dynamic> rawData) {
    if (rawData.containsKey('kind') &&
        (rawData['kind'] == 'session_comment' || rawData['kind'] == 'course_comment')) {
      return rawData;
    }
    if (rawData['anotherData'] != null) {
      try {
        final decoded = json.decode(rawData['anotherData'].toString());
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      } catch (_) {}
    }
    if (rawData['data'] != null && rawData['data'] is String) {
      try {
        final decoded = json.decode(rawData['data'].toString());
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      } catch (_) {}
    } else if (rawData['data'] != null && rawData['data'] is Map<String, dynamic>) {
      return rawData['data'] as Map<String, dynamic>;
    }
    return rawData;
  }

  static void _showLocalNotification(LocalNotificationService service, RemoteMessage event) {
    String title = event.notification?.title ?? '';
    String body = event.notification?.body ?? '';
    if (title.isEmpty && event.data['title'] != null) {
      title = event.data['title'].toString();
    }
    if (body.isEmpty && event.data['body'] != null) {
      body = event.data['body'].toString();
    }

    final data = _extractDataMap(event.data);
    final payloadString = json.encode(data);

    service.showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      payload: payloadString,
    );
  }
}

void navigateNotification({required FCMModel data}) {}
