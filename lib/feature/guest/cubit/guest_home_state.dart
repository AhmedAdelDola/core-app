part of 'guest_home_cubit.dart';

abstract class GuestHomeState {}

class GuestHomeInitial extends GuestHomeState {}

class GuestHomeLoading extends GuestHomeState {}

class GuestHomeLoaded extends GuestHomeState {
  final GuestCoursesResponse response;
  GuestHomeLoaded(this.response);
}

class GuestHomeError extends GuestHomeState {
  final String message;
  GuestHomeError(this.message);
}
