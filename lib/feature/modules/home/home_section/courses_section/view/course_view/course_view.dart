import 'package:elhanbly/core/navigator/named_navigator_impl.dart';
import 'package:elhanbly/core/widgets/purchase_modal/course_purchase_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/util/responsive/responsive_helper.dart';
import '../../../../../../../core/services/di.dart';
import '../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../core/widgets/app_buttons/master_button.dart';
import '../../../../../../../core/widgets/loader/app_loader.dart';
import '../../../../../../../core/widgets/ui_helpers/alert_message.dart';
import '../../cubit/courses_section_cubit.dart';
import 'course_view_widgets/course_details_image.dart';
import 'course_view_widgets/course_view_appbar.dart';
import 'not_subscribe_view/course_not_subscribe_view.dart';
import 'subscribe_view/course_subscribe_view.dart';

class CourseViewScreen extends StatelessWidget {
  final String id;

  const CourseViewScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<CoursesSectionCubit>()..getAllCourseData(id),
      child: BlocConsumer<CoursesSectionCubit, CoursesSectionState>(
        listener: (context, state) {
          if (state is GetCourseDataErrorState) {
            showErrorToast(state.error);
          }
        },
        builder: (context, state) {
          final cubit= CoursesSectionCubit.of(context);
          final model = CoursesSectionCubit.of(context).courseData;

          if (state is GetCourseDataLoadingState ||
              state is GetCourseRateReviewLoadingState ||
              state is GetCourseChapterLoadingState) {
            return const Scaffold(body: AppLoader());
          }

          return Scaffold(
            body: Stack(
              fit: StackFit.passthrough,
              children: [
                Column(
                  children: [
                    CourseImageWithData(
                      isFree: false,
                      imageUrl: model?.course?.imageUrl,
                      price: model?.course?.price,
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 235.h),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.kWhite,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28.r),
                            topRight: Radius.circular(28.r),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, -3),
                            ),
                          ],
                        ),
                        child: model?.subscription?.hasActiveSubscription == true
                            ? const SubscribeView()
                            : const NotSubscribeView(),
                      ),
                    ],
                  ),
                ),
                customAppBar,
              ],
            ),
            bottomNavigationBar: model?.course?.hasActiveSubscription == true
                ? null
                : AdaptiveContainer(
                    maxWidth: ResponsiveBreakpoints.maxCardWidth,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
                      decoration: BoxDecoration(
                        color: AppColors.kWhite,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: MasterButton(
                        onPressed: () {
                          CoursePurchaseModal.show(
                            context: context,
                            type: PurchaseTargetType.course,
                            id: model?.course?.id?.toString() ?? id,
                            title: model?.course?.title ?? '',
                            price: model?.course?.price?.toString() ?? '0',
                            onSuccess: () {
                              cubit.getAllCourseData(id);
                            },
                          );
                        },
                        text: () {
                          final p = double.tryParse('${model?.course?.price ?? '0'}') ?? 0.0;
                          if (p == 0.0) {
                            return 'اشترك الآن (مجاناً)';
                          }
                          return 'اشترك الآن ($p جنيه)';
                        }(),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
