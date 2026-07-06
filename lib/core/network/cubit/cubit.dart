import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../local/user_preferences/user_preferences_helper.dart';
import '../../util/logger.dart';
import '../../widgets/ui_helpers/alert_message.dart';
import '../extensions/cubit_extension.dart';
import 'state.dart';

class NetworkCubit extends Cubit<NetworkStates> {
  NetworkCubit() : super(NoErrorState());

  static NetworkCubit get(BuildContext context) => BlocProvider.of(context);

  Future<Map<String, dynamic>> onRequestCallback() async {
    String? token = UserPreferencesHelper().getUserTokenPreference();
    return {
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> onErrorCallback(DioException error) async {
    final response = error.response;
    final path = error.requestOptions.path;
    final isProfileRelatedRequest = path.contains('/auth/profile') || path.contains('/auth/me');

    if (response != null) {
      final message = response.data?['message']?.toString() ?? 'Something went wrong try again later';
      PrintLog.e(message);

      final isUnauthenticated = (response.statusCode == 401) ||
          (response.statusCode == 500 && message.contains('Unauthenticated'));

      if (isUnauthenticated && !isProfileRelatedRequest) {
        showErrorToast(message);
        safeEmit(UnauthenticatedState(message));
      } else {
        showErrorToast(message);
        safeEmit(ErrorState(message));
      }
    } else {
      safeEmit(ErrorState('Something went wrong try again later'));
    }
  }
}
