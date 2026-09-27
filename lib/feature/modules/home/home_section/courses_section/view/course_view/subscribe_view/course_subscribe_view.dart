import 'dart:math' as math;
import 'package:elhanbly/feature/modules/quizes/course_exams_tab.dart';

import '../../../../../../../../core/consts/images.dart';
import '../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../core/util/responsive/responsive_helper.dart';
import '../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../cubit/courses_section_cubit.dart';
import 'tabs/about_course_tab.dart';
import 'tabs/lessons_tab.dart';

class SubscribeView extends StatefulWidget {
  final int? initialTabIndex;

  const SubscribeView({
    super.key,
    this.initialTabIndex,
  });

  @override
  State<SubscribeView> createState() => _SubscribeViewState();
}

class _SubscribeViewState extends State<SubscribeView>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    final int initIdx = (widget.initialTabIndex != null &&
            widget.initialTabIndex! >= 0 &&
            widget.initialTabIndex! < 3)
        ? widget.initialTabIndex!
        : 0;
    _controller = TabController(length: 3, vsync: this, initialIndex: initIdx);
    super.initState();
  }

  final List<String> _tabsTitle = [
    'الابواب',
    'الامتحانات',
    'عن الكورس',
  ];

  @override
  Widget build(BuildContext context) {
    final model = CoursesSectionCubit.of(context).courseData;
    final isTablet = AppResponsive.isTabletOrLarger(context);
    final isMobileLandscape = AppResponsive.isMobileLandscape(context);
    final isLandscape = AppResponsive.isLandscape(context);
    final screenH = MediaQuery.sizeOf(context).height;
    final tabHeight = isTablet
        ? (isLandscape ? math.max(650.0, screenH * 0.82) : math.max(600.0, screenH * 0.75))
        : (isLandscape ? math.max(480.0, screenH * 0.75) : math.max(420.0, screenH * 0.62));

    return Center(
      child: AdaptiveContainer(
        maxWidth: ResponsiveBreakpoints.maxContentWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobileLandscape ? 10 : (isTablet ? 20 : 16),
            horizontal: isTablet ? 16 : 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      model?.course?.title ?? '',
                      weight: w700,
                      size: isTablet ? 22.sp : (isMobileLandscape ? 17.sp : 26.sp),
                      color: AppColors.kBlack,
                    ),
                    (isMobileLandscape ? 6.0 : (isTablet ? 12.0 : 16.0)).sbH,
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppImages.favDoctorIcon,
                          colorFilter: const ColorFilter.mode(
                            AppColors.textColor2,
                            BlendMode.srcIn,
                          ),
                          width: isTablet ? 22.r : 18.r,
                          height: isTablet ? 22.r : 18.r,
                        ),
                        8.sbW,
                        AppText(
                          model?.course?.teacher?.name ?? '',
                          size: isTablet ? 15.sp : (isMobileLandscape ? 13.sp : 15.sp),
                          weight: w400,
                          color: AppColors.textColor2,
                        ),
                      ],
                    ),
                    (isMobileLandscape ? 10.0 : (isTablet ? 16.0 : 20.0)).sbH,
                    Container(
                      height: isMobileLandscape ? 38.0 : (isTablet ? 44.0 : 46.h),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(230, 234, 239, 0.5),
                        border: Border.all(color: AppColors.kPrimary.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: TabBar(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _controller,
                        indicatorColor: Colors.transparent,
                        indicator: BoxDecoration(
                          color: AppColors.kWhite,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        labelColor: AppColors.kPrimary,
                        unselectedLabelColor: AppColors.textColor2,
                        tabs: List.generate(
                          _tabsTitle.length,
                          (i) => AppText(
                            _tabsTitle[i],
                            weight: w700,
                            size: isTablet ? 13.5.sp : 13.5.sp,
                          ),
                        ),
                      ),
                    ),
                    (isMobileLandscape ? 12.0 : 18.0).sbH,
                  ],
                ),
              ),
              SizedBox(
                height: tabHeight,
                child: TabBarView(
                  controller: _controller,
                  children: [
                    const LessonsTab(),
                    CourseExamsTab(courseId: model?.course?.id),
                    AboutCourseTab(
                      Description: model?.course?.description ?? '',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
