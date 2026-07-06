part of 'home_cubit.dart';

class HomeStates {}

class HomeInitial extends HomeStates {}

class GetHomeLoadingState extends HomeStates {}
class GetHomeSuccessState extends HomeStates {}
class GetHomeErrorState extends HomeStates {
  final String error;
  GetHomeErrorState(this.error);
} 

