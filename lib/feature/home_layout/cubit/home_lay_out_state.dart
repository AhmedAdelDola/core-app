part of 'home_lay_out_cubit.dart';

abstract class BottomBarState {}

class InitialBottomBarState extends BottomBarState {}

class SuccessGetHomeDataState extends BottomBarState {}

class LoadingGetHomeDataState extends BottomBarState {}

class UpdatePageIndexState extends BottomBarState {}

class GetProfileError extends BottomBarState {
  final String message;
  GetProfileError(this.message);
}

class GetProfileSuccess extends BottomBarState {
  final UserModelResponse user;
  GetProfileSuccess(this.user);
}
