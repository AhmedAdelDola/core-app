part of 'register_cubit.dart';

abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterStagesLoadingState extends RegisterState {}

class RegisterStagesLoadedState extends RegisterState {}

class RegisterStagesErrorState extends RegisterState {
  final String message;

  RegisterStagesErrorState(this.message);
}

class RegisterSubmittingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {}

class RegisterErrorState extends RegisterState {
  final String message;

  RegisterErrorState(this.message);
}
class ChangeCountryCodeState extends RegisterState {}
class ChangeNumberCodeState extends RegisterState {}