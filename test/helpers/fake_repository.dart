import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:elhanbly/core/network/repository/repository_imports.dart';
import 'package:elhanbly/models/Session/get_session_info_response.dart'
    show GetSessionInfoResponse;
import 'package:elhanbly/models/Session/show_video_response.dart' show ShowVideo;
import 'package:elhanbly/models/general/general_response.dart'
    show GeneralResponse;
import 'package:elhanbly/models/general/register_stage_model.dart'
    show RegisterStage;
import 'package:elhanbly/models/general/settings_response.dart'
    show SettingsResponse;
import 'package:elhanbly/models/home_entities/courses/get_course_data_response_model.dart'
    show GetCourseDataResponse;
import 'package:elhanbly/models/home_entities/courses/get_my_courses.dart'
    show LibraryCoursesResponse;
import 'package:elhanbly/models/home_entities/home/get_home.dart' show HomeResponse;
import 'package:elhanbly/models/profile/wallet/wallet_history.dart'
    show WalletResponse;
import 'package:elhanbly/models/profile/wallet/store_products.dart'
    show StoreProductsResponse;
import 'package:elhanbly/models/general/code_availability_response.dart'
    show CodeAvailabilityResponse;
import 'package:elhanbly/models/user_response/login_response.dart'
    show LoginResponse;
import 'package:elhanbly/models/user_response/user_data.dart'
    show UserModelResponse;
import 'package:elhanbly/models/guest/guest_courses_response.dart'
    show GuestCoursesResponse;
import 'package:elhanbly/models/home_entities/courses/course_comments_model.dart';

typedef RepositoryStub<T> = Future<Either<dynamic, T>> Function();

class FakeRepository implements Repository {
  RepositoryStub<LoginResponse>? loginStub;
  RepositoryStub<List<RegisterStage>>? fetchRegistrationStagesStub;
  RepositoryStub<bool>? registerStudentStub;
  RepositoryStub<HomeResponse>? getHomeStub;
  RepositoryStub<GuestCoursesResponse>? getGuestCoursesStub;
  RepositoryStub<GetCourseDataResponse>? getCourseDataStub;
  RepositoryStub<UserModelResponse>? getProfileStub;
  RepositoryStub<SettingsResponse>? getSettingsStub;
  RepositoryStub<GeneralResponse>? updateProfileStub;
  RepositoryStub<WalletResponse>? getWalletStub;
  RepositoryStub<GeneralResponse>? chargeWalletStub;
  RepositoryStub<GeneralResponse>? purchaseProductStub;
  RepositoryStub<StoreProductsResponse>? getStoreProductsStub;
  RepositoryStub<GeneralResponse>? verifyStorePurchaseStub;
  RepositoryStub<CodeAvailabilityResponse>? checkCodeAvailabilityStub;
  RepositoryStub<LibraryCoursesResponse>? getLibraryCoursesStub;
  RepositoryStub<GetSessionInfoResponse>? getSessionInfoStub;
  RepositoryStub<ShowVideo>? getVideoStub;
  RepositoryStub<GeneralResponse>? purchaseCourseSubscriptionStub;
  RepositoryStub<GeneralResponse>? purchaseSessionSubscriptionStub;
  String? lastPurchaseCourseId;
  String? lastPurchaseCourseMethod;
  String? lastPurchaseCourseCode;
  String? lastPurchaseSessionId;
  String? lastPurchaseSessionMethod;
  String? lastPurchaseSessionCode;

  LoginRequest? lastLoginRequest;
  RegisterStudentRequest? lastRegisterStudentRequest;
  String? lastCourseId;
  String? lastChargeWalletCode;
  PurchaseProductRequest? lastPurchaseProductRequest;
  String? lastSessionInfoId;
  String? lastVideoId;
  FormData? lastUpdateProfileParams;

  @override
  Future<Either<dynamic, LoginResponse>> login({
    required String phone,
    String? password,
    String? otp,
  }) {
    lastLoginRequest = LoginRequest(phone: phone, password: password, otp: otp);
    return _call(loginStub, 'login');
  }

