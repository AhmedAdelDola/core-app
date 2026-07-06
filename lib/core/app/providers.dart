import 'package:elhanbly/feature/home_layout/cubit/home_lay_out_cubit.dart';
import 'package:elhanbly/feature/modules/home/cubit/home_cubit/home_cubit.dart';
import 'package:elhanbly/feature/modules/home/home_section/courses_section/cubit/courses_section_cubit.dart';
import 'package:elhanbly/feature/modules/home/home_section/lessons_section/cubit/lessons_section_cubit.dart';
import 'package:elhanbly/feature/modules/library/cubit/library_cubit/library_cubit.dart';
import 'package:elhanbly/feature/modules/profile/cubit/wallet_cubit/wallet_cubit.dart';
import 'package:elhanbly/feature/modules/profile/profile_imports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

import '../../feature/auth/login/cubit/login_cubit.dart';
import '../../feature/auth/login/login_imports.dart';
import '../../feature/auth/splash/cubit/splash_cubit.dart';

import '../navigator/named_navigator_impl.dart';
import '../network/cubit/cubit.dart';
import '../network/cubit/state.dart';
import '../services/di.dart';
import '../widgets/ui_helpers/alert_message.dart';

List<SingleChildWidget> get providers {
  return [
    BlocProvider<NetworkCubit>(create: (_) => di<NetworkCubit>()),
    BlocProvider<LoginCubit>(create: (_) => di<LoginCubit>()),
    BlocProvider<SplashCubit>(create: (_) => di<SplashCubit>()..switchAnimation()),
    BlocProvider<BottomBarCubit>(create: (_) => di<BottomBarCubit>()..getLocalData()),
    BlocProvider<HomeCubit>(create: (_) => di<HomeCubit>()),
    BlocProvider<CoursesSectionCubit>(create: (_) => di<CoursesSectionCubit>()),
    BlocProvider<LibraryCubit>(create: (_) => di<LibraryCubit>()..getLibraryCourses()),
    BlocProvider<GetProfileCubit>(create: (_) => di<GetProfileCubit>()..getProfile()),
    BlocProvider<UpdateProfileCubit>(create: (_) => di<UpdateProfileCubit>()),
    BlocProvider<WalletCubit>(create: (_) => di<WalletCubit>()),
    BlocProvider<LessonsSectionCubit>(create: (_) => di<LessonsSectionCubit>()),




 
  ];
}

void networkListener(context, state) {
  switch (state.runtimeType) {
    case UnauthenticatedState:
      NamedNavigatorImpl.push(const LoginScreen(), clean: true);
      return;
    case SocketErrorState:
      showErrorToast('لديك مشكلة في الاتصال بالانترنت');
      break;
    case ClientErrorState:
      break;
    case ServerErrorState:
      break;
    case ErrorState:
      break;
    default:
  }
}
