part of 'get_notifications_cubit.dart';

abstract class GetNotificationsState {}

class GetNotificationsInitialState extends GetNotificationsState {}

class GetNotificationsLoadingState extends GetNotificationsState {}

class GetNotificationsSuccessState extends GetNotificationsState {}

class GetNotificationsErrorState extends GetNotificationsState {
  final String message;
  GetNotificationsErrorState(this.message);
}
