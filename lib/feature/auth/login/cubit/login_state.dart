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

class GetMacAddressState extends LoginState {}


class ChangeCountryCodeState extends LoginState {}
class ChangeNumberCodeState extends LoginState {}

class GetNetworkInfoState extends LoginState {}
// class NotActiveState extends LoginState {
//   final String message;
//   final String code;
//   NotActiveState({required this.message, required this.code});
// }
//
// class ChangeLocalIsOnlineState extends LoginState {}
