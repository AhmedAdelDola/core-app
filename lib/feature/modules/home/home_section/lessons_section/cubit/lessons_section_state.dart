part of 'lessons_section_cubit.dart';

class LessonsSectionState {}

class LessonsSectionInitial extends LessonsSectionState {}

class GetSubjectCoursesLoadingState extends LessonsSectionState {}

class GetSubjectCoursesSuccessState extends LessonsSectionState {}

class GetSubjectCoursesErrorState extends LessonsSectionState {
  final String error;

  GetSubjectCoursesErrorState(this.error);
}

class ChangeSuccessState extends LessonsSectionState {
  final Axis axis;
  ChangeSuccessState({required this.axis});

  factory ChangeSuccessState.initial() {
    return ChangeSuccessState(axis: Axis.horizontal);
  }
}
