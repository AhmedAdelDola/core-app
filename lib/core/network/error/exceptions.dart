// import '../../../models/user_response/user_data.dart';
// import 'package:dio/dio.dart';

// class ServerException implements Exception {
//   String message;
//   final int? code;
//   ServerException({required this.message, this.code});
// }

// class NotActiveException implements Exception {
//   final Map<String, dynamic> userData;
//   final String message;
//   NotActiveException({required this.message, required this.userData});
// }

// class NotActiveUserException implements Exception {
//   final UserModel? user;
//   final String message;
//   NotActiveUserException({required this.message, this.user});
// }

// class NoCachedUserException implements Exception {}

// class CacheException implements Exception {}

// class AuthException implements Exception {
//   final String message;
//   AuthException({required this.message});
// }

// class UnauthorizedException implements Exception {
//   final String message;
//   UnauthorizedException({required this.message});
// }

// class NoCacheOrderException implements Exception {}

// class CacheUserAcssesToken implements Exception {}

// class ResetPasswordException implements Exception {}

// class OrderTypeException implements Exception {}

// class StatusException implements Exception {
//   final String message;
//   StatusException({required this.message});
// }

// abstract class ErrorParser {
//   String get errorMessage;
// }

// class NetworkException implements Exception, ErrorParser {
//   Response? response;
//   String? message;

//   NetworkException({this.response, this.message});

//   @override
//   String get errorMessage => response!.data['message'];
// }
