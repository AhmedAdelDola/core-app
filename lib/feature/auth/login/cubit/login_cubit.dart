import 'package:elhanbly/feature/auth/common/country_picker_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/repository/repository_imports.dart';
import '../../../../models/user_response/login_response.dart';
import '../../../../core/services/di.dart';
import '../../../../core/local/cache_helper.dart';
import '../../../../core/local/enum_init.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> implements CountryPickerCubit {
  Repository repo;
  LoginCubit(this.repo) : super(InitialLoginState());
  static LoginCubit of(context) => BlocProvider.of(context);

  @override
  String? countryCode = 'EG';
  @override
  String? numberCode = '+20';

  /// ================== User Data ==================
  /// 
  void setCountryCode(String code) {
    countryCode = code;
    emit(ChangeCountryCodeState());
  }

  void setNumberCode(String code) {
    numberCode = code;
    emit(ChangeNumberCodeState());
  }
LoginResponse? loginResponse; 
  Future<void> login({
    required String phone,
    String? password,
    String? otp,
  }) async {
    emit(LoginLoadingState());
    
    final f = await repo.login(
      phone: numberCode! + phone,
      password: password,
      otp: otp,
    );
    f.fold(
      (l) => emit(LoginErrorState(l.toString())),
      (r) {
        loginResponse = r;
        // persist login state and user data so app recognizes authenticated user
        try {
          di<CacheHelper>().put(CachingKey.isLogged, true);
          di<CacheHelper>().put(CachingKey.userData, r.toJson());
        } catch (_) {}
        emit(SuccessLoginState(r));
      },
    );
  }
}
