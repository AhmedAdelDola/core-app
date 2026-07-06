part of '../../profile_imports.dart';

class GetProfileState {}

class GetProfileInitial extends GetProfileState {}

class GetProfileLoading extends GetProfileState {}

class GetProfileSuccess extends GetProfileState {}

class GetProfileError extends GetProfileState {
  final String message;
  GetProfileError(this.message);
}

class LogoutLoading extends GetProfileState {}

class LogoutSuccess extends GetProfileState {
  final String message;
  LogoutSuccess(this.message);
}

class LogoutError extends GetProfileState {
  final String message;
  LogoutError(this.message);
}

class DeleteLoading extends GetProfileState {}

class DeleteSuccess extends GetProfileState {
  final String message;
  DeleteSuccess(this.message);
}

class DeleteError extends GetProfileState {
  final String message;
  DeleteError(this.message);
}
