import 'package:elhanbly/core/util/responsive/responsive_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import 'package:flutter/material.dart';

import '../course_view_widgets/course_details_header.dart';
import '../course_view_widgets/course_lessons_section/course_lessons_section.dart';

class NotSubscribeView extends StatelessWidget {
  final VoidCallback? onSubscribe;
  final dynamic courseId;

  const NotSubscribeView({
    super.key,
    this.onSubscribe,
    this.courseId,
  });

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
