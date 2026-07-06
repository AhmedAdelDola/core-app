part of '../../profile_imports.dart';

class GetProfileCubit extends Cubit<GetProfileState> {
  Repository repo;
  GetProfileCubit(this.repo) : super(GetProfileInitial());

  static GetProfileCubit of(context) => BlocProvider.of(context);

  Future<void> getProfile() async {
    emit(GetProfileLoading());
    final f = await repo.getProfile();
    f.fold(
      (l) {
        showErrorToast(l.toString());
        emit(GetProfileError(l.toString()));
      },
      (r) {
        UserPreferencesHelper().updateUserPreference(userData: r);
        emit(GetProfileSuccess());
      },
    );
  }

  void logout() async {
    // emit(LogoutLoading());
    // final f = await repo.logout();
    // f.fold(
    //   (l) => emit(LogoutError(l.toString())),
    //   (r) => emit(LogoutSuccess(r.toString())),
    // );
  }

  void delete() async {
    // emit(DeleteLoading());
    // final f = await repo.delete();
    // f.fold(
    //   (l) => emit(DeleteError(l.toString())),
    //   (r) => emit(DeleteSuccess(r.toString())),
    // );
  }
}
