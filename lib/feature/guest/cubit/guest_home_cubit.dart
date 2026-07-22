import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository/repository_imports.dart';
import '../../../core/services/di.dart';
import '../../../models/guest/guest_courses_response.dart';

part 'guest_home_state.dart';

class GuestHomeCubit extends Cubit<GuestHomeState> {
  GuestHomeCubit() : super(GuestHomeInitial());

  static GuestHomeCubit get(context) => BlocProvider.of(context);

  void getCourses() async {
    emit(GuestHomeLoading());
    final result = await di<Repository>().getGuestCourses();
    
    result.fold(
      (l) => emit(GuestHomeError(l.toString())),
      (r) => emit(GuestHomeLoaded(r)),
    );
  }
}
