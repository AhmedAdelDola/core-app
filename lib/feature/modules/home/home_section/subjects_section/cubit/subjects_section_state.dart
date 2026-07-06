part of 'subjects_section_cubit.dart';

class SubjectsSectionState {}

class SubjectsSectionInitial extends SubjectsSectionState {}

class GetSubjectCoursesLoadingState extends SubjectsSectionState {}

class GetSubjectCoursesSuccessState extends SubjectsSectionState {}

class GetSubjectCoursesErrorState extends SubjectsSectionState {
  final String error;

  GetSubjectCoursesErrorState(this.error);
}
