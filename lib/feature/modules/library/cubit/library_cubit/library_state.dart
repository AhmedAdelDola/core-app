part of 'library_cubit.dart';

abstract class LibraryState {}

class LibraryInitialState extends LibraryState {}

class GetLibraryCoursesLoadingState extends LibraryState {}

class GetLibraryCoursesErrorState extends LibraryState {
  final String error;

  GetLibraryCoursesErrorState(this.error);
}

class GetLibraryCoursesSuccessState extends LibraryState {}

// class GetChapterLessonsLoadingState extends LibraryState {}

// class GetChapterLessonsErrorState extends LibraryState {
//   final String error;

//   GetChapterLessonsErrorState(this.error);
// }

// class GetChapterLessonsSuccessState extends LibraryState {
//   final GetChapterLessonsResponse model;

//   GetChapterLessonsSuccessState(this.model);
// }

// class GetLessonQuestionLoadingState extends LibraryState {}

// class GetLessonQuestionErrorState extends LibraryState {
//   final String error;

//   GetLessonQuestionErrorState(this.error);
// }

// class GetLessonQuestionSuccessState extends LibraryState {
//   final GetLessonQuestionResponse model;

//   GetLessonQuestionSuccessState(this.model);
// }

// class GetAllSubjectsChaptersLoadingState extends LibraryState {}

// class GetAllSubjectsChaptersErrorState extends LibraryState {
//   final String error;

//   GetAllSubjectsChaptersErrorState(this.error);
// }

// class GetAllSubjectsChaptersSuccessState extends LibraryState {
//   final GetSubjectChaptersResponse model;

//   GetAllSubjectsChaptersSuccessState(this.model);
// }
