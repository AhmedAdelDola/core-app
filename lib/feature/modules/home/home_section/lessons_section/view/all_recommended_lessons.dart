import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../core/consts/images.dart';
import '../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/widgets/app_bar/custom_curved_appbar.dart';
import '../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../cubit/home_cubit/home_cubit.dart';
import '../widgets/recommended_lessons_card.dart';

class AllRecommendedLessonsScreen extends StatelessWidget {
  const AllRecommendedLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600 && screenWidth < 900;
    final bool isDesktop = screenWidth >= 900;
    final bool isLargeScreen = isTablet || isDesktop;

    int crossAxisCount = 1;
    if (isDesktop) {
      crossAxisCount = 4;
    } else if (isTablet) {
      crossAxisCount = 3;
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'الحصص المقترحة'),
      body: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state) {
          final cubit = HomeCubit.of(context);
          final sessions = cubit.home?.suggestedSessions;

          if (sessions == null || sessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 180.h,
                    child: LottieBuilder.asset(
                      AppJsonFiles.emptyState,
                      fit: BoxFit.contain,
                    ),
                  ),
                  16.sbH,
                  AppText(
                    'لا توجد حصص متاحة حالياً',
                    style: TextStyles.textViewRegular(
                      fontSize: 16.sp,
                      color: AppColors.textColor2,
                    ),
                  ),
                ],
              ),
            );
          }

          return isLargeScreen
              ? GridView.builder(
                  padding: EdgeInsets.all(isDesktop ? 24 : 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: isDesktop ? 20 : 16,
                    mainAxisSpacing: isDesktop ? 20 : 16,
                  ),
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    return RecommendedLessonsCard(
                      model: sessions[index],
                    );
                  },
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Center(
                        child: RecommendedLessonsCard(
                          model: sessions[index],
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
