part of '../../profile_imports.dart';

class UpdateProfileState {}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileLoading extends UpdateProfileState {}

class UpdateProfileSuccess extends UpdateProfileState {
  final String message;
  UpdateProfileSuccess(this.message);
}

class UpdateProfileError extends UpdateProfileState {
  final String message;
  UpdateProfileError({required this.message});
}

// class UpdatePhoneLoadingState extends UpdateProfileState {}
// class UpdatePhoneSuccessState extends UpdateProfileState {}
// class UpdatePhoneErrorState extends UpdateProfileState {
//   final String message;
//   UpdatePhoneErrorState({required this.message});
// }
