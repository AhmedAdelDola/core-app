// part of '../../profile_imports.dart';

// class GetFavCoursesCubit extends Cubit<GetFavCoursesState> {
//   final Repository repo;
//   GetFavCoursesCubit(this.repo) : super(GetFavCoursesInitial());

//   Future<void> getFavCourses() async {
//     emit(GetFavCoursesLoading());
//     final f = await repo.getFavouriteCourses();
//     f.fold(
//       (l) => emit(GetFavCoursesError(l.toString())),
//       (r) => emit(GetFavCoursesSuccess(r)),
//     );
//   }
// }
