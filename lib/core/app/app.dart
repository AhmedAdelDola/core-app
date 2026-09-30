import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../feature/auth/splash/splash_screen.dart';
import '../consts/client_config.dart';
import '../navigator/named_navigator_impl.dart';
import '../network/cubit/cubit.dart';
import '../network/cubit/state.dart';
import '../theme/theme.dart';
import '../widgets/ui_helpers/network_status_banner.dart';
import 'providers.dart';

import '../util/responsive/responsive_helper.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers,
      child: BlocListener<NetworkCubit, NetworkStates>(
        listenWhen: (p, c) => p.runtimeType != c.runtimeType,
        listener: networkListener,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ScreenUtilInit(
              designSize: _getDesignSize(constraints),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (_, child) {
                return MaterialApp(
                  title: ClientConfig.appName,
                  onGenerateRoute: NamedNavigatorImpl.onGenerateRoute,
                  navigatorKey: NamedNavigatorImpl.navigatorState,
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: const [
                    GlobalCupertinoLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: const [Locale('ar')],
                  theme: CustomMaterialAppTheme.mainThemeData,
                  builder: (context, child) => NetworkStatusBanner(child: child ?? const SizedBox()),
                  home: const SplashScreen(),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Size _getDesignSize(BoxConstraints constraints) {
    final width = constraints.maxWidth;
    final height = constraints.maxHeight;
    final isLandscape = width > height;
    final shortestSide = width < height ? width : height;
    final isTabletDevice = shortestSide >= ResponsiveBreakpoints.tabletPortraitMin;

    if (isTabletDevice) {
      return isLandscape ? const Size(1024, 768) : const Size(768, 1024);
    } else {
      return isLandscape ? const Size(843, 411) : const Size(411, 843);
    }
  }
}
