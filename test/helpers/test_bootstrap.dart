import 'package:elhanbly/core/local/cache_helper.dart';
import 'package:elhanbly/core/network/cubit/cubit.dart';
import 'package:elhanbly/core/network/repository/repository_imports.dart';
import 'package:elhanbly/feature/auth/login/cubit/login_cubit.dart';
import 'package:elhanbly/feature/home_layout/cubit/home_lay_out_cubit.dart';
import 'package:elhanbly/feature/modules/home/cubit/home_cubit/home_cubit.dart';
import 'package:elhanbly/feature/modules/profile/cubit/wallet_cubit/wallet_cubit.dart';
import 'package:elhanbly/feature/modules/profile/profile_imports.dart';
import 'package:elhanbly/core/services/di.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_repository.dart';

Future<FakeRepository> configureTestDependencies({
  FakeRepository? repository,
  Map<String, Object> preferences = const {},
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(preferences);

  await di.reset();

  final sharedPreferences = await SharedPreferences.getInstance();
  final fakeRepository = repository ?? FakeRepository();

  di.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  di.registerLazySingleton<CacheHelper>(() => CacheImpl(sharedPreferences));
  di.registerLazySingleton<NetworkCubit>(() => NetworkCubit());
  di.registerLazySingleton<Repository>(() => fakeRepository);

  return fakeRepository;
}

void registerWidgetTestCubits() {
  if (!di.isRegistered<LoginCubit>()) {
    di.registerFactory<LoginCubit>(() => LoginCubit(di<Repository>()));
  }
  if (!di.isRegistered<HomeCubit>()) {
    di.registerFactory<HomeCubit>(() => HomeCubit(di<Repository>()));
  }
  if (!di.isRegistered<BottomBarCubit>()) {
    di.registerFactory<BottomBarCubit>(() => BottomBarCubit(di<Repository>()));
  }
  if (!di.isRegistered<GetProfileCubit>()) {
    di.registerFactory<GetProfileCubit>(() => GetProfileCubit(di<Repository>()));
  }
  if (!di.isRegistered<WalletCubit>()) {
    di.registerFactory<WalletCubit>(() => WalletCubit(di<Repository>()));
  }
}

Future<void> pumpWithTestApp(
  WidgetTester tester,
  Widget child,
) async {
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.rtl,
      child: child,
    ),
  );
}
