import 'package:elhanbly/models/home_entities/courses/get_course_data_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../../../core/util/responsive/responsive_helper.dart';
import '../../../../../../../../../../core/widgets/app_bar/custom_curved_appbar.dart';
import '../../../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../../../core/widgets/app_texts/text_scroll.dart';
import '../../../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import 'lesson_card.dart';

class LessonProfile extends StatefulWidget {
  final Lesson lesson;
  final String title2;

  const LessonProfile({
    super.key,
    required this.lesson,
    required this.title2,
  });

  @override
  State<LessonProfile> createState() => _LessonProfileState();
}

class _LessonProfileState extends State<LessonProfile> {
  @override
  Widget build(BuildContext context) {
    final List<Session> sessions = widget.lesson.sessions ?? <Session>[];
    final int totalSessions = sessions.length;

    // Responsive helpers
    final bool isTablet = AppResponsive.isTabletOrLarger(context);
    final bool isLandscape = AppResponsive.isLandscape(context);
    final bool isMobileLandscape = AppResponsive.isMobileLandscape(context);
    final bool useGrid = (isTablet && isLandscape) || (AppResponsive.width(context) >= 900);

    // Calculate aggregated stats
    int totalDuration = 0;
    int completedSessions = 0;
    int totalProgress = 0;

    for (final Session session in sessions) {
      totalDuration += session.durationMinutes ?? 0;
      final int prog = session.progressPercent ?? 0;
      if (prog >= 100) {
        completedSessions++;
      }
      totalProgress += prog;
    }

    final int avgProgress = totalSessions > 0 ? (totalProgress / totalSessions).round() : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextScroll(
              widget.lesson.title ?? 'تفاصيل الدرس',
              size: isTablet ? 20.sp : (isMobileLandscape ? 16.sp : 22.sp),
              weight: FontWeight.w700,
              color: AppColors.kWhite,
              align: TextAlign.start,
              mode: TextScrollMode.begin,
            ),
            if (widget.title2.trim().isNotEmpty) ...[
              4.sbH,
              AppTextScroll(
                widget.title2,
                size: isTablet ? 13.sp : (isMobileLandscape ? 11.sp : 13.5.sp),
                weight: FontWeight.w400,
                color: AppColors.kWhite.withValues(alpha: 0.85),
              ),
            ],
          ],
        ),
      ),
      body: Center(
        child: AdaptiveContainer(
          maxWidth: ResponsiveBreakpoints.maxContentWidth,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 24.w : (isMobileLandscape ? 16.w : 16.w),
              vertical: isMobileLandscape ? 10.h : 16.h,
            ),
            children: [
              // 1. Hero Summary Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isTablet ? 20.w : 16.w),
                decoration: BoxDecoration(
                  color: AppColors.kWhite,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Header Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: isTablet ? 52.r : 44.r,
                          height: isTablet ? 52.r : 44.r,
                          decoration: BoxDecoration(
                            color: AppColors.kPrimary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.auto_stories_rounded,
                            color: AppColors.kPrimary,
                            size: isTablet ? 26.sp : 22.sp,
                          ),
                        ),
                        14.sbW,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.title2.trim().isNotEmpty) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: AppText(
                                    widget.title2,
                                    size: isTablet ? 11.sp : 10.5.sp,
                                    weight: FontWeight.w600,
                                    color: AppColors.textColor4,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                4.sbH,
                              ],
                              AppText(
                                widget.lesson.title ?? 'تفاصيل الدرس',
                                size: isTablet ? 17.sp : (isMobileLandscape ? 14.5.sp : 15.5.sp),
                                weight: FontWeight.w700,
                                color: AppColors.textColor,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                align: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    14.sbH,
                    const Divider(color: Color(0xFFF1F5F9), height: 1, thickness: 1),
                    14.sbH,

                    // Stats Row
                    Row(
                      children: [
                        // Total Sessions
                        Expanded(
                          child: _buildStatChip(
                            icon: Icons.play_circle_outline_rounded,
                            label: 'الحصص',
                            value: '$totalSessions ${totalSessions == 1 ? "حصة" : (totalSessions <= 10 ? "حصص" : "حصة")}',
                            color: AppColors.kPrimary,
                            isTablet: isTablet,
                          ),
                        ),
                        8.sbW,
                        // Total Duration
                        if (totalDuration > 0) ...[
                          Expanded(
                            child: _buildStatChip(
                              icon: Icons.schedule_rounded,
                              label: 'إجمالي المدة',
                              value: '$totalDuration دقيقة',
                              color: const Color(0xFF0284C7),
                              isTablet: isTablet,
                            ),
                          ),
                          8.sbW,
                        ],
                        // Completed / Progress
                        Expanded(
                          child: _buildStatChip(
                            icon: Icons.trending_up_rounded,
                            label: completedSessions > 0 ? 'الإنجاز ($completedSessions/$totalSessions)' : 'نسبة الإنجاز',
                            value: '$avgProgress%',
                            color: avgProgress >= 100 ? const Color(0xFF16A34A) : const Color(0xFFEA580C),
                            isTablet: isTablet,
                          ),
                        ),
                      ],
                    ),

                    // Overall progress bar if sessions exist
                    if (totalSessions > 0) ...[
                      12.sbH,
                      LinearPercentIndicator(
                        lineHeight: 5.h,
                        percent: (avgProgress.clamp(0, 100)) / 100.0,
                        barRadius: Radius.circular(8.r),
                        isRTL: true,
                        progressColor: avgProgress >= 100 ? const Color(0xFF16A34A) : AppColors.kPrimary,
                        backgroundColor: const Color(0xFFE2E8F0),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ],
                ),
              ),
              (isMobileLandscape ? 12.0 : 18.0).sbH,

              // 2. Section Header: "محتويات الدرس"
              Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  8.sbW,
                  AppText(
                    'محتويات الدرس',
                    size: isTablet ? 16.5.sp : 15.5.sp,
                    weight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: AppText(
                      '$totalSessions ${totalSessions == 1 ? "حصة" : (totalSessions <= 10 ? "حصص" : "حصة")}',
                      size: isTablet ? 12.sp : 11.5.sp,
                      weight: FontWeight.w600,
                      color: AppColors.kPrimary,
                    ),
                  ),
                ],
              ),
              10.sbH,

              // 3. Content: Sessions list or 2-column grid in tablet landscape / wide screens
              if (sessions.isEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: AppColors.kWhite,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 54.r,
                        height: 54.r,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.video_collection_outlined,
                          size: 26.sp,
                          color: AppColors.textColor4,
                        ),
                      ),
                      12.sbH,
                      AppText(
                        'لا توجد حصص مضافة لهذا الدرس بعد',
                        size: 13.5.sp,
                        weight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                      6.sbH,
                      AppText(
                        'سيتم نشر محتوى الحصص والملفات قريباً',
                        size: 12.sp,
                        color: AppColors.textColor4,
                      ),
                    ],
                  ),
                ),
              ] else if (useGrid) ...[
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: 2.7,
                  ),
                  itemCount: sessions.length,
                  itemBuilder: (context, i) {
                    return LessonCard(
                      model: sessions[i],
                      index: i,
                      onPurchased: () => setState(() {}),
                    );
                  },
                ),
              ] else ...[
                ...List.generate(
                  sessions.length,
                  (i) => LessonCard(
                    model: sessions[i],
                    index: i,
                    onPurchased: () {
                      setState(() {});
                    },
                  ),
                ),
              ],
              24.sbH,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isTablet = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: isTablet ? 14.sp : 12.sp, color: color),
              4.sbW,
              Flexible(
                child: AppText(
                  label,
                  size: isTablet ? 10.5.sp : 9.5.sp,
                  color: AppColors.textColor4,
                  weight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          4.sbH,
          AppText(
            value,
            size: isTablet ? 12.5.sp : 11.5.sp,
            weight: FontWeight.w700,
            color: color,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
