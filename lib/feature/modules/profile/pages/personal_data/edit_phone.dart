part of '../../profile_imports.dart';

class EditPhoneScreen extends StatefulWidget {
  const EditPhoneScreen({super.key});

  @override
  State<EditPhoneScreen> createState() => _EditPhoneScreenState();
}

class _EditPhoneScreenState extends State<EditPhoneScreen> {
  TextEditingController phoneController = TextEditingController();
  final phoneFormKey = GlobalKey<FormState>();
  String countryCode = 'EG';
  String numberCode = '';
  @override
  void initState() {
    super.initState();
    // final cubit = di<UpdateProfileCubit>();
    // var user = di<SubmitOtpCubit>().user.student;
    // phoneController.text = user.mobile;
    // numberCode = user.mobileCode;
    // countryCode = user.mobileCountryLabel;
  }

  @override
  Widget build(BuildContext context) {
    // final cubit = di<UpdateProfileCubit>();
    return AuthBg(
      child: Scaffold(
        backgroundColor: AppColors.kPrimary.withOpacity(0.1),
        body: Form(
          key: phoneFormKey,
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  loginLogo,
                  SafeArea(
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.textColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        32.sbH,
                        AppText(
                          'تعديل رقم الهاتف',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: w700,
                            color: AppColors.textColor3,
                          ),
                        ),
                        12.sbH,
                        AppText(
                          'ادخل رقم موبايلك ادناه للمتابعة',
                          style: TextStyles.textViewMedium(fontSize: 16.sp)
                              .copyWith(color: AppColors.textColor2),
                        ),
                        48.sbH,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: SizedBox(
                                width: 80.w,
                                height: 56.h,
                                child: GestureDetector(
                                  onTap: () {
                                    showCountryPicker(
                                      context: context,
                                      countryListTheme: countryListTheme,
                                      onSelect: (Country country) {
                                        countryCode = country.countryCode;
                                        numberCode = '${country.phoneCode}' '+ ';
                                        setState(() {});
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 65.w,
                                    height: 35.h,
                                    margin: EdgeInsets.only(right: 8.w),
                                    padding: EdgeInsets.symmetric(vertical: 4.h),
                                    decoration: boxDecoration,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        const Icon(
                                          Icons.keyboard_arrow_down_sharp,
                                          color: AppColors.textColor,
                                        ),
                                        AppText(
                                          Utils.countryCodeToEmoji(countryCode),
                                          style: TextStyles.textViewRegular(fontSize: 24.sp)
                                              .copyWith(color: AppColors.textColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            10.sbW,
                            Expanded(
                              flex: 7,
                              child: Center(
                                child: MasterTextField(
                                  controller: phoneController,
                                  keyboardType: const TextInputType.numberWithOptions(
                                    decimal: false,
                                    signed: false,
                                  ),
                                  validate: Validator.phone,
                                  hintText: 'رقم الهاتف',
                                  prefixWidget: textFieldWidget(numberCode),
                                  onChanged: (String value) {
                                    if (value.startsWith('0')) {
                                      phoneController.text = value.substring(1);
                                      phoneController.selection = TextSelection.fromPosition(
                                        TextPosition(
                                          offset: phoneController.text.length,
                                        ),
                                      );
                                    }
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        18.sbH,
                        shouldHaveWhats,
                        10.sbH,
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.sp),
                          // child: BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
                          //   builder: (context, state) {
                          //     if (state is UpdatePhoneLoadingState) {
                          //       return const Loading();
                          //     }
                          child: MasterButton(
                            onPressed: phoneController.text.isEmpty
                                ? null
                                : () {
                                    // fUpdatePhone();
                                  },
                            verticalPadding: 6,
                            text: 'دخول',
                            textStyle: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: w700,
                            ),
                          ),
                          // },
                          // ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle get textStyle => const TextStyle(color: Colors.white);
}
