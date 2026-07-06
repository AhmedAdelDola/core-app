import 'package:carousel_slider/carousel_slider.dart';
import 'package:elhanbly/models/home_entities/courses/get_course_data_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/network/repository/repository_imports.dart';
import '../../../../../../models/home_entities/files/course_attachment.dart';
import '../../../../../../models/home_entities/files/get_recommended_files_response.dart';

part 'courses_section_state.dart';

class CoursesSectionCubit extends Cubit<CoursesSectionState> {
  final Repository repo;
  CoursesSectionCubit(this.repo) : super(CoursesSectionInitial());

  static CoursesSectionCubit of(context) => BlocProvider.of(context);

  void _safeEmit(CoursesSectionState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  int sliderIndex = 0;
  int courseIndex = 0;

  final CarouselSliderController controller = CarouselSliderController();

  void changeIndex(int i, CarouselPageChangedReason r) {
    sliderIndex = i;
    _safeEmit(ChangeIndexState());
  }

  void changecourseIndex(int i) {
    courseIndex = i;
    _safeEmit(ChangecourseIndexState());
  }

  Future<void> getAllCourseData(String id) async {
    getCourseData(id);
    
  }

  GetCourseDataResponse? courseData;
  Future<void> getCourseData(String id) async {
    _safeEmit(GetCourseDataLoadingState());
    final f = await repo.getCourseData(id);
    f.fold(
      (l) => _safeEmit(GetCourseDataErrorState(l.toString())),
      (r) {
        courseData = r;
        _safeEmit(GetCourseDataSuccessState());
      },
    );
  }

  // GetCourseRateReviewResponse? courseRateReview;
  // Future<void> getCourseRateReview(int id) async {
  //   emit(GetCourseRateReviewLoadingState());
  //   final f = await repo.getCourseRateReview(id);
  //   f.fold(
  //     (l) => emit(GetCourseRateReviewErrorState(l.toString())),
  //     (r) {
  //       courseRateReview = r;
  //       emit(GetCourseRateReviewSuccessState());
  //     },
  //   );
  // }

  // GetCourseChapterResponse? courseChapterResponse;
  // Future<void> getCourseChapter(String id) async {
  //   emit(GetCourseChapterLoadingState());
  //   final f = await repo.getCourseChapter(id);
  //   f.fold(
  //     (l) => emit(GetCourseChapterErrorState(l.toString())),
  //     (r) {
  //       courseChapterResponse = r;
  //       emit(GetCourseChapterSuccessState());
  //     },
  //   );
  // }

  bool isExpanded = false;
  void toggleExpand() {
    isExpanded = !isExpanded;
    _safeEmit(ToggleChapterVisibilityState());
  }

  // GetLessonProfileResponse? lessonProfileResponse;
  // void getLessonProfile(int id) async {
  //   emit(GetLessonProfileLoadingState());
  //   final f = await repo.getLessonProfile(id);
  //   f.fold(
  //     (l) => emit(GetLessonProfileErrorState(l.toString())),
  //     (r) {
  //       lessonProfileResponse = r;
  //       emit(GetLessonProfileSuccessState());
  //     },
  //   );
  // }

  // CourseAttachmentResponse? attachmentResponse;
  // void LibraryCourseattachment(int id) async {
  //   print(id);
  //   emit(CourseAttachmentLoadingState());
  //   final f = await repo.LibraryCourseattachment(id);
  //   f.fold(
  //     (l) => emit(CourseAttachmentErrorState(l.toString())),
  //     (r) {
  //       attachmentResponse = r;
  //       emit(CourseAttachmentSuccessState());
  //     },
  //   );
  // }
}
