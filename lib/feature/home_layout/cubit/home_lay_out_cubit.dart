import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/local/user_preferences/user_preferences_helper.dart';
import '../../../core/network/repository/repository_imports.dart';
import '../../../models/user_response/user_data.dart';
import '../../modules/home/home_screen.dart';
import '../../modules/library/library_imports.dart';
import '../../modules/notification_center/notifications_screen.dart';
import '../../modules/profile/profile_imports.dart';
import '../../modules/quizes/quizes_screen.dart';

part 'home_lay_out_state.dart';

class BottomBarCubit extends Cubit<BottomBarState> {
  BottomBarCubit(Repository repository) : super(InitialBottomBarState());

  static BottomBarCubit of(context) => BlocProvider.of(context);

  List<Widget> screensList = [
    const HomeScreen(),
    // const QuizesScreen(),
    const LibraryScreen(),
    // const NotificationsScreen(),
    const ProfileScreen(),
  ];
  int currentIndex = 0;
  Widget currentWidget = const HomeScreen();

  void getLocalData() {
    emit(LoadingGetHomeDataState());
    UserPreferencesHelper().getUserPreference();
    emit(SuccessGetHomeDataState());
  }

  void updatePageIndex(int v) {
    currentIndex = v;
    currentWidget = screensList[currentIndex];
    emit(UpdatePageIndexState());
  }
}
