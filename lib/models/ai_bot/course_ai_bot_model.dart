class CourseAiBotHistoryResponse {
  final bool available;
  final bool subscribed;
  final String? message;
  final AiBotDetails? bot;
  final String? conversationId;
  final List<AiBotMessage> messages;

  CourseAiBotHistoryResponse({
    this.available = false,
    this.subscribed = false,
    this.message,
    this.bot,
    this.conversationId,
    this.messages = const [],
  });

  factory CourseAiBotHistoryResponse.fromJson(dynamic json) {
    if (json == null || json is! Map) return CourseAiBotHistoryResponse();
    return CourseAiBotHistoryResponse(
      available: json['available'] == true,
      subscribed: json['subscribed'] == true,
      message: json['message'] is String ? json['message'] as String : null,
      bot: json['bot'] != null && json['bot'] is Map ? AiBotDetails.fromJson(json['bot']) : null,
      conversationId: json['conversation_id']?.toString(),
      messages: (json['messages'] as List?)
              ?.where((e) => e != null && e is Map)
              .map((e) => AiBotMessage.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'available': available,
        'subscribed': subscribed,
        'message': message,
        'bot': bot?.toJson(),
        'conversation_id': conversationId,
        'messages': messages.map((e) => e.toJson()).toList(),
      };
}

class AiBotDetails {
  final String? id;
  final String? name;
  final String? welcomeMessage;
  final String? defaultLanguage;

  AiBotDetails({
    this.id,
    this.name,
    this.welcomeMessage,
    this.defaultLanguage,
  });

  factory AiBotDetails.fromJson(dynamic json) {
    if (json == null || json is! Map) return AiBotDetails();
    return AiBotDetails(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      welcomeMessage: json['welcome_message']?.toString(),
      defaultLanguage: json['default_language']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'welcome_message': welcomeMessage,
        'default_language': defaultLanguage,
      };
}

class AiBotMessage {
  final String? id;
  final String role; // 'student' or 'assistant'
  final String content;
  final String? imageUrl;
  final String? localImagePath;
  final DateTime? createdAt;
  final bool answerable;

  AiBotMessage({
    this.id,
    required this.role,
    required this.content,
    this.imageUrl,
    this.localImagePath,
    this.createdAt,
    this.answerable = true,
  });

  factory AiBotMessage.fromJson(dynamic json) {
    if (json == null || json is! Map) {
      return AiBotMessage(role: 'assistant', content: '');
    }

    String? imgUrl = json['image_url']?.toString();
    if (imgUrl == null && json['metadata'] is Map) {
      imgUrl = json['metadata']['image_url']?.toString();
    }

    return AiBotMessage(
      id: json['id']?.toString(),
      role: json['role']?.toString() ?? 'assistant',
      content: json['content']?.toString() ?? '',
      imageUrl: imgUrl,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      answerable: json['answerable'] != false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role,
        'content': content,
        'image_url': imageUrl,
        'created_at': createdAt?.toIso8601String(),
        'answerable': answerable,
      };
}

class SendAiBotMessageResponse {
  final bool ok;
  final String? message;
  final String? conversationId;
  final AiBotMessage? userMessage;
  final AiBotMessage? reply;

  SendAiBotMessageResponse({
    this.ok = true,
    this.message,
    this.conversationId,
    this.userMessage,
    this.reply,
  });

  factory SendAiBotMessageResponse.fromJson(dynamic json) {
    if (json == null || json is! Map) return SendAiBotMessageResponse(ok: false);

    AiBotMessage? userMsg;
    if (json['message'] is Map) {
      userMsg = AiBotMessage.fromJson(json['message']);
    }

    AiBotMessage? replyMsg;
    if (json['reply'] is Map) {
      replyMsg = AiBotMessage.fromJson(json['reply']);
    }

    return SendAiBotMessageResponse(
      ok: json['ok'] == true,
      message: json['message'] is String ? json['message'] as String : null,
      conversationId: json['conversation_id']?.toString(),
      userMessage: userMsg,
      reply: replyMsg,
    );
  }

  Map<String, dynamic> toJson() => {
        'ok': ok,
        'message': message,
        'conversation_id': conversationId,
        'user_message': userMessage?.toJson(),
        'reply': reply?.toJson(),
      };
}
