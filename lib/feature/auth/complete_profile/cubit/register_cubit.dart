import 'package:dartz/dartz.dart';
import 'package:elhanbly/feature/auth/common/country_picker_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/repository/repository_imports.dart';
import '../../../../models/general/register_stage_model.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final Repository repository;

  RegisterCubit(this.repository) : super(RegisterInitialState());

  static RegisterCubit of(BuildContext context) => BlocProvider.of<RegisterCubit>(context);

  List<RegisterStage> stages = [];
  RegisterStage? selectedStage;
  RegisterLevel? selectedLevel;



  bool get isSingleStage => stages.length == 1;
  bool get hasStage => stages.isNotEmpty;
  List<RegisterLevel> get currentLevels => selectedStage?.levels ?? [];

  Future<void> fetchStages() async {
    emit(RegisterStagesLoadingState());
    final Either<dynamic, List<RegisterStage>> result = await repository.fetchRegistrationStages();

    result.fold(
      (error) => emit(RegisterStagesErrorState(error.toString())),
      (data) {
        stages = data;
        if (stages.isEmpty) {
          emit(RegisterStagesErrorState('لا توجد مراحل متاحة حالياً'));
          return;
        }

        if (stages.length == 1) {
          selectedStage = stages.first;
        } else {
          selectedStage = null;
        }
        selectedLevel = null;
        emit(RegisterStagesLoadedState());
      },
    );
  }

  void selectStage(int id) {
    final matches = stages.where((stage) => stage.id == id);
    if (matches.isEmpty) return;
    selectedStage = matches.first;
    selectedLevel = null;
    emit(RegisterStagesLoadedState());
  }

  void selectLevel(int id) {
    final matches = currentLevels.where((level) => level.id == id);
    if (matches.isEmpty) return;
    selectedLevel = matches.first;
    emit(RegisterStagesLoadedState());
  }

  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    if (selectedLevel == null) {
      emit(RegisterErrorState('الرجاء اختيار الصف الدراسي'));
      return;
    }

    emit(RegisterSubmittingState());
    final Either<dynamic, bool> result = await repository.registerStudent(
      name: name,
      phone: phone,
      email: email,
      password: password,
      levelId: selectedLevel!.id,
    );

    result.fold(
      (error) => emit(RegisterErrorState(error.toString())),
      (_) => emit(RegisterSuccessState()),
    );
  }
  
  
}
