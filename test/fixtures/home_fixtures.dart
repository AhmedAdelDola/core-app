import 'package:elhanbly/models/home_entities/home/get_home.dart';

Map<String, dynamic> homeResponseJson() => {
      'notifications': [],
      'recommended_courses': [
        {
          'id': 1,
          'title': 'Algebra Basics',
          'description': 'Intro course',
          'price': '120',
          'has_active_subscription': false,
          'can_view_course_content': false,
          'stage': {'id': 1, 'name': 'Stage 1'},
          'level': {'id': 10, 'name': 'Level 1'},
          'teacher': {'id': 7, 'name': 'Teacher Name'},
          'image_url': 'https://example.com/course.png',
          'promo_url': null,
        },
      ],
      'suggested_sessions': [],
      'featured_files': [],
      'top_teacher': {
        'id': 7,
        'name': 'Teacher Name',
        'active_courses_count': 3,
      },
      'newest_content': [],
    };

HomeResponse homeResponseFixture() {
  return HomeResponse.fromJson(homeResponseJson());
}
