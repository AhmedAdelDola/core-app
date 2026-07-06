class GetNotificationsResponse {
  final int? status;
  final String? message;
  final Data? data;

  GetNotificationsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetNotificationsResponse.fromJson(Map<String, dynamic> json) =>
      GetNotificationsResponse(
        status: json['status'],
        message: json['message'],
        data: json['data'] == null ? null : Data.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class Data {
  final List<AppNotification>? data;
  final Links? links;
  final Meta? meta;

  Data({
    this.data,
    this.links,
    this.meta,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json['data'] == null
            ? []
            : List<AppNotification>.from(
                json['data']!.map((x) => AppNotification.fromJson(x))),
        links: json['links'] == null ? null : Links.fromJson(json['links']),
        meta: json['meta'] == null ? null : Meta.fromJson(json['meta']),
      );

  Map<String, dynamic> toJson() => {
        'data': data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        'links': links?.toJson(),
        'meta': meta?.toJson(),
      };
}

class AppNotification {
  final dynamic id;
  final String? title;
  final String? message;
  final int? isRead;
  final int? isFree;
  final dynamic courseId;
  final dynamic modelId;
  final String? model;
  final String? image;
  final DateTime? createdAt;

  AppNotification({
    this.id,
    this.title,
    this.message,
    this.isRead,
    this.isFree,
    this.courseId,
    this.modelId,
    this.model,
    this.image,
    this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'],
        title: json['title'],
        message: json['message'],
        isRead: json['is_read'],
        isFree: json['is_free'],
        courseId: json['course_id'],
        modelId: json['model_id'],
        model: json['model'],
        image: json['image'],
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'is_read': isRead,
        'is_free': isFree,
        'course_id': courseId,
        'model_id': modelId,
        'model': model,
        'image': image,
        'created_at': createdAt?.toIso8601String(),
      };
}

class Links {
  final String? first;
  final String? last;
  final dynamic prev;
  final String? next;

  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json['first'],
        last: json['last'],
        prev: json['prev'],
        next: json['next'],
      );

  Map<String, dynamic> toJson() => {
        'first': first,
        'last': last,
        'prev': prev,
        'next': next,
      };
}

class Meta {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<Link>? links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json['current_page'],
        from: json['from'],
        lastPage: json['last_page'],
        links: json['links'] == null
            ? []
            : List<Link>.from(json['links']!.map((x) => Link.fromJson(x))),
        path: json['path'],
        perPage: json['per_page'],
        to: json['to'],
        total: json['total'],
      );

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'from': from,
        'last_page': lastPage,
        'links': links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        'path': path,
        'per_page': perPage,
        'to': to,
        'total': total,
      };
}

class Link {
  final String? url;
  final String? label;
  final bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json['url'],
        label: json['label'],
        active: json['active'],
      );

  Map<String, dynamic> toJson() => {
        'url': url,
        'label': label,
        'active': active,
      };
}
