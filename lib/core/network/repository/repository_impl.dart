part of 'repository_imports.dart';

class RepoImpl extends Repository {
  final DioHelper dioHelper;
  RepoImpl(this.dioHelper);

  /// ============================== Auth ==================================

  @override
  Future<Either<dynamic, LoginResponse>> login({required String phone, String? password, String? otp}) async {
    return responseHandling<LoginResponse>(
      onSuccess: () async {
        final response =
            await dioHelper.post(EndPoints.login, data:password != null ? {
          'phone': phone,
          'password': password,
        } : {
          'phone': phone,
          'otp': otp,
        });
        return LoginResponse.fromJson(response.data);
      },
    );
  }

  @override
  Future<Either<dynamic, List<RegisterStage>>> fetchRegistrationStages() async {
    return responseHandling<List<RegisterStage>>(
      onSuccess: () async {
        final response = await dioHelper.get(EndPoints.stagesEndPoint);
        final raw = response.data['stages'] ?? response.data['data'];
        final List<RegisterStage> data = raw is List
            ? List<RegisterStage>.from(raw.map((e) => RegisterStage.fromJson(e)))
            : <RegisterStage>[];
        return data;
      },
    );
  }

  @override
  Future<Either<dynamic, bool>> registerStudent({
    required String name,
    required String phone,
    required String email,
    required String password,
    required int levelId,
  }) async {
    return responseHandling<bool>(
      onSuccess: () async {
        await dioHelper.post(EndPoints.registerStudent, data: {
          'name': name,
          'phone': phone,
          'email': email,
          'password': password,
          'level_id': levelId,
        });
        return true;
      },
    );
  }

