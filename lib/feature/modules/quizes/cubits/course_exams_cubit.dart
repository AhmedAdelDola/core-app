import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/repository/repository_imports.dart';
import '../../../../models/exams/course_exams_response.dart';
import 'course_exams_state.dart';

class CourseExamsCubit extends Cubit<CourseExamsState> {
  final Repository repository;

  CourseExamsCubit(this.repository) : super(CourseExamsInitial());

  static CourseExamsCubit of(BuildContext context) => BlocProvider.of<CourseExamsCubit>(context);

  List<CourseExamItem> exams = [];

  Future<void> getCourseExams(dynamic courseId) async {
    emit(CourseExamsLoading());
    final result = await repository.getCourseExams(courseId);

    result.fold(
      (failure) {
        emit(CourseExamsError(failure.toString()));
      },
      (response) {
        exams = response.exams ?? [];
        emit(CourseExamsSuccess(
          courseId: response.courseId,
          exams: exams,
        ));
      },
    );
  }
}
