import 'package:elhanbly/feature/home_layout/home_layout.dart';
import 'package:flutter/material.dart';

import '../../feature/auth/login/login_imports.dart';
import '../../feature/auth/splash/onboarding_screens.dart';
import '../../feature/auth/splash/splash_screen.dart';
import 'named_navigator_routes.dart';

class NamedNavigatorImpl {
  static final GlobalKey<NavigatorState> navigatorState =
      GlobalKey<NavigatorState>();

  static void pop({dynamic result}) {
    final state = navigatorState.currentState;
    if (state != null && Navigator.of(state.context).canPop()) {
      Navigator.of(state.context).pop(result);
    }
  }

  static Future push(Widget screen,
      {bool replace = false, bool clean = false}) {
    final state = navigatorState.currentState;
    if (state == null) return Future.value();
    if (clean) {
      return state.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => screen), (_) => false);
    } else if (replace) {
      return state.pushReplacement(MaterialPageRoute(builder: (_) => screen));
    } else {
      return state.push(MaterialPageRoute(builder: (_) => screen));
    }
  }

  static Future pushNamed(String routeName,
      {arguments, bool replace = false, bool clean = false}) {
    final state = navigatorState.currentState;
    if (state == null) return Future.value();
    if (clean) {
      return state.pushNamedAndRemoveUntil(
          routeName, (_) => false,
          arguments: arguments);
    } else if (replace) {
      return state.pushReplacementNamed(routeName, arguments: arguments);
    } else {
      return state.pushNamed(routeName, arguments: arguments);
    }
  }

  static void popToFrist({dynamic object}) {
    return navigatorState.currentState?.popUntil((Route rout) => rout.isFirst);
  }

  static Route<dynamic> onGenerateRoute(RouteSettings? settings) {
    switch (settings?.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.onBoarding:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.homePage:
        return MaterialPageRoute(builder: (_) => const HomeLayout());
      // case Routes.homePage:
    }

    return MaterialPageRoute(builder: (_) => Container());
  }
}
