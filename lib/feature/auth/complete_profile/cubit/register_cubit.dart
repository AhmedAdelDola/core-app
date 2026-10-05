import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:elhanbly/feature/auth/common/country_picker_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/local/cache_helper.dart';
import '../../../../core/local/enum_init.dart';
import '../../../../core/network/repository/repository_imports.dart';
import '../../../../core/security/content_protection_service.dart';
import '../../../../core/services/di.dart';
import '../../../../models/general/register_stage_model.dart';
import '../../../../models/user_response/login_response.dart';

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
    String? email,
    String? password,
  }) async {
    if (selectedLevel == null) {
      emit(RegisterErrorState('الرجاء اختيار الصف الدراسي'));
      return;
    }

    emit(RegisterSubmittingState());
    final Either<dynamic, LoginResponse> result = await repository.registerStudent(
      name: name,
      phone: phone,
      email: email,
      password: password,
      levelId: selectedLevel!.id,
    );

    result.fold(
      (error) => emit(RegisterErrorState(error.toString())),
      (response) {
        if (response.token != null && response.token!.isNotEmpty) {
          try {
            di<CacheHelper>().put(CachingKey.isLogged, true);
            di<CacheHelper>().put(CachingKey.userData, response.toJson());
            _prefetchSecurityConfig();
          } catch (_) {}
          emit(RegisterSuccessWithTokenState(response));
        } else {
          emit(RegisterSuccessState());
        }
      },
    );
  }

  Future<void> _prefetchSecurityConfig() async {
    try {
      if (di.isRegistered<ContentProtectionService>()) {
        final cfg = await di<ContentProtectionService>().getSecurityConfig();
        if (cfg.isEnforced || cfg.isMonitor) {
          await di<ContentProtectionService>().enrollDevice();
        }
      }
    } catch (_) {}
  }
}
