import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elhanbly/core/widgets/app_bar/default_app_bar.dart/default_app_bar.dart';
import 'package:elhanbly/core/widgets/app_buttons/master_button.dart';
import 'package:elhanbly/core/widgets/loader/app_loader.dart';

import '../../core/navigator/named_navigator_impl.dart';
import '../../core/navigator/named_navigator_routes.dart';
import '../../core/theme/colors/app_colors.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/app_texts/app_text.dart';
import '../modules/home/home_section/courses_section/widgets/course_card_item.dart';
import 'cubit/guest_home_cubit.dart';

import '../../core/services/di.dart';
import '../../core/network/repository/repository_imports.dart';
import '../home_layout/cubit/home_lay_out_cubit.dart';

class GuestHomeScreen extends StatefulWidget {
  const GuestHomeScreen({super.key});

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GuestHomeCubit()..getCourses()),
        BlocProvider(create: (context) => BottomBarCubit(di<Repository>())),
      ],
      child: Scaffold(
        appBar: DefaultAppBar(
          action: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: MasterButton(
                  width: 120.w,
                  height: 36.h,
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  buttonRadius: 8.r,
                  text: 'تسجيل الدخول',
                  textStyle: TextStyles.textViewMedium(
                    fontSize: 13.sp,
                    color: AppColors.kWhite,
                  ),
                  onPressed: () {
                    NamedNavigatorImpl.pushNamed(Routes.login);
                  },
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<GuestHomeCubit, GuestHomeState>(
          builder: (context, state) {
            if (state is GuestHomeLoading) {
              return const Center(child: AppLoader());
            }
            if (state is GuestHomeError) {
              return Center(
                child: AppText(
                  state.message,
                  style: TextStyles.textViewRegular(
                    fontSize: 16.sp,
                    color: AppColors.kRed,
                  ),
                ),
              );
            }
            if (state is GuestHomeLoaded) {
              final featuredCourses = state.response.courses;
              if (featuredCourses.isEmpty) {
                return Center(
                  child: AppText(
                    'لا يوجد دورات متاحة حاليا',
                    style: TextStyles.textViewRegular(
                      fontSize: 16.sp,
                      color: AppColors.textColor5,
                    ),
                  ),
                );
              }
              return Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'الدورات المميزة',
                      style: TextStyles.textViewBold(
                        size: 18.sp,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = constraints.maxWidth >= 900
                              ? 3
                              : 2;
                          const spacing = 10.0;
                          final cardWidth =
                              (constraints.maxWidth -
                                  (crossAxisCount - 1) * spacing) /
                              crossAxisCount;
                          // Phone cards use larger text and teacher avatars than
                          // tablet cards, so reserve enough room for their details.
                          final detailsHeight = constraints.maxWidth < 600
                              ? 118.0
                              : 108.0;
                          final cardHeight =
                              cardWidth * (9 / 16) + detailsHeight;

                          return GridView.builder(
                            padding: EdgeInsets.only(bottom: 16.h),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: spacing,
                                  mainAxisSpacing: spacing,
                                  mainAxisExtent: cardHeight,
                                ),
                            itemCount: featuredCourses.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (dialogContext) => Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20.w),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AppText(
                                              'تنبيه',
                                              style: TextStyles.textViewBold(
                                                size: 18.sp,
                                                color: AppColors.kPrimary,
                                              ),
                                            ),
                                            SizedBox(height: 12.h),
                                            AppText(
                                              'يرجى تسجيل الدخول أولاً لتتمكن من تصفح هذه الدورة.',
                                              style: TextStyles.textViewMedium(
                                                fontSize: 14.sp,
                                                color: AppColors.textColor,
                                              ),
                                              align: TextAlign.center,
                                            ),
                                            SizedBox(height: 20.h),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(
                                                          dialogContext,
                                                        ).pop(),
                                                    child: AppText(
                                                      'إلغاء',
                                                      style:
                                                          TextStyles.textViewMedium(
                                                            fontSize: 14.sp,
                                                            color: AppColors
                                                                .textColor5,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                Expanded(
                                                  child: MasterButton(
                                                    text: 'تسجيل الدخول',
                                                    textStyle:
                                                        TextStyles.textViewMedium(
                                                          fontSize: 13.sp,
                                                          color:
                                                              AppColors.kWhite,
                                                        ),

                                                    onPressed: () {
                                                      Navigator.of(
                                                        dialogContext,
                                                      ).pop();
                                                      NamedNavigatorImpl.pushNamed(
                                                        Routes.login,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: CourseCardItem(
                                  model: featuredCourses[index],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
