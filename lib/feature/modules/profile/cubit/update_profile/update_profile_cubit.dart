part of '../../profile_imports.dart';



class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  Repository repo;
  UpdateProfileCubit(this.repo) : super(UpdateProfileInitial());
  static UpdateProfileCubit of(context) => BlocProvider.of(context);

  Future<void> updateProfile(UpdateProfileParams params, {File? image}) async {
    emit(UpdateProfileLoading());

    final data = params.toMap();
    if (image != null) {
      data['image'] = await MultipartFile.fromFile(
        image.path,
        filename: image.uri.pathSegments.last,
      );
    }

    final FormData formData = FormData.fromMap(data);
    final res = await repo.updateProfile(formData);
    res.fold(
      (l) => emit(UpdateProfileError(message: l.toString())),
      (r) => emit(UpdateProfileSuccess(r.message.toString())),
    );
  }

  /// Edit Phone Number
  // TextEditingController phoneController = TextEditingController();
  // final phoneFormKey = GlobalKey<FormState>();
  // String countryCode = 'EG';
  // String numberCode = '';

  // Future<void> fUpdatePhone() async {
  //   if (!personalDataFormKey.currentState!.validate()) {
  //     return;
  //   } else {
  //     emit(UpdateProfileLoading());
  //     final Either<Failure, GeneralResponse> res = await repo.updatePhone(
  //       UpdateProfileParams(
  //           // firstName: firstName.text,
  //           // lastName: lastName.text,
  //           // gender: genderType,
  //           ),
  //     );
  //     res.fold((Failure fail) {
  //       if (fail is ServerFailure) {
  //         emit(UpdateProfileError(message: fail.message));
  //         showErrorToast(fail.message);
  //       }
  //     }, (GeneralResponse res) {
  //       showSuccessToast(res.message);
  //       emit(UpdateProfileSuccess());
  //     });
  //   }
  // }
}

class UpdateProfileParams {
  final String? name;
  final String? email;
  final String? gender;

  UpdateProfileParams({this.name, this.email, this.gender});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      if (gender != null && gender!.isNotEmpty) 'gender': gender,
    }..removeWhere((key, value) => value == null || value == '');
  }
}
