class CourseCommentsResponse {
  final CourseCommentsData comments;

  CourseCommentsResponse({required this.comments});

  factory CourseCommentsResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('comments') && json['comments'] is Map<String, dynamic>) {
      return CourseCommentsResponse(
        comments: CourseCommentsData.fromJson(json['comments'] as Map<String, dynamic>),
      );
    }
    // Fallback if data is at root
    return CourseCommentsResponse(
      comments: CourseCommentsData.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() => {
        'comments': comments.toJson(),
      };
}

class CourseCommentsData {
  final List<CourseCommentItem> data;
  final int currentPage;
  final int lastPage;
  final int total;

  CourseCommentsData({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory CourseCommentsData.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final List<CourseCommentItem> items = rawData is List
        ? rawData.map((e) => CourseCommentItem.fromJson(e as Map<String, dynamic>)).toList()
        : <CourseCommentItem>[];

    return CourseCommentsData(
      data: items,
      currentPage: json['current_page'] is int
          ? json['current_page']
          : int.tryParse('${json['current_page'] ?? 1}') ?? 1,
      lastPage: json['last_page'] is int
          ? json['last_page']
          : int.tryParse('${json['last_page'] ?? 1}') ?? 1,
      total: json['total'] is int
          ? json['total']
          : int.tryParse('${json['total'] ?? 0}') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data.map((e) => e.toJson()).toList(),
        'current_page': currentPage,
        'last_page': lastPage,
        'total': total,
      };
}

typedef SessionCommentsResponse = CourseCommentsResponse;
typedef SessionCommentsData = CourseCommentsData;
typedef SessionCommentItem = CourseCommentItem;
typedef SessionCommentStudent = CourseCommentStudent;
typedef SessionCommentReply = CourseCommentReply;
typedef SessionCommentRepliedBy = CourseCommentRepliedBy;

class CourseCommentItem {
  final int id;
  final int sessionId;
  int get courseId => sessionId;
  String body;
  final bool isPinned;
  final bool isMine;
  final CourseCommentStudent? student;
  DateTime? editedAt;
  final DateTime? createdAt;
  final List<CourseCommentReply> replies;

  CourseCommentItem({
    required this.id,
    int? sessionId,
    int? courseId,
    required this.body,
    required this.isPinned,
    required this.isMine,
    this.student,
    this.editedAt,
    this.createdAt,
    this.replies = const [],
  }) : sessionId = sessionId ?? courseId ?? 0;

  bool get isEdited => editedAt != null;

  factory CourseCommentItem.fromJson(Map<String, dynamic> json) {
    final rawReplies = json['replies'];
    final List<CourseCommentReply> repliesList = rawReplies is List
        ? rawReplies.map((e) => CourseCommentReply.fromJson(e as Map<String, dynamic>)).toList()
        : <CourseCommentReply>[];

    final rawSessionId = json['session_id'] ?? json['course_id'] ?? 0;
    final int parsedSessionId = rawSessionId is int
        ? rawSessionId
        : int.tryParse('$rawSessionId') ?? 0;

    return CourseCommentItem(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id'] ?? 0}') ?? 0,
      sessionId: parsedSessionId,
      body: json['body']?.toString() ?? '',
      isPinned: json['is_pinned'] == true || json['is_pinned'] == 1 || json['is_pinned'] == '1',
      isMine: json['is_mine'] == true || json['is_mine'] == 1 || json['is_mine'] == '1',
      student: json['student'] != null && json['student'] is Map<String, dynamic>
          ? CourseCommentStudent.fromJson(json['student'] as Map<String, dynamic>)
          : null,
      editedAt: json['edited_at'] != null ? DateTime.tryParse(json['edited_at'].toString()) : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      replies: repliesList,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'session_id': sessionId,
        'course_id': sessionId,
        'body': body,
        'is_pinned': isPinned,
        'is_mine': isMine,
        if (student != null) 'student': student!.toJson(),
        if (editedAt != null) 'edited_at': editedAt!.toIso8601String(),
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        'replies': replies.map((e) => e.toJson()).toList(),
      };

  CourseCommentItem copyWith({
    int? id,
    int? sessionId,
    int? courseId,
    String? body,
    bool? isPinned,
    bool? isMine,
    CourseCommentStudent? student,
    DateTime? editedAt,
    DateTime? createdAt,
    List<CourseCommentReply>? replies,
  }) {
    return CourseCommentItem(
      id: id ?? this.id,
      sessionId: sessionId ?? courseId ?? this.sessionId,
      body: body ?? this.body,
      isPinned: isPinned ?? this.isPinned,
      isMine: isMine ?? this.isMine,
      student: student ?? this.student,
      editedAt: editedAt ?? this.editedAt,
      createdAt: createdAt ?? this.createdAt,
      replies: replies ?? this.replies,
    );
  }
}

class CourseCommentStudent {
  final int id;
  final String name;
  final String? imageUrl;

  CourseCommentStudent({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory CourseCommentStudent.fromJson(Map<String, dynamic> json) {
    return CourseCommentStudent(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id'] ?? 0}') ?? 0,
      name: json['name']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (imageUrl != null) 'image_url': imageUrl,
      };
}

class CourseCommentReply {
  final int id;
  final int parentId;
  final String body;
  final CourseCommentRepliedBy? repliedBy;
  final DateTime? createdAt;

  CourseCommentReply({
    required this.id,
    required this.parentId,
    required this.body,
    this.repliedBy,
    this.createdAt,
  });

  factory CourseCommentReply.fromJson(Map<String, dynamic> json) {
    return CourseCommentReply(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id'] ?? 0}') ?? 0,
      parentId: json['parent_id'] is int
          ? json['parent_id']
          : int.tryParse('${json['parent_id'] ?? 0}') ?? 0,
      body: json['body']?.toString() ?? '',
      repliedBy: json['replied_by'] != null && json['replied_by'] is Map<String, dynamic>
          ? CourseCommentRepliedBy.fromJson(json['replied_by'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'parent_id': parentId,
        'body': body,
        if (repliedBy != null) 'replied_by': repliedBy!.toJson(),
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      };
}

class CourseCommentRepliedBy {
  final int id;
  final String name;
  final String role;
  final String? imageUrl;

  CourseCommentRepliedBy({
    required this.id,
    required this.name,
    required this.role,
    this.imageUrl,
  });

  bool get isTeacher => role.toLowerCase() == 'teacher' || role.toLowerCase() == 'owner';
  bool get isAssistant => role.toLowerCase() == 'assistant';

  String get roleDisplayName {
    final r = role.toLowerCase();
    if (r == 'teacher' || r == 'owner') return 'محاضر';
    if (r == 'assistant') return 'مساعد';
    return role;
  }

  factory CourseCommentRepliedBy.fromJson(Map<String, dynamic> json) {
    return CourseCommentRepliedBy(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id'] ?? 0}') ?? 0,
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? 'teacher',
      imageUrl: json['image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        if (imageUrl != null) 'image_url': imageUrl,
      };
}
