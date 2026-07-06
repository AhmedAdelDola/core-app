import '../../../../../../../../core/consts/images.dart';
import '../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../library/library_imports.dart';
import '../../../cubit/courses_section_cubit.dart';
import 'tabs/about_course_tab.dart';
import 'tabs/community_tab.dart';
import 'tabs/course_files.dart';
import 'tabs/lessons_tab.dart';

class SubscribeView extends StatefulWidget {
  const SubscribeView({super.key});

  @override
  State<SubscribeView> createState() => _SubscribeViewState();
}

class _SubscribeViewState extends State<SubscribeView>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  final List<String> _tabsTitle = [
    'الابواب',
   
    'عن الكورس',
  ];

  @override
  Widget build(BuildContext context) {
    final model = CoursesSectionCubit.of(context).courseData;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
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
                  size: 28.sp,
                  color: AppColors.kBlack,
                ),
                18.sbH,
                Row(
                  children: [
                    SvgPicture.asset(
                      AppImages.favDoctorIcon,
                      colorFilter: const ColorFilter.mode(
                        AppColors.textColor2,
                        BlendMode.srcIn,
                      ),
                    ),
                    8.sbW,
                    AppText(
                      model?.course?.teacher?.name ?? '',
                      size: 16.sp,
                      weight: w400,
                      color: AppColors.textColor2,
                    ),
                  ],
                ),
                25.sbH,
                Container(
                  height: 48.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(230, 234, 239, 0.5),
                    border: Border.all(color: AppColors.kPrimary),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: TabBar(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _controller,
                    indicatorColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: AppColors.kWhite,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    labelColor: AppColors.kPrimary,
                    unselectedLabelColor: AppColors.textColor2,
                    tabs: List.generate(
                      _tabsTitle.length,
                      (i) => AppText(_tabsTitle[i], weight: w700, size: 14.sp),
                    ),
                  ),
                ),
                24.sbH,
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height.h * 0.5,
            child: TabBarView(
              controller: _controller,
              children: [
                LessonsTab(),
                // CourseFiles(),
                AboutCourseTab(
                  Description: model?.course?.description ?? '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
