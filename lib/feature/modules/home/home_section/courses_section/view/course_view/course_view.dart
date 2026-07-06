import 'package:elhanbly/core/navigator/named_navigator_impl.dart';
import 'package:elhanbly/feature/modules/profile/cubit/wallet_cubit/wallet_cubit.dart';
import 'package:elhanbly/feature/modules/profile/pages/wallet/pages/charge_wallet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                      title: model?.course?.title ?? '',
                      imagesUrlsLength: 2,

                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 357.h),
                      Container(
                        decoration: const BoxDecoration(
                          color: AppColors.kWhite,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
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
                : BlocBuilder<WalletCubit, WalletState>(
                    builder: (context, walletState) {
                      final walletCubit = context.read<WalletCubit>();
                      final balance = double.tryParse(
                            '${walletCubit.wallet?.wallet?.balance ?? '0'}') ??
                          0.0;
                      final price = double.tryParse(
                            '${model?.course?.price ?? '0'}') ??
                          0.0;

                      return MasterButton(
                        onPressed: () async {
                          if (walletCubit.wallet == null) {
                            await walletCubit.getWalletHistory();
                          }

                          final freshBalance = double.tryParse(
                                '${walletCubit.wallet?.wallet?.balance ?? '0'}') ??
                              0.0;

                          if (price == 0) {
                            await walletCubit.purchaseProduct(
                              type: 'course',
                              id: model?.course?.id.toString() ?? '',
                            );
                            await cubit.getCourseData(id.toString());
                          } else if (freshBalance < price) {
                            NamedNavigatorImpl.push(
                              ChargeWalletScreen(cubit: walletCubit),
                            );
                          } else {
                            await walletCubit.purchaseProduct(
                              type: 'course',
                              id: model?.course?.id.toString() ?? '',
                            );
                          await cubit.getCourseData(id.toString());                          }
                        },
                        text:
                            '  اشترك الان (${model?.course?.price != 0 ? '${model?.course?.price} جنيه' : 'مجانا'}  )',
                        margin: EdgeInsets.all(25.sp),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
