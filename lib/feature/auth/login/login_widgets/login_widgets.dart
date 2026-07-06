part of '../login_imports.dart';

Widget get shouldHaveWhats {
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Row(
      children: [
         Icon(Icons.info, color: AppColors.kPrimary),
        8.sbW,
        AppText(
          'يحب ان يحتوي علي واتساب',
          style: TextStyles.textViewRegular(fontSize: 16.sp).copyWith(color: AppColors.textColor),
        ),
      ],
    ),
  );
}

Container textFieldWidget(String numberCode) {
  return Container(
    width: 90.w,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Row(
      children: [
        AppText(
          numberCode,
          style: TextStyles.textViewRegular(fontSize: 16.sp).copyWith(color: AppColors.textColor2),
        ),
        SvgPicture.asset(
          AppImages.phone,
          colorFilter: const ColorFilter.mode(AppColors.textColor, BlendMode.srcIn),
        ),
      ],
    ),
  );
}

BoxDecoration get boxDecoration {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(8.r),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 1,
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
    ],
    color: AppColors.kWhite,
  );
}

CountryListThemeData get countryListTheme {
  return CountryListThemeData(
    flagSize: 25,
    backgroundColor: Colors.white,
    textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
    bottomSheetHeight: 500,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(20.0),
      topRight: Radius.circular(20.0),
    ),
    searchTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
    inputDecoration: InputDecoration(
      labelText: 'بحث',
      hintText: 'بحث',
      prefixIcon: const Icon(Icons.search),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: const Color(0xFF8C98A8).withOpacity(0.2)),
      ),
    ),
  );
}

Widget get headerText {
  return Column(
    children: [
      AppText(
        'سجل دخولك او انشئ حساب جديد',
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: w700,
          color: AppColors.textColor3,
        ),
      ),
      12.sbH,
      AppText(
        'ادخل رقم الهاتف ادناه للمتابعه',
        style: TextStyles.textViewMedium(fontSize: 16.sp).copyWith(color: AppColors.textColor2),
      ),
    ],
  );
}
