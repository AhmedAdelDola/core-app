import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/repository/repository_imports.dart';
import '../../../../models/profile/get_notifications_response.dart';

part 'get_notifications_state.dart';

class GetNotificationsCubit extends Cubit<GetNotificationsState> {
  final Repository repo;
  GetNotificationsCubit(this.repo) : super(GetNotificationsInitialState());
  static GetNotificationsCubit of(BuildContext context) => BlocProvider.of<GetNotificationsCubit>(context);

  List<AppNotification> _notificationList = <AppNotification>[];
  List<AppNotification> get notificationList => _notificationList;
  int unreadCount = 0;

  Future<void> getNotifications() async {
    emit(GetNotificationsLoadingState());
    final f = await repo.getNotifications();
    f.fold(
      (l) => emit(GetNotificationsErrorState(l.toString())),
      (r) {
        _notificationList = r.notifications;
        unreadCount = r.unreadCount;
        emit(GetNotificationsSuccessState());
      },
    );
  }

  Future<void> markAsRead(dynamic id) async {
    final index = _notificationList.indexWhere((n) => n.id == id);
    if (index != -1 && !_notificationList[index].isRead) {
      final updated = AppNotification(
        id: _notificationList[index].id,
        type: _notificationList[index].type,
        title: _notificationList[index].title,
        body: _notificationList[index].body,
        message: _notificationList[index].message,
        data: _notificationList[index].data,
        sentAt: _notificationList[index].sentAt,
        readAt: DateTime.now(),
        createdAt: _notificationList[index].createdAt,
        isRead: true,
        image: _notificationList[index].image,
      );
      _notificationList[index] = updated;
      if (unreadCount > 0) unreadCount--;
      emit(GetNotificationsSuccessState());
      await repo.readNotification(id);
    }
  }

  Future<void> markAllAsRead() async {
    if (_notificationList.isEmpty) return;
    _notificationList = _notificationList.map((n) {
      return AppNotification(
        id: n.id,
        type: n.type,
        title: n.title,
        body: n.body,
        message: n.message,
        data: n.data,
        sentAt: n.sentAt,
        readAt: DateTime.now(),
        createdAt: n.createdAt,
        isRead: true,
        image: n.image,
      );
    }).toList();
    unreadCount = 0;
    emit(GetNotificationsSuccessState());
    await repo.readAllNotifications();
  }
}
