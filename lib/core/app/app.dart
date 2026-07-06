import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../feature/auth/splash/splash_screen.dart';
import '../navigator/named_navigator_impl.dart';
import '../network/cubit/cubit.dart';
import '../network/cubit/state.dart';
import '../theme/theme.dart';
import 'providers.dart';

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
                  title: 'A-Plus',
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

    // Tablet landscape
    if (width >= 900) {
      return const Size(1024, 768);
    }
    // Tablet portrait
    else if (width >= 600) {
      return const Size(768, 1024);
    }
    // Phone
    else {
      return const Size(411, 843);
    }
  }
}
