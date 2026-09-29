class GetNotificationsResponse {
  final List<AppNotification> notifications;
  final int unreadCount;
  final int? status;
  final String? message;

  GetNotificationsResponse({
    this.notifications = const [],
    this.unreadCount = 0,
    this.status,
    this.message,
  });

  factory GetNotificationsResponse.fromJson(Map<String, dynamic> json) {
    List<AppNotification> list = [];

    if (json['notifications'] != null && json['notifications'] is List) {
      list = (json['notifications'] as List)
          .whereType<Map<String, dynamic>>()
          .map((x) => AppNotification.fromJson(x))
          .toList();
    } else if (json['data'] != null) {
      if (json['data'] is List) {
        list = (json['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map((x) => AppNotification.fromJson(x))
            .toList();
      } else if (json['data'] is Map<String, dynamic>) {
        final dataMap = json['data'] as Map<String, dynamic>;
        if (dataMap['data'] is List) {
          list = (dataMap['data'] as List)
              .whereType<Map<String, dynamic>>()
              .map((x) => AppNotification.fromJson(x))
              .toList();
        }
      }
    }

    int unread = 0;
    if (json['unread_count'] != null) {
      unread = json['unread_count'] is int
          ? json['unread_count'] as int
          : int.tryParse(json['unread_count'].toString()) ?? 0;
    } else {
      unread = list.where((n) => !n.isRead).length;
    }

    return GetNotificationsResponse(
      notifications: list,
      unreadCount: unread,
      status: json['status'] is int ? json['status'] as int : null,
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'notifications': notifications.map((x) => x.toJson()).toList(),
        'unread_count': unreadCount,
        if (status != null) 'status': status,
        if (message != null) 'message': message,
      };
}

class AppNotification {
  final dynamic id;
  final String? type;
  final String? title;
  final String? body;
  final String? message;
  final Map<String, dynamic>? data;
  final DateTime? sentAt;
  final DateTime? readAt;
  final DateTime? createdAt;
  final bool isRead;
  final String? image;

  AppNotification({
    this.id,
    this.type,
    this.title,
    this.body,
    this.message,
    this.data,
    this.sentAt,
    this.readAt,
    this.createdAt,
    this.isRead = false,
    this.image,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final bodyText = json['body']?.toString() ?? json['message']?.toString() ?? '';
    final rawIsRead = json['is_read'];
    final bool readStatus = rawIsRead == true ||
        rawIsRead == 1 ||
        rawIsRead == '1' ||
        json['read_at'] != null;

    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      return DateTime.tryParse(val.toString());
    }

    return AppNotification(
      id: json['id'],
      type: json['type']?.toString(),
      title: json['title']?.toString(),
      body: bodyText,
      message: bodyText,
      data: json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : null,
      sentAt: parseDate(json['sent_at']),
      readAt: parseDate(json['read_at']),
      createdAt: parseDate(json['created_at']) ?? parseDate(json['sent_at']),
      isRead: readStatus,
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'body': body,
        'message': message,
        'data': data,
        'sent_at': sentAt?.toIso8601String(),
        'read_at': readAt?.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),
        'is_read': isRead,
        'image': image,
      };
}
