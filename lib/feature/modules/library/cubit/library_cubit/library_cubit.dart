import 'package:elhanbly/models/home_entities/courses/get_course_data_response_model.dart';
import 'package:elhanbly/models/home_entities/courses/get_my_courses.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/repository/repository_imports.dart';


part 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  final Repository repo;
  LibraryCubit(this.repo) : super(LibraryInitialState());
  static LibraryCubit of(context) => BlocProvider.of(context);

  LibraryCoursesResponse? libraryCourses;
  void getLibraryCourses() async {
    emit(GetLibraryCoursesLoadingState());
    final f = await repo.getLibraryCourses();
    f.fold(
      (l) => emit(GetLibraryCoursesErrorState(l.toString())),
      (r) {
        libraryCourses = r;

        emit(GetLibraryCoursesSuccessState());
      },
    );
  }

  GetCourseDataResponse? courseProfileResponse;
  void getCourseProfile(String id) async {
    emit(GetLibraryCoursesLoadingState());
    final f = await repo.getCourseData( id);
    f.fold(
      (l) => emit(GetLibraryCoursesErrorState(l.toString())),
      (r) {
        courseProfileResponse = r;

        emit(GetLibraryCoursesSuccessState());
      },
    );
  }

  // void getLibraryAttachments() async {
  //   emit(GetLibraryCoursesLoadingState());
  //   final f = await repo.getLibraryAttachments();
  //   f.fold(
  //     (l) => emit(GetLibraryCoursesErrorState(l.toString())),
  //     (r) {
  //       libraryCourses = r;
  //       emit(GetLibraryCoursesSuccessState());
  //     },
  //   );
  // }

  /// getAllSubjectsChapters
  // GetSubjectChaptersResponse? subjectChapters;
  // void getAllSubjectsChapters(String id) async {
  //   emit(GetAllSubjectsChaptersLoadingState());
  //   final f = await repo.getSubjectChapters(id: id);
  //   f.fold(
  //     (l) => emit(GetAllSubjectsChaptersErrorState(l.toString())),
  //     (r) {
  //       subjectChapters = r;
  //       emit(GetAllSubjectsChaptersSuccessState(r));
  //     },
  //   );
  // }

  /// getChapterLessons
  // GetChapterLessonsResponse? chapterLessons;
  // void getChapterLessons(String id) async {
  //   emit(GetChapterLessonsLoadingState());
  //   final f = await repo.getChapterLessons(id: id);
  //   f.fold(
  //     (l) => emit(GetChapterLessonsErrorState(l.toString())),
  //     (r) {
  //       chapterLessons = r;
  //       emit(GetChapterLessonsSuccessState(r));
  //     },
  //   );
  // }

  // GetLessonQuestionResponse? lessonQuestion;
  // void getLessonQuestion(String id) async {
  //   emit(GetLessonQuestionLoadingState());
  //   final f = await repo.getLessonQuestion(id: id);
  //   f.fold(
  //     (l) => emit(GetLessonQuestionErrorState(l.toString())),
  //     (r) {
  //       lessonQuestion = r;
  //       emit(GetLessonQuestionSuccessState(r));
  //     },
  //   );
  // }
}
