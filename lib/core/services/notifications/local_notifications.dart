import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _service = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitializationSettings = DarwinInitializationSettings(
      notificationCategories: <DarwinNotificationCategory>[
        DarwinNotificationCategory(
          'basic_channel',
          actions: <DarwinNotificationAction>[],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
            DarwinNotificationCategoryOption.allowAnnouncement,
          },
        ),
      ],
    );
    const InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    bool? isInit = await _service.initialize(settings);
    await _service
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(sound: true, alert: true, badge: true);
    log('FlutterLocalNotificationsPlugin isInit: $isInit');
  }

  Future<NotificationDetails> _notificationsDetails(String? icon) async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'basic_channel',
      'basic_channel',
      channelDescription: 'my_description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      icon: icon,
      //sound: RawResourceAndroidNotificationSound('notification'),
    );
    DarwinNotificationDetails iosNotificationDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? icon,
  }) async {
    final NotificationDetails details = await _notificationsDetails(icon);
    await _service.show(id, title, body, details);
  }

  void onDidReceiveLocalNotification({int? id, String? title, String? body, String? payload}) {
    log('onDidReceiveLocalNotification id: $id');
  }
}
