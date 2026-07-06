import 'package:elhanbly/core/navigator/named_navigator_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpWidgetTestApp(
  WidgetTester tester,
  Widget child, {
  Size size = const Size(411, 843),
  RouteFactory? onGenerateRoute,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: size,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return MaterialApp(
          navigatorKey: NamedNavigatorImpl.navigatorState,
          onGenerateRoute: onGenerateRoute,
          debugShowCheckedModeBanner: false,
          home: child,
        );
      },
    ),
  );
}
