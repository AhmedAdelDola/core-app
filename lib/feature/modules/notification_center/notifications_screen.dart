import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/services/di.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/theme.dart';
import '../../../core/util/responsive/responsive_helper.dart';
import '../../../core/widgets/app_texts/app_text.dart';
import '../../../core/widgets/loader/shimmer_list_item.dart';
import '../../../core/widgets/ui_helpers/extensions.dart';
import '../../../models/profile/get_notifications_response.dart';
import 'cubit/get_notifications_cubit.dart';
import 'widgets/no_results_widget.dart';
import 'widgets/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final isTablet = AppResponsive.isTablet(context);

    return BlocProvider(
      create: (context) => di<GetNotificationsCubit>()..getNotifications(),
      child: BlocBuilder<GetNotificationsCubit, GetNotificationsState>(
        builder: (context, state) {
          final cubit = context.read<GetNotificationsCubit>();
          final List<AppNotification> notifications = cubit.notificationList;
          final int unreadCount = cubit.unreadCount;

          return AdaptiveContainer(
            maxWidth: 700,
            child: Column(
              children: [
                if (notifications.isNotEmpty && unreadCount > 0) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          'لديك $unreadCount إشعار غير مقروء',
                          style: TextStyles.textViewMedium(
                            fontSize: 13.sp,
                            color: AppColors.textColor2,
                          ),
                        ),
                        InkWell(
                          onTap: () => cubit.markAllAsRead(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            child: AppText(
                              'تحديد الكل كمقروء',
                              style: TextStyles.textViewBold(
                                size: 12.sp,
                                color: AppColors.kPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Expanded(
                  child: _buildBody(state, cubit, notifications),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    GetNotificationsState state,
    GetNotificationsCubit cubit,
    List<AppNotification> notifications,
  ) {
    if (state is GetNotificationsLoadingState && notifications.isEmpty) {
      return const ShimmerVerticalListWidget(count: 6);
    }

    if (state is GetNotificationsErrorState && notifications.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => cubit.getNotifications(),
        color: AppColors.kPrimary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 400.h,
            child: const NoResultsWidget(),
          ),
        ),
      );
    }

    if (notifications.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => cubit.getNotifications(),
        color: AppColors.kPrimary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 400.h,
            child: const NoResultsWidget(),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => cubit.getNotifications(),
      color: AppColors.kPrimary,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationCard(notifications[index]);
        },
      ),
    );
  }
}
