import 'package:elhanbly/models/home_entities/home/get_home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../../core/network/repository/repository_imports.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeStates> {
  final Repository repo;
  HomeCubit(this.repo) : super(HomeInitial());

  static HomeCubit of(context) => BlocProvider.of(context);

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  Future<void> getData() async {
    getHome();
  }

  /// getHome
  HomeResponse? home;
  Future<void> getHome() async {
    emit(GetHomeLoadingState());
    final f = await repo.getHome();
    f.fold(
      (l) => emit(GetHomeErrorState(l.toString())),
      (r) {
        home = r;
        emit(GetHomeSuccessState());
      },
    );
  }

  /// getFiles
  
  /// getNewCourses
  

  /// Scan Qr
  
  @override
  Future<void> close() {
    refreshController.dispose();
    return super.close();
  }
}
