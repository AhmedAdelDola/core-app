import 'package:equatable/equatable.dart';
import '../../../../models/exams/course_exams_response.dart';

abstract class CourseExamsState extends Equatable {
  const CourseExamsState();

  @override
  List<Object?> get props => [];
}

class CourseExamsInitial extends CourseExamsState {}

class CourseExamsLoading extends CourseExamsState {}

class CourseExamsSuccess extends CourseExamsState {
  final int? courseId;
  final List<CourseExamItem> exams;

  const CourseExamsSuccess({
    this.courseId,
    required this.exams,
  });

  @override
  List<Object?> get props => [courseId, exams];
}

class CourseExamsError extends CourseExamsState {
  final String message;

  const CourseExamsError(this.message);

  @override
  List<Object?> get props => [message];
}
