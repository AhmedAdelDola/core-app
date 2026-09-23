import 'package:elhanbly/models/home_entities/courses/get_course_data_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import 'lesson_profile/lesson_profile.dart';

class CourseLessonsCard extends StatelessWidget {
  final VoidCallback onTap;
  final String name, description;
  final int courseIndex;
  final List<Chapter>? model;
  final bool isExpanded;

  const CourseLessonsCard({
    super.key,
    required this.onTap,
    required this.name,
    required this.description,
    required this.courseIndex,
    required this.model,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final int lessonsCount = (model != null && courseIndex < model!.length)
        ? (model![courseIndex].lessons?.length ?? 0)
        : 0;

    final lessons = (model != null && courseIndex < model!.length)
        ? (model![courseIndex].lessons ?? <Lesson>[])
        : <Lesson>[];

    // Compute total sessions in this chapter
    int totalSessions = 0;
    for (final Lesson l in lessons) {
      totalSessions += (l.sessions?.length ?? 0);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isExpanded
              ? AppColors.kPrimary.withOpacity(0.4)
              : const Color(0xFFE2E8F0),
          width: isExpanded ? 1.4 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isExpanded
                ? AppColors.kPrimary.withOpacity(0.06)
                : Colors.black.withOpacity(0.02),
            blurRadius: isExpanded ? 10 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chapter Header (Tap to expand/collapse)
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.r),
                bottom: Radius.circular(isExpanded ? 0 : 16.r),
              ),
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                child: Row(
                  children: [
                    // Chapter Number Badge
                    Container(
                      width: 38.r,
                      height: 38.r,
                      decoration: BoxDecoration(
                        color: isExpanded
                            ? AppColors.kPrimary
                            : AppColors.kPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      alignment: Alignment.center,
                      child: AppText(
                        '${courseIndex + 1}'.padLeft(2, '0'),
                        size: 13.5.sp,
                        weight: FontWeight.w700,
                        color: isExpanded ? AppColors.kWhite : AppColors.kPrimary,
                      ),
                    ),
                    12.sbW,

                    // Chapter Title & Info Row
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            name.isNotEmpty ? name : 'الباب ${courseIndex + 1}',
                            size: 14.5.sp,
                            weight: FontWeight.w700,
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.textColor,
                          ),
                          4.sbH,
                          Row(
                            children: [
                              Icon(
                                Icons.menu_book_outlined,
                                size: 13.sp,
                                color: AppColors.textColor4,
                              ),
                              4.sbW,
                              AppText(
                                '$lessonsCount ${lessonsCount == 1 ? "درس" : (lessonsCount <= 10 ? "دروس" : "درس")}',
                                size: 11.5.sp,
                                color: AppColors.textColor4,
                                weight: FontWeight.w500,
                              ),
                              if (totalSessions > 0) ...[
                                6.sbW,
                                AppText(
                                  '•',
                                  size: 11.sp,
                                  color: AppColors.textColor4,
                                ),
                                6.sbW,
                                Icon(
                                  Icons.play_circle_outline_rounded,
                                  size: 13.sp,
                                  color: AppColors.textColor4,
                                ),
                                4.sbW,
                                AppText(
                                  '$totalSessions ${totalSessions == 1 ? "حصة" : "حصص"}',
                                  size: 11.5.sp,
                                  color: AppColors.textColor4,
                                  weight: FontWeight.w500,
                                ),
                              ],
                              if (description.trim().isNotEmpty) ...[
                                6.sbW,
                                Expanded(
                                  child: AppText(
                                    '• $description',
                                    size: 11.5.sp,
                                    color: AppColors.textColor4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    8.sbW,

                    // Expand / Collapse Chevron Button
                    Container(
                      width: 32.r,
                      height: 32.r,
                      decoration: BoxDecoration(
                        color: isExpanded
                            ? AppColors.kPrimary.withOpacity(0.1)
                            : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: isExpanded ? 0.5 : 0.0,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: isExpanded ? AppColors.kPrimary : AppColors.textColor2,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Expanded Lessons Section: Modern Timeline / Curriculum List (NO NESTED CARDS!)
          if (isExpanded) ...[
            Divider(color: const Color(0xFFF1F5F9), height: 1.h, thickness: 1.h),
            if (lessons.isEmpty) ...[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 16.sp,
                        color: AppColors.textColor4,
                      ),
                      8.sbW,
                      AppText(
                        'لا توجد دروس مضافة لهذا الباب حالياً',
                        size: 12.5.sp,
                        color: AppColors.textColor4,
                        weight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 12.h),
                child: Column(
                  children: List.generate(lessons.length, (index) {
                    final lesson = lessons[index];
                    final isFirst = index == 0;
                    final isLast = index == lessons.length - 1;
                    final sessionsCount = lesson.sessions?.length ?? 0;

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10.r),
                        onTap: () {
                          NamedNavigatorImpl.push(
                            LessonProfile(
                              lesson: lesson,
                              title2: model?[courseIndex].title ?? '',
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 6.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Timeline Track & Node
                              SizedBox(
                                width: 28.w,
                                height: 44.h,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Track line
                                    Positioned(
                                      top: isFirst ? 22.h : 0,
                                      bottom: isLast ? 22.h : 0,
                                      child: Container(
                                        width: 2.w,
                                        color: const Color(0xFFE2E8F0),
                                      ),
                                    ),
                                    // Circular node
                                    Container(
                                      width: 24.r,
                                      height: 24.r,
                                      decoration: BoxDecoration(
                                        color: AppColors.kWhite,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.kPrimary,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.kPrimary.withOpacity(0.12),
                                            blurRadius: 3,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.play_arrow_rounded,
                                        color: AppColors.kPrimary,
                                        size: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              10.sbW,

                              // Lesson Title & metadata
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      lesson.title ?? 'درس ${index + 1}',
                                      size: 13.5.sp,
                                      weight: FontWeight.w600,
                                      color: AppColors.textColor,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (sessionsCount > 0) ...[
                                      4.sbH,
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 2.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF1F5F9),
                                              borderRadius: BorderRadius.circular(6.r),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.videocam_outlined,
                                                  size: 11.sp,
                                                  color: AppColors.textColor4,
                                                ),
                                                4.sbW,
                                                AppText(
                                                  '$sessionsCount ${sessionsCount == 1 ? "حصة" : "حصص"}',
                                                  size: 11.sp,
                                                  color: AppColors.textColor2,
                                                  weight: FontWeight.w500,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              // Trailing sleek Action Pill
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.kPrimary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppText(
                                      'مشاهدة',
                                      size: 11.sp,
                                      color: AppColors.kPrimary,
                                      weight: FontWeight.w600,
                                    ),
                                    2.sbW,
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 9.sp,
                                      color: AppColors.kPrimary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
