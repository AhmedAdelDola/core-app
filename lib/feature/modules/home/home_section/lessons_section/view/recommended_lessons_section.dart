import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../core/consts/images.dart';
import '../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../cubit/home_cubit/home_cubit.dart';
import '../../../widgets/show_all_widget.dart';
import '../widgets/recommended_lessons_card.dart';
import 'all_recommended_lessons.dart';

class RecommendedLessonsSection extends StatelessWidget {
  const RecommendedLessonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.sizeOf(context).width >= 600;

    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final cubit = HomeCubit.of(context);
        final model = cubit.home?.suggestedSessions;
        final isEmpty = model == null || model.isEmpty;

        return Column(
          children: [
            ShowAllWidget(
              'الحصص المقترحة',
              isEmpty
                  ? null
                  : () {
                      NamedNavigatorImpl.push(
                        BlocProvider.value(
                          value: cubit,
                          child: const AllRecommendedLessonsScreen(),
                        ),
                      );
                    },
            ),
            SizedBox(height: isLargeScreen ? 14.h : 10.h),
            if (isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 120.h,
                      child: LottieBuilder.asset(
                        AppJsonFiles.emptyState,
                        fit: BoxFit.contain,
                      ),
                    ),
                    8.sbH,
                    AppText(
                      'لا توجد حصص متاحة حالياً',
                      style: TextStyles.textViewRegular(
                        fontSize: 14.sp,
                        color: AppColors.textColor2,
                      ),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                height: isLargeScreen ? 220.h : 200.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: isLargeScreen ? 20.w : 16.w,
                  ),
                  itemCount: model.length,
                  itemBuilder: (c, i) => RecommendedLessonsCard(
                    model: model[i],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
