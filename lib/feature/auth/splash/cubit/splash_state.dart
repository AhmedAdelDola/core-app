part of 'splash_cubit.dart';

abstract class SplashState {}

class InitialSplashState extends SplashState {}

class UnAuthenticatedState extends SplashState {}

class AuthenticatedState extends SplashState {}

class OnBoardingChangeState extends SplashState {}

class GetSettingsLoading extends SplashState {}

class GetSettingsSuccess extends SplashState {}

class GetSettingsError extends SplashState {
  final String error;
  GetSettingsError(this.error);
}
