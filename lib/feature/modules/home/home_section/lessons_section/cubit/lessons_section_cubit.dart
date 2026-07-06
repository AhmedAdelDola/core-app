import 'package:elhanbly/models/Session/get_session_info_response.dart';
import 'package:elhanbly/models/Session/show_video_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/network/repository/repository_imports.dart';
import '../../../../../../models/home_entities/lessons/get_lesson_response.dart';

part 'lessons_section_state.dart';

class LessonsSectionCubit extends Cubit<LessonsSectionState> {
  final Repository repo;
  LessonsSectionCubit(this.repo) : super(LessonsSectionInitial());
  static LessonsSectionCubit of(context) => BlocProvider.of(context);

  // GetRecommendedLessonData? getLessonModel;
  // Future<void> getLessonData(int id) async {
  //   emit(GetSubjectCoursesLoadingState());
  //   final f = await repo.getRecommendedLessonsById(id);
  //   f.fold(
  //     (l) => emit(GetSubjectCoursesErrorState(l.toString())),
  //     (r) {
  //       getLessonModel = r.data;
  //       emit(GetSubjectCoursesSuccessState());
  //     },
  //   );
  // }

  // StudentPdfProfileResponse? pdfProfileModel;
  // Future<void> trackStudentPdfProfile(String id) async {
  //   emit(GetSubjectCoursesLoadingState());
  //   final f = await repo.trackStudentPdfProfile(id);
  //   f.fold(
  //     (l) => emit(GetSubjectCoursesErrorState(l.toString())),
  //     (r) {
  //       pdfProfileModel = r;
  //       emit(GetSubjectCoursesSuccessState());
  //     },
  //   );
  // }

  // GetSheetInfoResponse? getSheetInfoModel;
  // Future<void> getSheetInfo(String id) async {
  //   emit(GetSubjectCoursesLoadingState());
  //   final f = await repo.getSheetInfo(id);
  //   f.fold(
  //     (l) => emit(GetSubjectCoursesErrorState(l.toString())),
  //     (r) {
  //       getSheetInfoModel = r;
  //       emit(GetSubjectCoursesSuccessState());
  //     },
  //   );
  // }

  // GetAttachmentFileResponse? getAttachmentModel;
  // Future<void> getAttachmentFile(String id) async {
  //   emit(GetSubjectCoursesLoadingState());
  //   final f = await repo.getAttachmentFile(id);
  //   f.fold(
  //     (l) => emit(GetSubjectCoursesErrorState(l.toString())),
  //     (r) {
  //       getAttachmentModel = r;
  //       emit(GetSubjectCoursesSuccessState());
  //     },
  //   );
  // }

  GetSessionInfoResponse? getSessionModel;
  Future<void> getSessionInfo(String id) async {
    emit(GetSubjectCoursesLoadingState());
    final f = await repo.getSessionInfo(id);
    f.fold(
      (l) => emit(GetSubjectCoursesErrorState(l.toString())),
      (r) {
        getSessionModel = r;
        emit(GetSubjectCoursesSuccessState());
      },
    );
  }

  ShowVideo? ShowVideoModel;
  Future<void> getvideo(String id) async {
    emit(GetSubjectCoursesLoadingState());
    final f = await repo.getvideo(id);
    f.fold(
      (l) => emit(GetSubjectCoursesErrorState(l.toString())),
      (r) {
        ShowVideoModel = r;
        emit(GetSubjectCoursesSuccessState());
      },
    );
  }

  bool SplitAxis = true;
  void changeAxis(bool value) {
    SplitAxis = value;
    // emit(ChangeSuccessState());
  }

  var currentAxis = Axis.horizontal;
  void setAxis(Axis axis) {
    currentAxis = axis;
    emit(ChangeSuccessState(axis: currentAxis));
  }
}
