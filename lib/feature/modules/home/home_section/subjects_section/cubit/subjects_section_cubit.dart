// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

// import '../../../../../../core/network/repository/repository_imports.dart';
// import '../../../../../../models/home_entities/subject/subject_courses_model.dart';

// part 'subjects_section_state.dart';

// class SubjectsSectionCubit extends Cubit<SubjectsSectionState> {
//   final Repository repo;
//   SubjectsSectionCubit(this.repo) : super(SubjectsSectionInitial());
//   static SubjectsSectionCubit of(context) => BlocProvider.of(context);
//   final RefreshController refreshController = RefreshController(initialRefresh: false);

//   SubjectCoursesResponse? subjectCoursesModel;
//   Future<void> getSubjectCourses(String id) async {
//     emit(GetSubjectCoursesLoadingState());
//     final f = await repo.getSubjectCourses(id);
//     f.fold(
//       (l) => emit(GetSubjectCoursesErrorState(l.toString())),
//       (r) {
//         subjectCoursesModel = r;
//         emit(GetSubjectCoursesSuccessState());
//       },
//     );
//   }
// }
