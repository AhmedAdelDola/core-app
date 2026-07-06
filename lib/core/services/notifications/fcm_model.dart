class FCMModel {
  String notifyType;
  String id;
  String type;
  String? to;
  int? toId;
  String? toAvatar;
  String? toMobile;
  int? fromId;
  String? from;
  String? fromAvatar;
  String? fromMobile;
  int? orderId;
  FCMModel({
    required this.id,
    required this.notifyType,
    required this.type,
    this.to,
    this.toId,
    this.toAvatar,
    this.toMobile,
    this.fromId,
    this.from,
    this.fromAvatar,
    this.fromMobile,
    this.orderId,
  });
  factory FCMModel.fromJson(Map<String, dynamic> json) => FCMModel(
        notifyType: json['notify_type'],
        id: json['id'],
        type: json['type'],
        to: json['to'] ?? '',
        toId: json['to_id'] ?? 0,
        toAvatar: json['to_avatar'] ?? '',
        toMobile: json['to_mobile'] ?? '',
        fromId: json['from_id'] ?? 0,
        from: json['from'] ?? '',
        fromAvatar: json['from_avatar'] ?? '',
        fromMobile: json['from_mobile'] ?? '',
        orderId: json['order_id'] ?? 0,
      );
}
