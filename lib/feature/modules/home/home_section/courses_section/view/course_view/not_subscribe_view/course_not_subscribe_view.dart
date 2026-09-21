import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../course_view_widgets/course_files_section/course_files_sec.dart';
import 'package:flutter/material.dart';

import '../course_view_widgets/course_details_header.dart';
import '../course_view_widgets/course_lessons_section/course_lessons_section.dart';
import '../course_view_widgets/course_rate_section/course_comments_section.dart';

import '../../../../../../../../core/util/responsive/responsive_helper.dart';

class NotSubscribeView extends StatelessWidget {
  const NotSubscribeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveContainer(
      maxWidth: ResponsiveBreakpoints.maxContentWidth,
      child: Column(
        children: [
          const CourseHeader(),
          10.sbH,
          const CourseLessonsSection(),
          40.sbH,
        ],
      ),
    );
  }
}
