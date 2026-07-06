import 'package:elhanbly/feature/home_layout/cubit/home_lay_out_cubit.dart';
import 'package:elhanbly/feature/modules/home/cubit/home_cubit/home_cubit.dart';
import 'package:elhanbly/feature/modules/home/home_section/courses_section/cubit/courses_section_cubit.dart';
import 'package:elhanbly/feature/modules/home/home_section/lessons_section/cubit/lessons_section_cubit.dart';
import 'package:elhanbly/feature/modules/library/cubit/library_cubit/library_cubit.dart';
import 'package:elhanbly/feature/modules/profile/cubit/wallet_cubit/wallet_cubit.dart';
import 'package:elhanbly/feature/modules/profile/profile_imports.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../feature/auth/login/cubit/login_cubit.dart';
import '../../feature/auth/splash/cubit/splash_cubit.dart';

import '../../models/general/settings_response.dart';
import '../../models/user_response/user_data.dart';
import '../local/cache_helper.dart';
import '../local/user_preferences/user_preferences_helper.dart';
import '../network/cubit/cubit.dart';
import '../network/dio/dio_helper.dart';
import '../network/dio/wrapper.dart';
import '../network/repository/repository_imports.dart';
import 'notifications/local_notifications.dart';

GetIt di = GetIt.I;

Future init() async {
  await dotenv.load(fileName: '.env');
  final baseUrl = dotenv.env['BASE_URL'];
  if (baseUrl == null || baseUrl.isEmpty) {
    throw StateError('BASE_URL is missing from .env');
  }
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  di.registerLazySingleton<FirebaseMessaging>(() => firebaseMessaging);
  final sp = await SharedPreferences.getInstance();
  di.registerLazySingleton<SharedPreferences>(() => sp);
  // di.registerLazySingleton<AppNavigator>(() => AppNavigator());
  // final userAgent = await userAgentClientHintsHeader();
  di.registerLazySingleton<NetworkCubit>(() => NetworkCubit());

  di.registerLazySingleton<DioHelper>(
    () => DioImpl(
      // userAgent: userAgent.values.first.toString(),
      baseURL: baseUrl,
      onRequest: di<NetworkCubit>().onRequestCallback,
      onError: di<NetworkCubit>().onErrorCallback,
    ),
  );
  di.registerLazySingleton<LocalNotificationService>(
    () => LocalNotificationService(),
  );

  di.registerLazySingleton<Repository>(() => RepoImpl(di<DioHelper>()));
  di.registerLazySingleton<CacheHelper>(
    () => CacheImpl(di<SharedPreferences>()),
  );
  di.registerFactory<BottomBarCubit>(() => BottomBarCubit(di<Repository>()));

  /// ==============================  Auth  ==========================================
  di.registerLazySingleton<SplashCubit>(() => SplashCubit());
  di.registerFactory<LoginCubit>(() => LoginCubit(di<Repository>()));
  // di.registerFactory<SubmitOtpCubit>(() => SubmitOtpCubit(di<Repository>()));
  // di.registerFactory<ResensdOtpCubit>(() => ResensdOtpCubit(di<Repository>()));
  // di.registerFactory<BlockReasonCubit>(
  //     () => BlockReasonCubit(di<Repository>()));
  // di.registerFactory<ChangeImageCubit>(
  //     () => ChangeImageCubit(di<Repository>()));
  // di.registerFactory<ChooseEducationAreaCubit>(
  //     () => ChooseEducationAreaCubit(di<Repository>()));
  // di.registerFactory<GetGovernoratesCubit>(
  //     () => GetGovernoratesCubit(di<Repository>()));
  // di.registerFactory<GetCountriesCubit>(
  //     () => GetCountriesCubit(di<Repository>()));
  // di.registerFactory<GetCitiesCubit>(() => GetCitiesCubit(di<Repository>()));
  // di.registerFactory<ChooseGenderCubit>(
  //     () => ChooseGenderCubit(di<Repository>()));
  // di.registerFactory<CompleteEducationLevelCubit>(
  //     () => CompleteEducationLevelCubit(repository: di<Repository>()));
  // di.registerLazySingleton<BasicInformationCubit>(
  //     () => BasicInformationCubit(di<Repository>()));
  // di.registerFactory<UniversitiesCubit>(
  //     () => UniversitiesCubit(repo: di<Repository>()));
  // di.registerFactory<StagesCubit>(
  //     () => StagesCubit(repository: di<Repository>()));
  // di.registerFactory<GradesCubit>(
  //     () => GradesCubit(repository: di<Repository>()));

  // /// ==============================  Profile  ==========================================

  di.registerFactory<GetProfileCubit>(() => GetProfileCubit(di<Repository>()));
  di.registerFactory<UpdateProfileCubit>(
    () => UpdateProfileCubit(di<Repository>()),
  );
  // di.registerFactory<GetFavCoursesCubit>(
  //     () => GetFavCoursesCubit(di<Repository>()));
  // di.registerLazySingleton<GetNotificationsCubit>(
  //     () => GetNotificationsCubit(di<Repository>()));
  di.registerLazySingleton<WalletCubit>(() => WalletCubit(di<Repository>()));

  // /// ==============================  Home  ==========================================

  di.registerFactory<HomeCubit>(() => HomeCubit(di<Repository>()));
  // di.registerFactory<SubjectsSectionCubit>(
  //     () => SubjectsSectionCubit(di<Repository>()));
  di.registerFactory<CoursesSectionCubit>(
    () => CoursesSectionCubit(di<Repository>()),
  );
  // di.registerFactory<FilesSectionCubit>(
  //     () => FilesSectionCubit(di<Repository>()));
  di.registerFactory<LessonsSectionCubit>(
    () => LessonsSectionCubit(di<Repository>()),
  );

  // /// ==============================  Quizes  ==========================================

  // di.registerFactory<CreateQuizeCubit>(
  //     () => CreateQuizeCubit(di<Repository>()));
  // di.registerFactory<QuizeCubit>(() => QuizeCubit(di<Repository>()));
  // di.registerFactory<SubmitExamQuestionCubit>(
  //     () => SubmitExamQuestionCubit(repository: di<Repository>()));

  // di.registerFactory<SubmitQuestionCubit>(
  //     () => SubmitQuestionCubit(repository: di<Repository>()));
  // di.registerFactory<ExamCubit>(() => ExamCubit(di<Repository>()));
  di.registerFactory<LibraryCubit>(() => LibraryCubit(di<Repository>()));
  // // di.registerFactory<GetAllSubjectsChaptersCubit>(() => GetAllSubjectsChaptersCubit(di<Repository>()));
  // // di.registerFactory<GetChapterLessonsCubit>(() => GetChapterLessonsCubit(di<Repository>()));
  // // di.registerFactory<GetLessonQuestionCubit>(() => GetLessonQuestionCubit(di<Repository>()));
}

void injectFCMToken(String? fcmToken) {
  if (di.isRegistered<String>(instanceName: 'fcmToken')) {
    di.unregister<String>(instanceName: 'fcmToken');
  }
  di.registerLazySingleton<String>(
    () => fcmToken ?? 'ThishuwawiphonenofcmfoundZ',
    instanceName: 'fcmToken',
  );
}

String get fcmToken => di<String>(instanceName: 'fcmToken');
UserModelResponse? get userData => UserPreferencesHelper().getUserPreference();
SettingsResponse? get appSettings => UserPreferencesHelper().getAppSettings();
