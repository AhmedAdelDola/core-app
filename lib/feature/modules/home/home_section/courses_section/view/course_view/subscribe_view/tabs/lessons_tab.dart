import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../../core/widgets/loader/app_loader.dart';
import '../../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../../cubit/courses_section_cubit.dart';
import 'package:flutter/material.dart';
import '../../course_view_widgets/course_lessons_section/course_lessons_card.dart';

class LessonsTab extends StatefulWidget {
  const LessonsTab({super.key});

  @override
  State<LessonsTab> createState() => _LessonsTabState();
}

class _LessonsTabState extends State<LessonsTab> {
  int _expandedIndex = -1; // Track expanded item globally in the widget state

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesSectionCubit, CoursesSectionState>(
      builder: (context, state) {
        final cubit = CoursesSectionCubit.of(context);
        final model = cubit.courseData;
        if (state is GetCourseChapterLoadingState) return const AppLoader();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: AppText(
                'الابواب ' '(${model?.course?.chapters?.length ?? 'loading...'})',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: w700,
                ),
              ),
            ),
            10.sbH,
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: model?.course?.chapters?.length ?? 0,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(8),
                separatorBuilder: (c, i) => 16.sbW,
                itemBuilder: (c, courseIndex) {
                  return CourseLessonsCard(
                    onTap: () {
                      setState(() {
                        _expandedIndex =
                            (_expandedIndex == courseIndex) ? -1 : courseIndex;
                      });
                    },
                    name: model?.course?.chapters?[courseIndex].title ?? '',
                    description:  '',
                    courseIndex: courseIndex,
                    model: model?.course?.chapters,
                    isExpanded:
                        _expandedIndex == courseIndex, // Pass expanded state
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
