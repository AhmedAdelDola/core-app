import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:package_info_plus/package_info_plus.dart';

import '../../local/user_preferences/user_preferences_helper.dart';
import '../../services/di.dart';
import '../../util/logger.dart';
import '../../widgets/ui_helpers/alert_message.dart';
import '../extensions/cubit_extension.dart';
import '../../services/internet_checker_service.dart';
import 'state.dart';

class NetworkCubit extends Cubit<NetworkStates> {
  late final InternetCheckerService _internetChecker;

  NetworkCubit() : super(NoErrorState()) {
    _internetChecker = InternetCheckerService(
      onStatusChanged: (isConnected) {
        if (isConnected) {
          safeEmit(const AppInternetRestoredState());
        } else {
          safeEmit(const AppInternetDisconnectedState());
        }
      },
    );
    _internetChecker.startChecking();
  }

  @override
  Future<void> close() {
    _internetChecker.stopChecking();
    return super.close();
  }


  static NetworkCubit get(BuildContext context) => BlocProvider.of(context);

  Future<Map<String, dynamic>> onRequestCallback() async {
    String? token = UserPreferencesHelper().getUserTokenPreference();
    final packageInfo = di.isRegistered<PackageInfo>() ? di<PackageInfo>() : null;
    final version = packageInfo?.version ?? '15.0.23';
    return {
      if (token != null) 'Authorization': 'Bearer $token',
      'X-App-Version': version,
    };
  }

  Future<void> onErrorCallback(DioException error) async {
    final response = error.response;
    final path = error.requestOptions.path;
    final data = error.requestOptions.data;

    // Do not show error toast when checking phone existence during login (only phone is sent)
    final isCheckPhoneRequest = path.contains('auth/login') &&
        (data is Map && !data.containsKey('password') && !data.containsKey('otp'));
    if (isCheckPhoneRequest) {
      return;
    }

    final isSecurityConfigRequest = path.contains('security/config');
    if (isSecurityConfigRequest && response?.statusCode == 404) {
      return;
    }

    final isProfileRelatedRequest = path.contains('/auth/profile') || path.contains('/auth/me');

    if (response != null) {
      final responseData = response.data;
      final message = (responseData is Map && responseData.containsKey('message'))
          ? responseData['message']?.toString() ?? 'Something went wrong try again later'
          : (responseData?['message']?.toString() ?? 'Something went wrong try again later');
      final code = responseData is Map ? responseData['code']?.toString() : null;
      PrintLog.e(message);

      final isUpdateRequired = (response.statusCode == 426) ||
          code == 'MOBILE_APP_UPDATE_REQUIRED' ||
          message.contains('MOBILE_APP_UPDATE_REQUIRED');

      if (isUpdateRequired) {
        final updateUrlAndroid = responseData is Map ? responseData['update_url_android']?.toString() : null;
        final updateUrlIos = responseData is Map ? responseData['update_url_ios']?.toString() : null;
        safeEmit(NoErrorState());
        safeEmit(AppUpdateRequiredState(
          message,
          updateUrlAndroid: updateUrlAndroid,
          updateUrlIos: updateUrlIos,
        ));
        return;
      }

      final isBanned = (response.statusCode == 403 && code == 'DEVICE_IP_CHANGED') || code == 'banned' || message.contains('تعليق');
      if (isBanned) {
        safeEmit(NoErrorState());
        safeEmit(StudentBannedNetworkState(message));
        return;
      }

      final isUnauthenticated = (response.statusCode == 401) ||
          (response.statusCode == 500 && message.contains('Unauthenticated'));

      if (isUnauthenticated && !isProfileRelatedRequest) {
        showErrorToast(message);
        safeEmit(NoErrorState());
        safeEmit(UnauthenticatedState(message));
      } else {
        showErrorToast(message);
        safeEmit(NoErrorState());
        safeEmit(ErrorState(message));
      }
    } else {
      safeEmit(ErrorState('Something went wrong try again later'));
    }
  }
}
