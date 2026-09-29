import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';

import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../../../core/consts/images.dart';
import '../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../core/theme/theme.dart';
import '../../../../../../../../core/util/launcher.dart';
import '../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../core/widgets/loader/app_loader.dart';
import '../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../cubit/courses_section_cubit.dart';
import 'course_details_instructor.dart';

class CourseHeader extends StatelessWidget {
  const CourseHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesSectionCubit, CoursesSectionState>(
      builder: (context, state) {
        final cubit = CoursesSectionCubit.of(context);
        final model = cubit.courseData;
        final description = model?.course?.description?.trim();
        final hasDescription = description != null && description.isNotEmpty && description != '0';

        if (state is GetCourseRateReviewLoadingState) {
          return const AppLoader();
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.sbH,
              AppText(
                model?.course?.title ?? '',
                color: AppColors.textColor,
                size: 22.sp,
                weight: FontWeight.bold,
                align: TextAlign.start,
              ),
              if (model?.course?.stage?.name != null || model?.course?.level?.name != null) ...[
                10.sbH,
                Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  children: [
                    if (model?.course?.stage?.name != null && model!.course!.stage!.name!.isNotEmpty)
                      _buildChip(
                        model!.course!.stage!.name!.contains('مرحلة')
                            ? model!.course!.stage!.name!
                            : 'المرحلة: ${model!.course!.stage!.name!}',
                        AppColors.kPrimary.withOpacity(0.1),
                        AppColors.kPrimary,
                        icon: Icons.school_outlined,
                      ),
                    if (model?.course?.level?.name != null && model!.course!.level!.name!.isNotEmpty)
                      _buildChip(
                        model!.course!.level!.name!.contains('صف') || model!.course!.level!.name!.contains('الصف')
                            ? model!.course!.level!.name!
                            : 'الصف: ${model!.course!.level!.name!}',
                        Colors.grey.shade100,
                        AppColors.textColor2,
                        icon: Icons.layers_outlined,
                      ),
                  ],
                ),
              ],
              // Course content stats from chapters & lessons
              Builder(
                builder: (context) {
                  final chapters = model?.course?.chapters ?? [];
                  final int chaptersCount = chapters.length;
                  int lessonsCount = 0;
                  int sessionsCount = 0;
                  for (final ch in chapters) {
                    final les = ch.lessons ?? [];
                    lessonsCount += les.length;
                    for (final l in les) {
                      sessionsCount += (l.sessions?.length ?? 0);
                    }
                  }

                  if (chaptersCount == 0 && lessonsCount == 0 && sessionsCount == 0) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (chaptersCount > 0)
                            _buildStatItem(
                              Icons.folder_open_rounded,
                              '$chaptersCount',
                              chaptersCount == 1 ? 'باب' : (chaptersCount <= 10 ? 'أبواب' : 'باب'),
                            ),
                          if (lessonsCount > 0)
                            _buildStatItem(
                              Icons.menu_book_rounded,
                              '$lessonsCount',
                              lessonsCount == 1 ? 'درس' : (lessonsCount <= 10 ? 'دروس' : 'درس'),
                            ),
                          if (sessionsCount > 0)
                            _buildStatItem(
                              Icons.play_circle_outline_rounded,
                              '$sessionsCount',
                              sessionsCount == 1 ? 'حصة' : (sessionsCount <= 10 ? 'حصص' : 'حصة'),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              if (model?.course?.teacher != null) ...[
                12.sbH,
                CourseInstructor(
                  avatar: model?.course?.teacher?.imageUrl ?? '',
                  name: model?.course?.teacher?.name ?? 'المحاضر',
                ),
              ],
              if ((model?.course?.whatsapp != null && model!.course!.whatsapp!.isNotEmpty) ||
                  (model?.course?.teacher?.whatsapp != null && model!.course!.teacher!.whatsapp!.isNotEmpty)) ...[
                10.sbH,
                InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: () {
                    final num = model?.course?.whatsapp ?? model?.course?.teacher?.whatsapp ?? '';
                    AppLauncher.launchWhatsApp(
                      number: num,
                      message: 'مرحباً، أود الاشتراك في كورس: ${model?.course?.title ?? ''}',
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: const Color(0xFF25D366).withOpacity(0.35),
                        width: 1.1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(7.r),
                          decoration: const BoxDecoration(
                            color: Color(0xFF25D366),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            AppImages.whatsappSvg,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                            width: 16.r,
                            height: 16.r,
                          ),
                        ),
                        10.sbW,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'تواصل معنا للاشتراك في الكورس',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1B6B2B),
                                ),
                              ),
                              2.sbH,
                              Text(
                                'اضغط هنا لفتح واتساب والاشتراك مع الدعم',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.textColor2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF25D366),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            model?.course?.whatsappButtonText ?? 'للاشتراك',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (hasDescription) ...[
                12.sbH,
                AppText(
                  'عن الكورس',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                6.sbH,
                ReadMoreText(
                  description,
                  trimMode: TrimMode.Line,
                  trimLines: 3,
                  colorClickableText: AppColors.kPrimary,
                  trimCollapsedText: 'عرض المزيد',
                  trimExpandedText: 'عرض أقل',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor2,
                    height: 1.5,
                  ),
                  moreStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kPrimary,
                  ),
                  lessStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kPrimary,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(String label, Color bg, Color textCol, {IconData? icon}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14.r, color: textCol),
            5.sbW,
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: textCol,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String count, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.r, color: AppColors.kPrimary),
        6.sbW,
        Text(
          '$count $label',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }
}
