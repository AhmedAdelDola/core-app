// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

// import '../../../core/services/di.dart';
// import '../../../core/widgets/loader/app_loader.dart';
// import '../../../core/widgets/loader/shimmer_list_item.dart';
// // import '../../../models/profile/get_notifications_response.dart';
// import 'cubit/get_notifications_cubit.dart';
// import 'widgets/no_results_widget.dart';
// import 'widgets/notification_card.dart';

// class NotificationsScreen extends StatefulWidget {
//   const NotificationsScreen({super.key});

//   @override
//   State<NotificationsScreen> createState() => _NotificationsScreenState();
// }

// class _NotificationsScreenState extends State<NotificationsScreen> {
//   late final ScrollController _scrollController;
//   final RefreshController _refreshController =
//       RefreshController(initialRefresh: false);

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         context.read<GetNotificationsCubit>().getNotifications();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: 20.sp, bottom: 20.sp),
//       child: BlocProvider(
//         create: (context) {
//           final cubit = di<GetNotificationsCubit>();
//           cubit.getNotifications(); // Call getNotifications here
//           return cubit;
//         },
//         child: BlocBuilder<GetNotificationsCubit, GetNotificationsState>(
//           builder: (context, state) {
//             final cubit = context.read<GetNotificationsCubit>();

//             if (state is GetNotificationsLoadingState) {
//               return const ShimmerVerticalListWidget();
//             }
//             if (state is GetNotificationsErrorState) {
//               return const NoResultsWidget();
//             }

//             final List<AppNotification> notifications = cubit.notificationList;

//             return SmartRefresher(
//               controller: _refreshController,
//               onRefresh: () async {
//                 await cubit.getNotifications();
//                 _refreshController.refreshCompleted();
//               },
//               child: notifications.isEmpty
//                   ? const Center(child: NoResultsWidget())
//                   : ListView.separated(
//                       separatorBuilder: (_, i) => const Divider(),
//                       physics: const BouncingScrollPhysics(),
//                       controller: _scrollController,
//                       itemCount: notifications.length,
//                       itemBuilder: (c, i) {
//                         return NotificationCard(notifications[i]);
//                       },
//                     ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
