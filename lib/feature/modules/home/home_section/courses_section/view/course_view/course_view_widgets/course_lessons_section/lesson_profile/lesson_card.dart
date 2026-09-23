import 'package:elhanbly/core/util/responsive/responsive_helper.dart';
import 'package:elhanbly/models/home_entities/courses/get_course_data_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../../../core/widgets/purchase_modal/course_purchase_modal.dart';
import '../../../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../../../../lessons_section/widgets/lesson_screen.dart';
import '../../../../../../lessons_section/widgets/session_screen.dart';

class LessonCard extends StatelessWidget {
  final Session? model;
  final int? index;
  final VoidCallback? onPurchased;

  const LessonCard({
    super.key,
    required this.model,
    this.index,
    this.onPurchased,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTablet = AppResponsive.isTabletOrLarger(context);
    final bool isMobileLandscape = AppResponsive.isMobileLandscape(context);
    final bool isLocked = model?.canAccess == false;
    final String type = model?.type ?? 'recorded_video';
    final int progress = model?.progressPercent ?? 0;
    final bool isCompleted = progress >= 100;
    final int duration = model?.durationMinutes ?? 0;

    // Type styling resolution
    IconData typeIcon;
    Color typeColor;
    Color typeBgColor;
    String typeLabel;

    switch (type) {
      case 'pdf':
        typeIcon = Icons.picture_as_pdf_rounded;
        typeColor = const Color(0xFFE53935);
        typeBgColor = const Color(0xFFFDE8E8);
        typeLabel = 'ملف PDF';
        break;
      case 'Homework':
      case 'quiz':
        typeIcon = Icons.assignment_turned_in_rounded;
        typeColor = const Color(0xFFE65100);
        typeBgColor = const Color(0xFFFFF3E0);
        typeLabel = 'واجب / اختبار';
        break;
      case 'recorded_video':
      default:
        typeIcon = Icons.play_arrow_rounded;
        typeColor = AppColors.kPrimary;
        typeBgColor = AppColors.kPrimary.withValues(alpha: 0.1);
        typeLabel = 'فيديو مسجل';
        break;
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: isMobileLandscape ? 4.h : 6.h),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isLocked ? const Color(0xFFE2E8F0) : AppColors.kPrimary.withValues(alpha: 0.25),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: () {
            if (isLocked) {
              CoursePurchaseModal.show(
                context: context,
                type: PurchaseTargetType.session,
                id: model?.id?.toString() ?? '0',
                title: model?.title ?? '',
                price: model?.price ?? model?.singleSessionPrice ?? '0',
                onSuccess: () {
                  model?.canAccess = true;
                  onPurchased?.call();
                },
              );
              return;
            }

            if (model?.isPublished != false) {
              switch (type) {
                case 'pdf':
                  NamedNavigatorImpl.push(LessonDetailsScreen(
                    id: model?.id ?? 0,
                    title: model?.title ?? '',
                    subTitle: typeLabel,
                  ));
                  break;
                case 'Homework':
                case 'quiz':
                  NamedNavigatorImpl.push(LessonDetailsScreen(
                    id: model?.id ?? 0,
                    title: model?.title ?? '',
                    subTitle: typeLabel,
                  ));
                  break;
                case 'recorded_video':
                default:
                  NamedNavigatorImpl.push(SessionDetilesScreen(
                    id: model?.id ?? 0,
                    title: model?.title ?? '',
                    subTitle: typeLabel,
                  ));
                  break;
              }
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 14.w : 12.w,
              vertical: isMobileLandscape ? 8.h : (isTablet ? 14.h : 12.h),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Leading Icon / Node
                Container(
                  width: isTablet ? 48.r : 44.r,
                  height: isTablet ? 48.r : 44.r,
                  decoration: BoxDecoration(
                    color: isLocked ? const Color(0xFFF1F5F9) : typeBgColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isLocked ? const Color(0xFFE2E8F0) : typeColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: isLocked
                      ? Icon(Icons.lock_rounded,
                          color: AppColors.textColor4, size: isTablet ? 22.sp : 20.sp)
                      : Icon(typeIcon,
                          color: typeColor, size: isTablet ? 26.sp : 24.sp),
                ),
                12.sbW,

                // Main Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top Row: Type Pill + Duration / Lock price
                      Row(
                        children: [
                          if (index != null) ...[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: AppText(
                                'حصة ${(index! + 1).toString().padLeft(2, '0')}',
                                size: isTablet ? 10.5.sp : 10.sp,
                                weight: FontWeight.w700,
                                color: AppColors.textColor4,
                              ),
                            ),
                            6.sbW,
                          ],
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: isLocked ? const Color(0xFFF1F5F9) : typeBgColor,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: AppText(
                              typeLabel,
                              size: isTablet ? 10.5.sp : 10.sp,
                              weight: FontWeight.w600,
                              color: isLocked ? AppColors.textColor4 : typeColor,
                            ),
                          ),
                          if (duration > 0) ...[
                            6.sbW,
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.schedule_rounded,
                                      size: isTablet ? 11.sp : 10.sp, color: AppColors.textColor4),
                                  3.sbW,
                                  AppText(
                                    '$duration دقيقة',
                                    size: isTablet ? 10.5.sp : 10.sp,
                                    color: AppColors.textColor2,
                                    weight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const Spacer(),
                          // Locked Price or Status
                          if (isLocked) ...[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF7ED),
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(color: const Color(0xFFFDBA74)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.lock_outline_rounded,
                                      size: 10.sp, color: const Color(0xFFC2410C)),
                                  3.sbW,
                                  AppText(
                                    (model?.price != null && model?.price != '0')
                                        ? '${model?.price} ج.م'
                                        : 'مقفلة',
                                    size: isTablet ? 10.sp : 9.5.sp,
                                    color: const Color(0xFFC2410C),
                                    weight: FontWeight.w700,
                                  ),
                                ],
                              ),
                            ),
                          ] else if (isCompleted) ...[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle_rounded,
                                      size: 11.sp, color: const Color(0xFF15803D)),
                                  3.sbW,
                                  AppText(
                                    'مكتمل',
                                    size: isTablet ? 10.sp : 9.5.sp,
                                    color: const Color(0xFF15803D),
                                    weight: FontWeight.w700,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      6.sbH,

                      // Session Title
                      AppText(
                        model?.title ?? 'حصة بدون عنوان',
                        size: isTablet ? 14.5.sp : 13.5.sp,
                        weight: FontWeight.w700,
                        color: AppColors.textColor,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        align: TextAlign.start,
                      ),

                      // Progress indicator (if unlocked and not yet 100%)
                      if (!isLocked && progress > 0 && !isCompleted) ...[
                        6.sbH,
                        Row(
                          children: [
                            Expanded(
                              child: LinearPercentIndicator(
                                lineHeight: 4.h,
                                percent: (progress.clamp(0, 100)) / 100.0,
                                barRadius: Radius.circular(8.r),
                                isRTL: true,
                                progressColor: AppColors.kPrimary,
                                backgroundColor: const Color(0xFFE2E8F0),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            8.sbW,
                            AppText(
                              '$progress%',
                              size: isTablet ? 11.sp : 10.5.sp,
                              weight: FontWeight.w600,
                              color: AppColors.kPrimary,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                8.sbW,

                // Trailing Action Icon
                Container(
                  width: isTablet ? 36.r : 32.r,
                  height: isTablet ? 36.r : 32.r,
                  decoration: BoxDecoration(
                    color: isLocked
                        ? const Color(0xFFF1F5F9)
                        : AppColors.kPrimary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    isLocked ? Icons.lock_outline_rounded : Icons.arrow_forward_ios_rounded,
                    size: isTablet ? 14.sp : 13.sp,
                    color: isLocked ? AppColors.textColor4 : AppColors.kPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
