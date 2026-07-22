import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/local/cache_helper.dart';
import '../../../../core/local/enum_init.dart';
import '../../../../core/local/user_preferences/user_preferences_helper.dart';
import '../../../../core/navigator/named_navigator_impl.dart';
import '../../../../core/navigator/named_navigator_routes.dart';
import '../../../../core/network/repository/repository_imports.dart';
import '../../../../core/services/di.dart';
import 'onboarding_models.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(InitialSplashState());

  static SplashCubit of(context) => BlocProvider.of(context);

  bool openAnimation = false;
  int splashDuration = 3;

  switchAnimation() {
    Future.delayed(Duration(seconds: splashDuration), () {
      openAnimation = true;
      runSplash();
      getSettings();
    });
  }

  runSplash() {
    Future.delayed(const Duration(milliseconds: 500), () async {
      bool isLogged = di<CacheHelper>().getBool(CachingKey.isLogged);
      if (isLogged == true) {
        String? token = UserPreferencesHelper().getUserTokenPreference();
        log('Hello Tolba ==> $token');
        log('isLogged ==> $isLogged');
        final token_ = di.isRegistered<String>(instanceName: 'fcmToken') ? fcmToken : 'not_registered';
        log('FCM TOKEN ==> $token_');
        emit(AuthenticatedState());
      } else {
        emit(UnAuthenticatedState());
      }
    });
  }

  /// OnBoarding
  final PageController controller = PageController();
  int pageIndex = 0;
  bool isLast = false;

  onPageChanged(int index) {
    pageIndex = index;
    if (pageIndex == OnBoardingModel.images.length - 1) {
      isLast = true;
    } else {
      isLast = false;
    }
    emit(OnBoardingChangeState());
  }

  void changePage() {
    if (isLast) {
      UserPreferencesHelper().saveSeenOnBoarding(true);
      NamedNavigatorImpl.pushNamed(Routes.guestHome, clean: true);
    } else {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
      pageIndex++;
      emit(OnBoardingChangeState());
    }
  }

  void getSettings() async {
    emit(GetSettingsLoading());
    final f = await di<Repository>().getSettings();
    f.fold(
      (l) => emit(GetSettingsError(l.toString())),
      (r) {
        UserPreferencesHelper().saveAppSettings(data: r);
        emit(GetSettingsSuccess());
      },
    );
  }
}
