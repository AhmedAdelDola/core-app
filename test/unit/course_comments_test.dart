import 'package:elhanbly/models/home_entities/courses/course_comments_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Course Comments Models & Parsing', () {
    final sampleJson = {
      "comments": {
        "data": [
          {
            "id": 12,
            "session_id": 5,
            "body": "شرح ممتاز جداً يا دكتور، بس هل هيكون فيه ملخص للدرس الأول؟",
            "is_pinned": true,
            "is_mine": true,
            "student": {
              "id": 42,
              "name": "أحمد محمود",
              "image_url": "https://example.com/student.jpg"
            },
            "edited_at": "2026-09-22T12:30:00.000000Z",
            "created_at": "2026-09-22T10:00:00.000000Z",
            "replies": [
              {
                "id": 13,
                "parent_id": 12,
                "body": "أهلاً يا أحمد، الملخص نزل في قسم المذكرات بالفعل بالتوفيق!",
                "replied_by": {
                  "id": 3,
                  "name": "أ. محمد عبد الله",
                  "role": "teacher",
                  "image_url": "https://example.com/teacher.jpg"
                },
                "created_at": "2026-09-22T11:15:00.000000Z"
              }
            ]
          }
        ],
        "current_page": 1,
        "last_page": 3,
        "total": 45
      }
    };

    test('parses session comments response accurately', () {
      final response = CourseCommentsResponse.fromJson(sampleJson);
      final commentsData = response.comments;

      expect(commentsData.currentPage, 1);
      expect(commentsData.lastPage, 3);
      expect(commentsData.total, 45);
      expect(commentsData.data.length, 1);

      final comment = commentsData.data.first;
      expect(comment.id, 12);
      expect(comment.sessionId, 5);
      expect(comment.courseId, 5);
      expect(comment.body, contains('شرح ممتاز'));
      expect(comment.isPinned, isTrue);
      expect(comment.isMine, isTrue);
      expect(comment.isEdited, isTrue);
      expect(comment.student?.name, 'أحمد محمود');
      expect(comment.student?.imageUrl, 'https://example.com/student.jpg');
      expect(comment.replies.length, 1);

      final reply = comment.replies.first;
      expect(reply.id, 13);
      expect(reply.parentId, 12);
      expect(reply.body, contains('الملخص نزل'));
      expect(reply.repliedBy?.name, 'أ. محمد عبد الله');
      expect(reply.repliedBy?.isTeacher, isTrue);
      expect(reply.repliedBy?.roleDisplayName, 'محاضر');
    });

    test('handles assistant role badge correctly', () {
      final reply = CourseCommentReply.fromJson({
        'id': 14,
        'parent_id': 12,
        'body': 'تم الرد من المساعد',
        'replied_by': {
          'id': 7,
          'name': 'م. كريم',
          'role': 'assistant',
          'image_url': null,
        },
      });

      expect(reply.repliedBy?.isAssistant, isTrue);
      expect(reply.repliedBy?.roleDisplayName, 'مساعد');
    });

    test('serializes comment to JSON', () {
      final response = CourseCommentsResponse.fromJson(sampleJson);
      final json = response.toJson();

      expect(json['comments']['data'], isA<List>());
      expect(json['comments']['total'], 45);
      expect(json['comments']['current_page'], 1);
    });
  });
}
