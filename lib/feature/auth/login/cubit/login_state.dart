part of 'login_cubit.dart';

abstract class LoginState {}

class InitialLoginState extends LoginState {}

class ChangeFlagState extends LoginState {}

class LoginLoadingState extends LoginState {}

class SuccessLoginState extends LoginState {
  final LoginResponse res;

  SuccessLoginState(this.res);
}

class LoginErrorState extends LoginState {
  final String message;

  LoginErrorState(this.message);
}

class PhoneNotFoundState extends LoginState {
  final String fullPhone;

  PhoneNotFoundState(this.fullPhone);
}

class StudentExistsState extends LoginState {}

class RequestOtpLoadingState extends LoginState {}

class RequestOtpSuccessState extends LoginState {}

class RequestOtpErrorState extends LoginState {
  final String message;

  RequestOtpErrorState(this.message);
}

class OtpTimerTickState extends LoginState {
  final int secondsRemaining;

  OtpTimerTickState(this.secondsRemaining);
}

class SwitchLoginModeState extends LoginState {
  final LoginAuthMode mode;

  SwitchLoginModeState(this.mode);
}

class GetMacAddressState extends LoginState {}

class ChangeCountryCodeState extends LoginState {}
class ChangeNumberCodeState extends LoginState {}

class GetNetworkInfoState extends LoginState {}
