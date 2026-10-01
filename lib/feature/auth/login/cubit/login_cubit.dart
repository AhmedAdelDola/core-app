import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:elhanbly/feature/auth/common/country_picker_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/repository/repository_imports.dart';
import '../../../../models/user_response/login_response.dart';
import '../../../../core/security/content_protection_service.dart';
import '../../../../core/services/di.dart';
import '../../../../core/local/cache_helper.dart';
import '../../../../core/local/enum_init.dart';
import '../../../../core/local/user_preferences/user_preferences_helper.dart';

part 'login_state.dart';

enum LoginAuthMode { password, otp }

class LoginCubit extends Cubit<LoginState> implements CountryPickerCubit {
  Repository repo;
  LoginCubit(this.repo) : super(InitialLoginState()) {
    initAuthMode();
  }
  static LoginCubit of(BuildContext context) => BlocProvider.of<LoginCubit>(context);

  @override
  String? countryCode = 'EG';
  @override
  String? numberCode = '+20';

  bool get isPasswordEnabled =>
      UserPreferencesHelper().getAppSettings()?.settings?.passwordLoginEnabled ?? true;
  bool get isOtpEnabled =>
      UserPreferencesHelper().getAppSettings()?.settings?.otpLoginEnabled ?? false;

  late LoginAuthMode currentAuthMode;

  void initAuthMode() {
    if (isOtpEnabled && !isPasswordEnabled) {
      currentAuthMode = LoginAuthMode.otp;
    } else {
      currentAuthMode = LoginAuthMode.password;
    }
  }

  void switchAuthMode(LoginAuthMode mode) {
    currentAuthMode = mode;
    emit(SwitchLoginModeState(mode));
  }

  /// ================== User Data ==================
  @override
  void setCountryCode(String code) {
    countryCode = code;
    emit(ChangeCountryCodeState());
  }

  @override
  void setNumberCode(String code) {
    numberCode = code;
    emit(ChangeNumberCodeState());
  }

  Timer? _otpTimer;
  int secondsRemaining = 60;

  void startOtpTimer() {
    _otpTimer?.cancel();
    secondsRemaining = 60;
    emit(OtpTimerTickState(secondsRemaining));
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
        emit(OtpTimerTickState(secondsRemaining));
      } else {
        _otpTimer?.cancel();
      }
    });
  }

  LoginResponse? loginResponse;

  /// Check whether the phone is registered or not
  Future<void> checkPhone({required String phone}) async {
    emit(LoginLoadingState());

    final f = await repo.login(
      phone: numberCode! + phone,
    );

    f.fold(
      (l) {
        final errorMsg = l.toString();
        if (errorMsg.contains('DEVICE_IP_CHANGED') || errorMsg.contains('DEVICE_LIMIT_EXCEEDED') || errorMsg.contains('ip_changed') || errorMsg.contains('banned')) {
          emit(StudentBannedState(message: 'ØªÙ… Ø§ÙƒØªØ´Ø§Ù ØªØ³Ø¬ÙŠÙ„ Ø¯Ø®ÙˆÙ„ Ù…Ù† Ø£Ø¬Ù‡Ø²Ø© Ù…ØªØ¹Ø¯Ø¯Ø©. ØªÙ… ØªØ¹Ù„ÙŠÙ‚ Ø­Ø³Ø§Ø¨Ùƒ Ù…Ø¤Ù‚ØªØ§Ù‹.'));
        } else if (errorMsg.contains('Phone number not found') ||
            errorMsg.contains('not found') ||
            errorMsg.contains('404')) {
          emit(PhoneNotFoundState(numberCode! + phone));
        } else {
          // Phone exists, requires password or OTP
          emit(StudentExistsState());
        }
      },
      (r) {
        loginResponse = r;
        try {
          di<CacheHelper>().put(CachingKey.isLogged, true);
          di<CacheHelper>().put(CachingKey.userData, r.toJson());
          _prefetchSecurityConfig();
        } catch (_) {}
        emit(SuccessLoginState(r));
      },
    );
  }

  Future<void> requestOtp({required String phone}) async {
    emit(RequestOtpLoadingState());
    final f = await repo.requestOtp(phone: numberCode! + phone);
    f.fold(
      (l) => emit(RequestOtpErrorState(l.toString())),
      (r) {
        startOtpTimer();
        emit(RequestOtpSuccessState());
      },
    );
  }

  Future<void> login({
    required String phone,
    String? password,
    String? otp,
  }) async {
    emit(LoginLoadingState());

    final f = await repo.login(
      phone: numberCode! + phone,
      password: password,
      otp: otp,
    );
    f.fold(
      (l) {
        final error = l.toString();
        if (error.contains('DEVICE_IP_CHANGED') || error.contains('DEVICE_LIMIT_EXCEEDED') || error.contains('ip_changed') || error.contains('banned')) {
          emit(StudentBannedState(message: 'ØªÙ… Ø§ÙƒØªØ´Ø§Ù ØªØ³Ø¬ÙŠÙ„ Ø¯Ø®ÙˆÙ„ Ù…Ù† Ø£Ø¬Ù‡Ø²Ø© Ù…ØªØ¹Ø¯Ø¯Ø©. ØªÙ… ØªØ¹Ù„ÙŠÙ‚ Ø­Ø³Ø§Ø¨Ùƒ Ù…Ø¤Ù‚ØªØ§Ù‹.'));
        } else {
          emit(LoginErrorState(error));
        }
      },
      (r) {
        loginResponse = r;
        // persist login state and user data so app recognizes authenticated user
        try {
          di<CacheHelper>().put(CachingKey.isLogged, true);
          di<CacheHelper>().put(CachingKey.userData, r.toJson());
          _prefetchSecurityConfig();
        } catch (_) {}
        emit(SuccessLoginState(r));
      },
    );
  }

  Future<void> _prefetchSecurityConfig() async {
    try {
      if (Platform.isAndroid && di.isRegistered<ContentProtectionService>()) {
        final cfg = await di<ContentProtectionService>().getSecurityConfig();
        if (cfg.isEnforced || cfg.isMonitor) {
          await di<ContentProtectionService>().enrollDevice();
        }
      }
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _otpTimer?.cancel();
    return super.close();
  }
}