  @override
  Future<Either<dynamic, List<RegisterStage>>> fetchRegistrationStages() {
    return _call(fetchRegistrationStagesStub, 'fetchRegistrationStages');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Either<dynamic, bool>> registerStudent({
    required String name,
    required String phone,
    String? email,
    String? password,
    required int levelId,
  }) {
    lastRegisterStudentRequest = RegisterStudentRequest(
      name: name,
      phone: phone,
      email: email ?? '',
      password: password ?? '',
      levelId: levelId,
    );
    return _call(registerStudentStub, 'registerStudent');
  }

  @override
  Future<Either<dynamic, HomeResponse>> getHome() {
    return _call(getHomeStub, 'getHome');
  }

  @override
  Future<Either<dynamic, GuestCoursesResponse>> getGuestCourses() {
    return _call(getGuestCoursesStub, 'getGuestCourses');
  }

  @override
  Future<Either<dynamic, GetCourseDataResponse>> getCourseData(String id) {
    lastCourseId = id;
    return _call(getCourseDataStub, 'getCourseData');
  }

  @override
  Future<Either<dynamic, UserModelResponse>> getProfile() {
    return _call(getProfileStub, 'getProfile');
  }

  @override
  Future<Either<dynamic, SettingsResponse>> getSettings() {
    return _call(getSettingsStub, 'getSettings');
  }

  @override
  Future<Either<dynamic, GeneralResponse>> updateProfile(FormData params) {
    lastUpdateProfileParams = params;
    return _call(updateProfileStub, 'updateProfile');
  }

  @override
  Future<Either<dynamic, WalletResponse>> getWallet() {
    return _call(getWalletStub, 'getWallet');
  }

  @override
  Future<Either<dynamic, GeneralResponse>> chargeWallet({required String Code}) {
    lastChargeWalletCode = Code;
    return _call(chargeWalletStub, 'chargeWallet');
  }

  @override
  Future<Either<dynamic, StoreProductsResponse>> getStoreProducts() {
    return _call(getStoreProductsStub, 'getStoreProducts');
  }

  @override
  Future<Either<dynamic, GeneralResponse>> verifyStorePurchase({
    required Map<String, dynamic> data,
  }) {
    return _call(verifyStorePurchaseStub, 'verifyStorePurchase');
  }

  @override
  Future<Either<dynamic, CodeAvailabilityResponse>> checkCodeAvailability({
    required int version,
  }) {
    return _call(checkCodeAvailabilityStub, 'checkCodeAvailability');
  }

  @override
  Future<Either<dynamic, GeneralResponse>> purchaseProduct({
    required String type,
    required String id,
  }) {
    lastPurchaseProductRequest = PurchaseProductRequest(type: type, id: id);
    return _call(purchaseProductStub, 'purchaseProduct');
  }

  @override
  Future<Either<dynamic, GeneralResponse>> purchaseCourseSubscription({
    required String courseId,
    required String paymentMethod,
    String? code,
  }) {
    lastPurchaseCourseId = courseId;
    lastPurchaseCourseMethod = paymentMethod;
    lastPurchaseCourseCode = code;
    return _call(purchaseCourseSubscriptionStub, 'purchaseCourseSubscription');
  }

  @override
  Future<Either<dynamic, GeneralResponse>> purchaseSessionSubscription({
    required String sessionId,
    required String paymentMethod,
    String? code,
  }) {
    lastPurchaseSessionId = sessionId;
    lastPurchaseSessionMethod = paymentMethod;
    lastPurchaseSessionCode = code;
    return _call(purchaseSessionSubscriptionStub, 'purchaseSessionSubscription');
  }

  @override
  Future<Either<dynamic, LibraryCoursesResponse>> getLibraryCourses() {
    return _call(getLibraryCoursesStub, 'getLibraryCourses');
  }

  @override
  Future<Either<dynamic, GetSessionInfoResponse>> getSessionInfo(String id) {
    lastSessionInfoId = id;
    return _call(getSessionInfoStub, 'getSessionInfo');
  }

  @override
  Future<Either<dynamic, ShowVideo>> getvideo(String id) {
    lastVideoId = id;
    return _call(getVideoStub, 'getvideo');
  }

  RepositoryStub<CourseCommentsResponse>? getSessionCommentsStub;
  RepositoryStub<CourseCommentItem>? addSessionCommentStub;
  RepositoryStub<CourseCommentItem>? editSessionCommentStub;
  RepositoryStub<bool>? deleteSessionCommentStub;

  RepositoryStub<CourseCommentsResponse>? getCourseCommentsStub;
  RepositoryStub<CourseCommentItem>? addCourseCommentStub;
  RepositoryStub<CourseCommentItem>? editCourseCommentStub;
  RepositoryStub<bool>? deleteCourseCommentStub;

  @override
  Future<Either<dynamic, CourseCommentsResponse>> getSessionComments({
    required dynamic sessionId,
    int page = 1,
    int perPage = 20,
  }) {
    return _call(getSessionCommentsStub ?? getCourseCommentsStub, 'getSessionComments');
  }

  @override
  Future<Either<dynamic, CourseCommentItem>> addSessionComment({
    required dynamic sessionId,
    required String body,
  }) {
    return _call(addSessionCommentStub ?? addCourseCommentStub, 'addSessionComment');
  }

  @override
  Future<Either<dynamic, CourseCommentItem>> editSessionComment({
    required dynamic sessionId,
    required dynamic commentId,
    required String body,
  }) {
    return _call(editSessionCommentStub ?? editCourseCommentStub, 'editSessionComment');
  }

  @override
  Future<Either<dynamic, bool>> deleteSessionComment({
    required dynamic sessionId,
    required dynamic commentId,
  }) {
    return _call(deleteSessionCommentStub ?? deleteCourseCommentStub, 'deleteSessionComment');
  }

  @override
  Future<Either<dynamic, CourseCommentsResponse>> getCourseComments({
    required dynamic courseId,
    int page = 1,
    int perPage = 20,
  }) =>
      getSessionComments(sessionId: courseId, page: page, perPage: perPage);

  @override
  Future<Either<dynamic, CourseCommentItem>> addCourseComment({
    required dynamic courseId,
    required String body,
  }) =>
      addSessionComment(sessionId: courseId, body: body);

  @override
  Future<Either<dynamic, CourseCommentItem>> editCourseComment({
    required dynamic courseId,
    required dynamic commentId,
    required String body,
  }) =>
      editSessionComment(sessionId: courseId, commentId: commentId, body: body);

  @override
  Future<Either<dynamic, bool>> deleteCourseComment({
    required dynamic courseId,
    required dynamic commentId,
  }) =>
      deleteSessionComment(sessionId: courseId, commentId: commentId);

  Future<Either<dynamic, T>> _call<T>(
    RepositoryStub<T>? stub,
    String methodName,
  ) {
    if (stub != null) return stub();
    return Future.value(left('FakeRepository.$methodName was not stubbed'));
  }
}

class LoginRequest {
  const LoginRequest({required this.phone, this.password, this.otp});

  final String phone;
  final String? password;
  final String? otp;
}

class RegisterStudentRequest {
  const RegisterStudentRequest({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.levelId,
  });

  final String name;
  final String phone;
  final String email;
  final String password;
  final int levelId;
}

class PurchaseProductRequest {
  const PurchaseProductRequest({required this.type, required this.id});

  final String type;
  final String id;
}
