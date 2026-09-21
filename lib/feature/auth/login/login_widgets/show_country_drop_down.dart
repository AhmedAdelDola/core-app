part of '../login_imports.dart';

Widget showCountryDropDown(
    CountryPickerCubit cubit, void Function(void Function() fn) setState) {
  return Center(
    child: SizedBox(
      width: 80.w,
      height: 56.h,
      child: GestureDetector(
        onTap: () {
          showCountryPicker(
            context: NamedNavigatorImpl.navigatorState.currentContext!,
            countryListTheme: countryListTheme,
            showPhoneCode: true,
            onSelect: (Country country) {
              setState(() {
                cubit.setCountryCode(country.countryCode);
                cubit.setNumberCode('+${country.phoneCode}');
              });
            },
          );
        },
        child: Container(
          width: 65.w,
          height: 35.h,
          margin: EdgeInsets.only(right: 8.w),
          padding: EdgeInsets.symmetric(vertical: 4.h),
          decoration: boxDecoration,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.keyboard_arrow_down_sharp, size: 18.sp),
                AppText(
                  Utils.countryCodeToEmoji(cubit.countryCode ?? ''),
                  style: TextStyles.textViewRegular(fontSize: 20.sp)
                      .copyWith(color: AppColors.textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
