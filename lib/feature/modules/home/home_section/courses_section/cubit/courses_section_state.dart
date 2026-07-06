part of 'courses_section_cubit.dart';

class CoursesSectionState {}

class CoursesSectionInitial extends CoursesSectionState {}

class GetCourseDataLoadingState extends CoursesSectionState {}

class GetCourseDataErrorState extends CoursesSectionState {
  final String error;

  GetCourseDataErrorState(this.error);
}

class GetCourseDataSuccessState extends CoursesSectionState {}

class GetCourseRateReviewLoadingState extends CoursesSectionState {}

class GetCourseRateReviewErrorState extends CoursesSectionState {
  final String error;
  GetCourseRateReviewErrorState(this.error);
}

class GetCourseRateReviewSuccessState extends CoursesSectionState {}

class GetCourseChapterLoadingState extends CoursesSectionState {}

class GetCourseChapterErrorState extends CoursesSectionState {
  final String error;

  GetCourseChapterErrorState(this.error);
}

class GetCourseChapterSuccessState extends CoursesSectionState {}

class ToggleChapterVisibilityState extends CoursesSectionState {}

class GetLessonProfileLoadingState extends CoursesSectionState {}

class GetLessonProfileErrorState extends CoursesSectionState {
  final String error;

  GetLessonProfileErrorState(this.error);
}

class GetLessonProfileSuccessState extends CoursesSectionState {}

class CourseAttachmentLoadingState extends CoursesSectionState {}

class CourseAttachmentErrorState extends CoursesSectionState {
  final String error;

  CourseAttachmentErrorState(this.error);
}

class CourseAttachmentSuccessState extends CoursesSectionState {}

class ChangeIndexState extends CoursesSectionState {}

class ChangecourseIndexState extends CoursesSectionState {}
