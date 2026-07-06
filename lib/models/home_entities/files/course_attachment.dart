class CourseAttachmentResponse {
  final int? status;
  final String? message;
  final List<CourseAttachmentData>? data;

  CourseAttachmentResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CourseAttachmentResponse.fromJson(Map<String, dynamic> json) =>
      CourseAttachmentResponse(
        status: json['status'],
        message: json['message'],
        data: json['data'] == null
            ? null
            : List<CourseAttachmentData>.from(
                json['data'].map((x) => CourseAttachmentData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((x) => x.toJson()).toList(),
      };
}

class CourseAttachmentData {
  final int? id;
  final String? name;
  final int? attachmentCount;
  final Attachments? attachments;

  CourseAttachmentData({
    this.id,
    this.name,
    this.attachmentCount,
    this.attachments,
  });

  factory CourseAttachmentData.fromJson(Map<String, dynamic> json) =>
      CourseAttachmentData(
        id: json['id'],
        name: json['name'],
        attachmentCount: json['attachment_count'],
        attachments: json['attachments'] == null
            ? null
            : Attachments.fromJson(json['attachments']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'attachment_count': attachmentCount,
        'attachments': attachments?.toJson(),
      };
}

class Attachments {
  final List<dynamic>? data;
  final AttachmentLinks? links;
  final AttachmentMeta? meta;

  Attachments({
    this.data,
    this.links,
    this.meta,
  });

  factory Attachments.fromJson(Map<String, dynamic> json) => Attachments(
        data: json['data'],
        links: json['links'] == null
            ? null
            : AttachmentLinks.fromJson(json['links']),
        meta:
            json['meta'] == null ? null : AttachmentMeta.fromJson(json['meta']),
      );

  Map<String, dynamic> toJson() => {
        'data': data,
        'links': links?.toJson(),
        'meta': meta?.toJson(),
      };
}

class AttachmentLinks {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  AttachmentLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory AttachmentLinks.fromJson(Map<String, dynamic> json) =>
      AttachmentLinks(
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

class AttachmentMeta {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<MetaLink>? links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  AttachmentMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory AttachmentMeta.fromJson(Map<String, dynamic> json) => AttachmentMeta(
        currentPage: json['current_page'],
        from: json['from'],
        lastPage: json['last_page'],
        links: json['links'] == null
            ? null
            : List<MetaLink>.from(
                json['links'].map((x) => MetaLink.fromJson(x))),
        path: json['path'],
        perPage: json['per_page'],
        to: json['to'],
        total: json['total'],
      );

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'from': from,
        'last_page': lastPage,
        'links': links?.map((x) => x.toJson()).toList(),
        'path': path,
        'per_page': perPage,
        'to': to,
        'total': total,
      };
}

class MetaLink {
  final String? url;
  final String? label;
  final bool? active;

  MetaLink({
    this.url,
    this.label,
    this.active,
  });

  factory MetaLink.fromJson(Map<String, dynamic> json) => MetaLink(
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
