import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../course_view_widgets/course_files_section/course_files_sec.dart';
import 'package:flutter/material.dart';

import '../course_view_widgets/course_details_header.dart';
import '../course_view_widgets/course_lessons_section/course_lessons_section.dart';
import '../course_view_widgets/course_rate_section/course_comments_section.dart';

class NotSubscribeView extends StatelessWidget {
  const NotSubscribeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800.w),
          child: Column(
            children: [
              const CourseHeader(),
              10.sbH,
              const CourseLessonsSection(),
              // 10.sbH,
              // // const CourseComments(),
              // 10.sbH,
              // const CourseFilesSec(),
              40.sbH,
            ],
          ),
        ),
      ),
    );
  }
}
