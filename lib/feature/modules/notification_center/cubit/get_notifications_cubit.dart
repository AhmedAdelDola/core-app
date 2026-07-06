// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../core/network/repository/repository_imports.dart';
// import '../../../../models/profile/get_notifications_response.dart';

// part 'get_notifications_state.dart';

// class GetNotificationsCubit extends Cubit<GetNotificationsState> {
//   final Repository repo;
//   GetNotificationsCubit(this.repo) : super(GetNotificationsInitialState());
//   static GetNotificationsCubit of(context) => BlocProvider.of(context);

//   List<AppNotification> _notificationList = <AppNotification>[];
//   List<AppNotification> get notificationList => _notificationList;

//   Future<void> getNotifications() async {
//     emit(GetNotificationsLoadingState());
//     final f = await repo.getNotifications();
//     f.fold(
//       (l) => emit(GetNotificationsErrorState(l.toString())),
//       (r) {
//         _notificationList = r.data!.data!;
//         emit(GetNotificationsSuccessState());
//       },
//     );
//   }
// }
