class EndPoints {
  /// ============================== Auth ==================================
  static const String login = 'auth/login';
  static const String verifyOtp = 'auth/verify';
  static const String stagesEndPoint = 'registration-options';
  static const String registerStudent = 'auth/register';
  static const String currentversion = 'general/current-version';

  static const String universitiesEndPoint = 'general/universities';
  static String governoratesEndPoint(String id) =>
      'general/countries/$id/governorates';
  static String citiesEndPoint(String id) => 'general/governorates/$id/cities';
  static String gradesEndPoint(int id) => 'general/stages/$id/grades';
  static const String completeEduLevelAPI = 'new-education-level';
  static String getLessonsQuestions(int id) => 'lessons/questions/$id';
  static const String trainingStudentAnswers = 'training/student/answers';

  /// ============================== Profile ==================================
  static const String getSettingsApi = 'general/settings';
  static const String getProfileAPI = 'auth/me';
  static const String updateProfileAPI = 'auth/profile';
  static const String logout = 'auth/logout';
  static const String delete = 'auth/delete';
  static const String getFavouriteCourseApi = 'course/favourite';
  static String addFavouriteCourseApi(String id) => 'course/$id/favourite';
  static const String updateProfileImageAPI = 'update-image-profile';

  /// ============================== Notifications ==================================

  static const String getNotifications = 'notifications';

  /// ============================== Home ==================================

  static const String gethome = 'home';
  // static const String getSubjectsApi = 'subjects';
  // static String getCoursesSubjectsApi(String id) => 'subjects/$id/courses';
  // static const String lessonsApi = 'lessons';
  // static const String newCourseApi = 'course/suggestion';
  // static const String getRecommendedLessons = 'session/suggestion';
  // static String getRecommendedLessonsById(int id) =>
  //     'track_student/get_session_info?session_id=$id';

  // static const String getRecommendedFiles = 'attachment/suggestion';
  // static const String QrSubscribe = 'subscribe';
  // static String getCourseChapter(String id) => 'course/get_course_chapter/$id';
  // static String getLessonProfile(int id) => 'lessons/get_lesson_info/$id';
  // static String getAttachment(int id) =>
  //     'attachment/show_attachment_profile/$id';

  /// ============================== Quizes ==================================
  static const String getAllSubjects = 'all-subjects';
  static const String getAllExams = 'exams/list';
  static String getExamQuestion(String id) => 'exams/exam_asks/$id';
  static String getExamDeatils(String id) => 'exams/$id';
  static String StartExam(String id) => 'exams/start/$id';
  static String EndExam(String id) => 'exams/end/$id';
  static const String submitExam = 'training/submit_student_answers';
  static String getSubjectChapters(String id) => 'subject/$id/chapters';
  static String getChapterLessons(String id) => 'lessons/chapter/$id';
  static String getCourseData(String id) => 'courses/$id';
  static String getCourseRateReview(int id) => 'course/$id/get_course_review';
  // static String getLessonQuestion(String id) => 'lessons/questions/$id';

  /// ============================== Wallet ==================================
  static const String getWallet = 'wallet';
  static String ChargeWithCode = 'wallet/redeem-code';
  static String purchaseProduct = 'wallet/purchase';

  /// ============================== Library ==================================
  static const String getLibraryCourses = 'my-courses';
  static String LibraryCourseProfile(String id) =>
      'course/get_course_profile/$id';
  static String LibraryCourseattachment(int id) =>
      'course/get_course_attachment/$id';
  static const String trackStudentPdfProfile = 'track_student/pdf_profile';
  static const String getSheetInfo = 'track_student/get_sheet_info';

  /// ============================== session ==================================
  static String ShowVideo(String id) => 'sessions/$id/player-link';
  static String getSessionInfo(String id) => 'sessions/$id';

  /// ============================== Device check ==================================
  static String getNonce = 'device/attestation/challenge';
  static String StoreSignature = 'device/attestation/complete';
  static String CheckSignature = 'device/attestation/prove';
}
