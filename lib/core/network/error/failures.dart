import 'package:equatable/equatable.dart';

import '../../../models/user_response/user_data.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class NotActiveFailure extends Failure {
  final UserModelResponse? user;
  final String message;
  NotActiveFailure({required this.message, this.user});
}

// General failures
class ServerFailure extends Failure {
  final String message;
  final int? statusCode;
  final int? code;

  ServerFailure({this.statusCode, this.message = '', this.code});
}

class CacheFailure extends Failure {}

class AuthFailure extends Failure {
  final String message;
  AuthFailure({required this.message});
}

class NoCachedUserFailure extends Failure {}

class ResetPasswordFailure extends Failure {}

class StatusFailure extends Failure {
  final String message;
  StatusFailure({required this.message});
}

class FirebaseFailure extends Failure {
  final String message;
  FirebaseFailure({required this.message});
}