  // @override
  // Future<Either<dynamic, UserModelResponse>> submitOtp(OtpParams params) async {
  //   return responseHandling<UserModelResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper.post(
  //         EndPoints.verifyOtp,
  //         data: params.toMap(),
  //       );
  //       return UserModelResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, Unit>> resendOtp(ResendOtpParams params) {
  //   return responseHandling<Unit>(
  //     onSuccess: () async {
  //       await dioHelper.post(EndPoints.resendOtpEndPoint, data: params.toMap());
  //       return unit;
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, BlockResponse>> blockReason(String phone) {
  //   return responseHandling<BlockResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(
  //         EndPoints.blockReasonEndPoint + phone,
  //       );
  //       return BlockResponse.fromJson(response.data['data']);
  //     },
  //   );
  // }

 
  // /// ============================== Profile ==================================
  @override
  Future<Either<dynamic, UserModelResponse>> getProfile() async {
    return responseHandling<UserModelResponse>(
      onSuccess: () async {
        final f = await dioHelper.get(EndPoints.getProfileAPI);
        return UserModelResponse.fromJson(f.data);
      },
    );
  }

  @override
  Future<Either<dynamic, SettingsResponse>> getSettings() async {
    return responseHandling<SettingsResponse>(
      onSuccess: () async {
        final f = await dioHelper.get('https://api.aplusplatforms.com/api/tenant');
        return SettingsResponse.fromJson(f.data);
      },
    );
  }

  @override
  Future<Either<dynamic, GeneralResponse>> updateProfile(
      FormData params) async {
    return responseHandling<GeneralResponse>(
      onSuccess: () async {
        final response = await dioHelper.post(
          EndPoints.updateProfileAPI,
          data: params,
        );
        return GeneralResponse.fromJson(response.data);
      },
    );
  }

  // @override
  // Future<Either<dynamic, UserModelResponse>> updateProfileImage(
  //     String image) async {
  //   return responseHandling<UserModelResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper.post(
  //         EndPoints.updateProfileImageAPI,
  //         data: {'image': await MultipartFile.fromFile(image)},
  //       );
  //       return UserModelResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, FavouriteCourseResponse>> getFavouriteCourses() async {
  //   return responseHandling<FavouriteCourseResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(EndPoints.getFavouriteCourseApi);
  //       return FavouriteCourseResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, Unit>> addFavouriteCourses(String id) async {
  //   return responseHandling<Unit>(
  //     onSuccess: () async {
  //       await dioHelper.post(EndPoints.addFavouriteCourseApi(id));
  //       return unit;
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, String>> logout() {
  //   return responseHandling<String>(
  //     onSuccess: () async {
  //       final response = await dioHelper.post(EndPoints.logout);
  //       return response.data['message'];
  //     },
  //   );
  // }

  // @override

  // /// endpoint not ready yet
  // Future<Either<dynamic, String>> delete() {
  //   return responseHandling<String>(
  //     onSuccess: () async {
  //       final response = await dioHelper.post(EndPoints.delete);
  //       return response.data['message'];
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, PaymentWayResponse>> getPaymentWays() {
  //   return responseHandling<PaymentWayResponse>(
  //     onSuccess: () async {
  //       final res = await dioHelper.get(EndPoints.getPaymentWays);
  //       return PaymentWayResponse.fromJson(res.data);
  //     },
  //   );
  // }

  // /// ============================== Wallet ==================================

  @override
  Future<Either<dynamic, GeneralResponse>> chargeWallet({
    required String Code,
  }) {
    return responseHandling<GeneralResponse>(
      onSuccess: () async {
        final res = await dioHelper.post(
          EndPoints.ChargeWithCode,
          data: {'code': Code},
        );
        return GeneralResponse.fromJson(res.data);
      },
    );
  }

  @override
  Future<Either<dynamic, GeneralResponse>> purchaseProduct({
    required String type,
    required String id,
  }) {
    return responseHandling<GeneralResponse>(
      onSuccess: () async {
        final res = await dioHelper.post(
          EndPoints.purchaseProduct,
          data: {'type': type, 'id': id},
        );
        return GeneralResponse.fromJson(res.data);
      },
    );
  }
   


  @override
  Future<Either<dynamic, WalletResponse>> getWallet() {
    return responseHandling<WalletResponse>(
      onSuccess: () async {
        final res = await dioHelper.get(EndPoints.getWallet);
        return WalletResponse.fromJson(res.data);
      },
    );
  }

  // /// ============================== Home ==================================

  @override
  Future<Either<dynamic, HomeResponse>> getHome() {
    return responseHandling<HomeResponse>(
      onSuccess: () async {
        final response = await dioHelper.get(EndPoints.gethome);
        return HomeResponse.fromJson(response.data);
      },
    );
  }

  // @override
  // Future<Either<dynamic, GetSubjectsResponse>> getSubjects() {
  //   return responseHandling<GetSubjectsResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(EndPoints.getSubjectsApi);
  //       return GetSubjectsResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // // @override
  // // Future<Either<dynamic, GetLessonsResponse>> getLessons() {
  // //   return responseHandling<GetLessonsResponse>(
  // //     onSuccess: () async {
  // //       final response = await dioHelper.get(EndPoints.lessonsApi);
  // //       return GetLessonsResponse.fromJson(response.data);
  // //     },
  // //   );
  // // }

  // @override
  // Future<Either<dynamic, GetNewCoursesResponse>> getNewCourses() {
  //   return responseHandling<GetNewCoursesResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(EndPoints.newCourseApi);
  //       return GetNewCoursesResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, RecommendedLessonsResponse>> getLessons() {
  //   return responseHandling<RecommendedLessonsResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(EndPoints.getRecommendedLessons);
  //       return RecommendedLessonsResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, GetRecommendedLessonResponse>>
  //     getRecommendedLessonsById(int id) {
  //   return responseHandling<GetRecommendedLessonResponse>(
  //     onSuccess: () async {
  //       final response =
  //           await dioHelper.get(EndPoints.getRecommendedLessonsById(id));
  //       return GetRecommendedLessonResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, GetRecommendedFilesResponse>> getRecommendedFiles() {
  //   return responseHandling<GetRecommendedFilesResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(EndPoints.getRecommendedFiles);
  //       return GetRecommendedFilesResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, GetCourseChapterResponse>> getCourseChapter(
  //     String id) {
  //   return responseHandling<GetCourseChapterResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(EndPoints.getCourseChapter(id));
  //       return GetCourseChapterResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, GetLessonProfileResponse>> getLessonProfile(int id) {
  //   return responseHandling<GetLessonProfileResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(EndPoints.getLessonProfile(id));
  //       return GetLessonProfileResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, GetAttachmentResponse>> getAttachment(int id) {
  //   return responseHandling<GetAttachmentResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(EndPoints.getAttachment(id));
  //       return GetAttachmentResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, CourseAttachmentResponse>> LibraryCourseattachment(
  //     int id) {
  //   return responseHandling<CourseAttachmentResponse>(
  //     onSuccess: () async {
  //       final response =
  //           await dioHelper.get(EndPoints.LibraryCourseattachment(id));
  //       return CourseAttachmentResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, SubjectCoursesResponse>> getSubjectCourses(String id) {
  //   return responseHandling<SubjectCoursesResponse>(
  //     onSuccess: () async {
  //       final response =
  //           await dioHelper.get(EndPoints.getCoursesSubjectsApi(id));
  //       return SubjectCoursesResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, GetAllSubjectsResponse>> getAllSubjects() {
  //   return responseHandling<GetAllSubjectsResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(EndPoints.getAllSubjects);
  //       return GetAllSubjectsResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, GetSubjectChaptersResponse>> getSubjectChapters(
  //     {required String id}) {
  //   return responseHandling<GetSubjectChaptersResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(EndPoints.getSubjectChapters(id));
  //       return GetSubjectChaptersResponse.fromJson(response.data);
  //     },
  //   );
  // }

  @override
  Future<Either<dynamic, GetCourseDataResponse>> getCourseData(String id) {
    return responseHandling<GetCourseDataResponse>(
      onSuccess: () async {
        final res = await dioHelper.get(EndPoints.getCourseData(id));
        return GetCourseDataResponse.fromJson(res.data);
      },
    );
  }

  // // @override
  // // Future<Either<dynamic, GetCourseDataResponse>> addCourseFeedBack(String id) {
  // //   return responseHandling<GetCourseDataResponse>(
  // //     onSuccess: () async {
  // //       final res = await dioHelper.get(EndPoints.addCourseFeedBack(id));
  // //       return GetCourseDataResponse.fromJson(res.data);
  // //     },
  // //   );
  // // }

  // @override
  // Future<Either<dynamic, GetCourseRateReviewResponse>> getCourseRateReview(
  //     int id) {
  //   return responseHandling<GetCourseRateReviewResponse>(
  //     onSuccess: () async {
  //       final res = await dioHelper.get(EndPoints.getCourseRateReview(id));
  //       return GetCourseRateReviewResponse.fromJson(res.data);
  //     },
  //   );
  // }

  // /// ============================== Quizes ==================================

  // @override
  // Future<Either<dynamic, QuizOptionsResponse>> getCreateQuizeOption(
  //     context) async {
  //   try {
  //     // Check if context is a BuildContext
  //     if (context is! BuildContext) {
  //       return left('Invalid context provided');
  //     }

  //     // Safely get the Cubit
  //     final cubit = context.read<CreateQuizeCubit>();

  //     // Check if notsubscribesubjects is not empty
  //     if (cubit.notSubscribedSubjects.isEmpty) {
  //       return left('No unsubscribed subjects available');
  //     }

  //     return right(QuizOptionsResponse(
  //         status: 200, message: 'Success', data: cubit.notSubscribedSubjects));
  //   } catch (e) {
  //     return left('Error generating quiz options: $e');
  //   }
  // }

  // @override
  // Future<Either<dynamic, QuizQuestionsResponse>> getQuizeQuestions(
  //     {required int id, required int page, required pageSize}) async {
  //   return responseHandling<QuizQuestionsResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(EndPoints.getLessonsQuestions(id),
  //           queryParams: {'page': page, 'pageSize': pageSize});
  //       return QuizQuestionsResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, GetChapterLessonsResponse>> getChapterLessons(
  //     {required String id}) {
  //   return responseHandling<GetChapterLessonsResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(EndPoints.getChapterLessons(id));
  //       return GetChapterLessonsResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, GetLessonQuestionResponse>> getLessonQuestion(
  //     {required String id}) {
  //   return responseHandling<GetLessonQuestionResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(EndPoints.getChapterQuestions(id));
  //       return GetLessonQuestionResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, Unit>> submitQuestionAnswer(
  //     {required int questionId, required int answerId, required int quizId}) {
  //   return responseHandling<Unit>(
  //     onSuccess: () async {
  //       await dioHelper.post(EndPoints.trainingStudentAnswers, data: {
  //         'chapter_id': quizId,
  //         'training': [
  //           {'ask_id': questionId, 'answer_id': answerId}
  //         ]
  //       });
  //       return unit;
  //     },
  //   );
  // }

  // /// ============================== Library ==================================

  @override
  Future<Either<dynamic, LibraryCoursesResponse>> getLibraryCourses() {
    return responseHandling<LibraryCoursesResponse>(
      onSuccess: () async {
        final response = await dioHelper.get(EndPoints.getLibraryCourses);
        return LibraryCoursesResponse.fromJson(response.data);
      },
    );
  }

  // @override
  // Future<Either<dynamic, StudentPdfProfileResponse>> trackStudentPdfProfile(
  //     String id) {
  //   return responseHandling<StudentPdfProfileResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper.post(
  //         EndPoints.trackStudentPdfProfile,
  //         data: {'attachment_id': id},
  //       );
  //       return StudentPdfProfileResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, GetSheetInfoResponse>> getSheetInfo(String id) {
  //   return responseHandling<GetSheetInfoResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper
  //           .post(EndPoints.getSheetInfo, data: {'sheet_id': id});
  //       return GetSheetInfoResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, GetAttachmentFileResponse>> getAttachmentFile(
  //     String id) {
  //   return responseHandling<GetAttachmentFileResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(EndPoints.getAttachmentFile(id));
  //       return GetAttachmentFileResponse.fromJson(response.data['data']);
  //     },
  //   );
  // }

  // /// ============================== session ==================================

  @override
  Future<Either<dynamic, GetSessionInfoResponse>> getSessionInfo(String id) {
    return responseHandling<GetSessionInfoResponse>(
      onSuccess: () async {
        final response = await dioHelper
            .get(EndPoints.getSessionInfo(id), queryParams: {'session_id': id});
        return GetSessionInfoResponse.fromJson(response.data);
      },
    );
  }

  @override
  Future<Either<dynamic, ShowVideo>> getvideo(String id) {
    return responseHandling<ShowVideo>(
      onSuccess: () async {
        final response = await dioHelper.get(
          EndPoints.ShowVideo(id),
        );
        return ShowVideo.fromJson(response.data);
      },
    );
  }

  // @override
  // Future<Either<dynamic, CourseProfileResponse>> getCoursesProfile(String id) {
  //   return responseHandling<CourseProfileResponse>(
  //     onSuccess: () async {
  //       final response =
  //           await dioHelper.get(EndPoints.LibraryCourseProfile(id));
  //       return CourseProfileResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, QrResponse>> QrSubscribe(String qr) {
  //   return responseHandling<QrResponse>(
  //     onSuccess: () async {
  //       final response =
  //           await dioHelper.post(EndPoints.QrSubscribe, data: {'qr': qr});
  //       return QrResponse.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, Unit>> EndExam(String id) {
  //   return responseHandling<Unit>(
  //     onSuccess: () async {
  //       final response = await dioHelper.post(
  //         EndPoints.EndExam(id),
  //       );
  //       return unit;
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, Unit>> StartExam(String id) {
  //   return responseHandling<Unit>(
  //     onSuccess: () async {
  //       final response = await dioHelper.post(
  //         EndPoints.StartExam(id),
  //       );
  //       return unit;
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, AllExam>> getAllExams() {
  //   return responseHandling<AllExam>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(EndPoints.getAllExams);
  //       return AllExam.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, SingleExam>> getExamDeatils(String id) {
  //   return responseHandling<SingleExam>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(EndPoints.getExamDeatils(id));
  //       return SingleExam.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, ExamQuestions>> getExamQuestion(String id) {
  //   return responseHandling<ExamQuestions>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(EndPoints.getExamQuestion(id));
  //       return ExamQuestions.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, Unit>> submitExamQuestionAnswer(
  //     {required int questionId, required int answerId, required int examId}) {
  //   return responseHandling<Unit>(
  //     onSuccess: () async {
  //       final response = await dioHelper.post(EndPoints.submitExam, data: {
  //         'exam_id': examId,
  //         'ask_id': questionId,
  //         'answer_id': answerId
  //       });
  //       return unit;
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, Unit>> checkSignature(
  //     {required String signature, required String nonce}) {
  //   return responseHandling<Unit>(
  //     onSuccess: () async {
  //       final response = await dioHelper.post(EndPoints.CheckSignature, data: {
  //         'device_id': di<CacheHelper>().get('device_id'),
  //         'nonce': nonce,
  //         'signature': signature
  //       });
  //       return unit;
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, GetNoncemodel>> getNonce() {
  //   return responseHandling<GetNoncemodel>(
  //     onSuccess: () async {
  //       final response = await dioHelper.post(EndPoints.getNonce, data: {
  //         'device_id': di<CacheHelper>().get('device_id') ?? '',
  //       });
  //       return GetNoncemodel.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, StorCertModel>> storeSignature(
  //     {required String signature,
  //     required String nonce,
  //     required List attestationChain,
  //     required String public_key,
  //     required String model,
  //     required String os_version,
  //     required String widevine_level,
  //     required bool has_hw_decoder}) {
  //   return responseHandling<StorCertModel>(
  //     onSuccess: () async {
  //       final response = await dioHelper.post(EndPoints.StoreSignature, data: {
  //         "device_id": di<CacheHelper>().get('device_id'),
  //         "nonce": nonce,
  //         "signature": signature,
  //         "attestationChain": attestationChain,
  //         "public_key": public_key,
  //         "device_info": {
  //           "model": model,
  //           "os_version": os_version,
  //           "widevine_level": widevine_level,
  //           "has_hw_decoder": has_hw_decoder
  //         }
  //       });
  //       return StorCertModel.fromJson(response.data);
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, Unit>> endWatch(
  //     {required String id, required String last_point}) {
  //   return responseHandling<Unit>(
  //     onSuccess: () async {
  //       final response = await dioHelper.post(EndPoints.endWatch(id), data: {
  //         'last_point': last_point,
  //       });
  //       return unit;
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, Unit>> startWatch(
  //     {required String id, required String last_point}) {
  //   return responseHandling<Unit>(
  //     onSuccess: () async {
  //       final response = await dioHelper.post(EndPoints.startWatch(id), data: {
  //         'last_point': last_point,
  //       });
  //       return unit;
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, Map<String, dynamic>>> current_version() {
  //   return responseHandling<Map<String, dynamic>>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(EndPoints.currentversion);
  //       return response.data;
  //     },
  //   );
  // }

  // @override
  // Future<Either<dynamic, LibraryCoursesResponse>> getLibraryAttachments() {
  //   return responseHandling<LibraryCoursesResponse>(
  //     onSuccess: () async {
  //       final response = await dioHelper.get(EndPoints.getLibraryCourses);
  //       return LibraryCoursesResponse.fromJson(response.data);
  //     },
  //   );
  // }
}
