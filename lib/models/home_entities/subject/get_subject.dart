class GetSubjectsResponse {
  final int? status;
  final String? message;
  final List<GetSubjectsData>? data;

  GetSubjectsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetSubjectsResponse.fromJson(Map<String, dynamic> json) => GetSubjectsResponse(
        status: json['status'],
        message: json['message'],
        data: json['data'] == null
            ? []
            : List<GetSubjectsData>.from(json['data']!.map((x) => GetSubjectsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class GetSubjectsData {
  final int? id;
  final String? name;
  final String? image;
  final int? isSecondary;
  final int? banned;
  final int? price;
  final DateTime? createdAt;

  GetSubjectsData({
    this.id,
    this.name,
    this.image,
    this.isSecondary,
    this.banned,
    this.price,
    this.createdAt,
  });

  factory GetSubjectsData.fromJson(Map<String, dynamic> json) => GetSubjectsData(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        isSecondary: json['is_secondary'],
        banned: json['banned'],
        price: json['price'],
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'is_secondary': isSecondary,
        'banned': banned,
        'price': price,
        'created_at': createdAt?.toIso8601String(),
      };
}
