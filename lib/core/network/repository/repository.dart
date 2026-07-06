part of 'repository_imports.dart';

abstract class Repository {
  /// ================== Auth ==================
  Future<Either<dynamic, LoginResponse>> login({required String phone, String? password, String? otp});
  Future<Either<dynamic, List<RegisterStage>>> fetchRegistrationStages();
  Future<Either<dynamic, bool>> registerStudent({
    required String name,
    required String phone,
    required String email,
    required String password,
    required int levelId,
  });
  Future<Either<dynamic, HomeResponse>> getHome();
  // Future<Either<dynamic, Unit>> resendOtp(ResendOtpParams params);
  // Future<Either<dynamic, BlockResponse>> blockReason(String phone);
  // Future<Either<dynamic, bool>> basicInformation(
  //     String firstName, String lastName);
  // Future<Either<dynamic, bool>> uploadAuthImage(File params);
  // Future<Either<dynamic, Unit>> uploadGenderTypeRequest(String params);
  // Future<Either<dynamic, Unit>> completeEducationLevel(
  //     CompleteEducationLevelParams params);
  // Future<Either<dynamic, List<City>>> getCountries();
  // Future<Either<dynamic, List<City>>> getGovernorates(int id);
  // Future<Either<dynamic, List<City>>> getCities(int id);
  // Future<Either<dynamic, List<University>>> getUniversities(int countryId);
  // Future<Either<dynamic, List<Stage>>> getStages(int countryId,
  //     int? universityId, String type); // type => basic or college
  // Future<Either<dynamic, List<Grade>>> getStageGrades(int stageId);
  // Future<Either<dynamic, Unit>> chooseEducationArea(int id);
  Future<Either<dynamic, GetCourseDataResponse>> getCourseData(String id);
  // Future<Either<dynamic, GetCourseRateReviewResponse>> getCourseRateReview(
  //     int id);

  // /// ================== Profile ==================
  Future<Either<dynamic, UserModelResponse>> getProfile();
  Future<Either<dynamic, SettingsResponse>> getSettings();
  Future<Either<dynamic, GeneralResponse>> updateProfile(
      FormData params,);

  // /// not use yet
  // Future<Either<dynamic, UserModelResponse>> updateProfileImage(String image);
  // Future<Either<dynamic, String>> logout();
  // Future<Either<dynamic, String>> delete();
  // Future<Either<dynamic, FavouriteCourseResponse>> getFavouriteCourses();
  // Future<Either<dynamic, Unit>> addFavouriteCourses(String id);

  // /// ================== Notifications ==================
  // Future<Either<dynamic, GetNotificationsResponse>> getNotifications();

  // /// ================== Home ==================
  // // Future<Either<dynamic, GetBannerResponse>> getBannerData();
  // Future<Either<dynamic, GetSubjectsResponse>> getSubjects();
  // Future<Either<dynamic, GetNewCoursesResponse>> getNewCourses();
  // Future<Either<dynamic, RecommendedLessonsResponse>> getLessons();
  // Future<Either<dynamic, GetRecommendedLessonResponse>>
  //     getRecommendedLessonsById(int id);
  // // Future<Either<dynamic, GetLessonsResponse>> getLessons();
  // Future<Either<dynamic, GetRecommendedFilesResponse>> getRecommendedFiles();
  // Future<Either<dynamic, SubjectCoursesResponse>> getSubjectCourses(String id);
  // Future<Either<dynamic, PaymentWayResponse>> getPaymentWays();
  
  // Future<Either<dynamic, GetCourseChapterResponse>> getCourseChapter(String id);

  // Future<Either<dynamic, GetLessonProfileResponse>> getLessonProfile(int id);

  // Future<Either<dynamic, GetAttachmentResponse>> getAttachment(int id);

  Future<Either<dynamic, WalletResponse>> getWallet();
  Future<Either<dynamic, GeneralResponse>> chargeWallet({required String Code,});
    Future<Either<dynamic, GeneralResponse>> purchaseProduct({required String type,required String id,});

  // Future<Either<dynamic, QrResponse>> QrSubscribe(String qr);

  // /// ================== Quizes ==================
  // Future<Either<dynamic, QuizOptionsResponse>> getCreateQuizeOption(context);
  // Future<Either<dynamic, Unit>> submitQuestionAnswer({
  //   required int questionId,
  //   required int answerId,
  //   required int quizId,
  // });
  // Future<Either<dynamic, Unit>> submitExamQuestionAnswer({
  //   required int questionId,
  //   required int answerId,
  //   required int examId,
  // });
  // Future<Either<dynamic, Unit>> StartExam(String id);
  // Future<Either<dynamic, Unit>> EndExam(String id);
  // Future<Either<dynamic, QuizQuestionsResponse>> getQuizeQuestions({
  //   required int id,
  //   required int page,
  //   required int pageSize, // Chapter ID , Lesson Id  ,
  // });

  // Future<Either<dynamic, GetAllSubjectsResponse>> getAllSubjects();
  // Future<Either<dynamic, AllExam>> getAllExams();
  // Future<Either<dynamic, ExamQuestions>> getExamQuestion(String id);
  // Future<Either<dynamic, SingleExam>> getExamDeatils(String id);
  // Future<Either<dynamic, GetSubjectChaptersResponse>> getSubjectChapters(
  //     {required String id});

  // Future<Either<dynamic, GetChapterLessonsResponse>> getChapterLessons(
  //     {required String id});
  // Future<Either<dynamic, GetLessonQuestionResponse>> getLessonQuestion(
  //     {required String id});

  // /// ============================== Library ==================================

  Future<Either<dynamic, LibraryCoursesResponse>> getLibraryCourses();
  // Future<Either<dynamic, StudentPdfProfileResponse>> trackStudentPdfProfile(
  //     String id);
  // Future<Either<dynamic, CourseProfileResponse>> getCoursesProfile(String id);
  // Future<Either<dynamic, GetSheetInfoResponse>> getSheetInfo(String id);

  // Future<Either<dynamic, GetAttachmentFileResponse>> getAttachmentFile(
  //     String id);
  // Future<Either<dynamic, CourseAttachmentResponse>> LibraryCourseattachment(
  //     int id);
  Future<Either<dynamic, GetSessionInfoResponse>> getSessionInfo(String id);
  Future<Either<dynamic, ShowVideo>> getvideo(String id);

  // /// ============================== Check device ==================================
  // Future<Either<dynamic, GetNoncemodel>> getNonce();
  // Future<Either<dynamic, StorCertModel>> storeSignature({
  //   required String signature,
  //   required String nonce,
  //   required List attestationChain,
  //   required String public_key,
  //   required String model,
  //   required String os_version,
  //   required String widevine_level,
  //   required bool has_hw_decoder,
  // });
  // Future<Either<dynamic, Unit>> checkSignature({
  //   required String signature,
  //   required String nonce,
  // });
  // Future<Either<dynamic, Unit>> startWatch({
  //   required String id,
  //   required String last_point,
  // });
  // Future<Either<dynamic, Unit>> endWatch({
  //   required String id,
  //   required String last_point,
  // });
  // Future<Either<dynamic, Map<String,dynamic>>> current_version();
}
