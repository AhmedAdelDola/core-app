part of 'login_imports.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPhoneChecked = false;

  num? shortestSide;
  bool isTablet = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    shortestSide = MediaQuery.of(context).size.shortestSide;
    isTablet = AppResponsive.isTabletOrLarger(context);
    return BlocProvider(
      create: (context) => di<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          final cubit = LoginCubit.of(context);
          if (state is SuccessLoginState) {
            NamedNavigatorImpl.push(
              const HomeLayout(),
              clean: true,
            );
          } else if (state is PhoneNotFoundState) {
            NamedNavigatorImpl.push(
              RegisterScreen(phone: state.fullPhone),
            );
          } else if (state is StudentExistsState) {
            setState(() {
              isPhoneChecked = true;
            });
            if (cubit.currentAuthMode == LoginAuthMode.otp) {
              cubit.requestOtp(phone: phoneController.text.trim());
            }
          } else if (state is RequestOtpSuccessState) {
            showSuccessToast('تم إرسال كود التحقق بنجاح');
          } else if (state is LoginErrorState) {
            showErrorToast(state.message);
          } else if (state is RequestOtpErrorState) {
            showErrorToast(state.message);
          }
        },
        builder: (context, state) {
          final cubit = LoginCubit.of(context);
          final bothEnabled = cubit.isPasswordEnabled && cubit.isOtpEnabled;

          return Scaffold(
            backgroundColor: AppColors.kPrimary,
            body: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet
                      ? ResponsiveBreakpoints.maxFormWidth
                      : double.infinity,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: isTablet ? 20.h : 36.h),
                    // Responsive logo
                    loginLogo,
                    16.sbH,
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.kWhite,
                          borderRadius: isTablet
                              ? BorderRadius.circular(24.r)
                              : BorderRadius.vertical(
                                  top: Radius.circular(24.r),
                                ),
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 24.h,
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                12.sbH,
                                // Responsive header
                                AppText(
                                  isPhoneChecked && cubit.currentAuthMode == LoginAuthMode.otp
                                      ? 'رمز التحقق'
                                      : 'تسجيل الدخول',
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.kPrimary,
                                  ),
                                  align: TextAlign.start,
                                ),
                              if (kDebugMode) ...[
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      Clipboard.setData(const ClipboardData(
                                          text: '1097107762'));
                                      phoneController.text = '1097107762';
                                    },
                                    child: const AppText(
                                      'click to copy \n test phone => 1097107762\nOTP => 2030',
                                      align: TextAlign.end,
                                      maxLines: 3,
                                    ),
                                  ),
                                ),
                              ],
                              32.sbH,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Center(
                                      child: MasterTextField(
                                        controller: phoneController,
                                        readOnly: isPhoneChecked,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(),
                                        validate: AppValidators.number,
                                        textDirection: TextDirection.ltr,
                                        textAlign: TextAlign.left,
                                        hintText: 'رقم الهاتف',
                                        inputFormatters: [
                                          TextInputFormatter.withFunction(
                                            (oldValue, newValue) {
                                              if (context
                                                      .read<LoginCubit>()
                                                      .numberCode ==
                                                  '+20') {
                                                if (newValue.text
                                                    .startsWith('0')) {
                                                  return oldValue;
                                                }
                                              }
                                              if (context
                                                      .read<LoginCubit>()
                                                      .numberCode ==
                                                  '+966') {
                                                if (newValue.text
                                                    .startsWith('9')) {
                                                  return oldValue;
                                                }
                                              }
                                              return newValue;
                                            },
                                          ),
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(11),
                                        ],
                                        suffixWidget: Container(
                                          padding: EdgeInsets.only(
                                              left: 8.w, right: 10.w),
                                          child: Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SvgPicture.asset(
                                                  AppImages.phone,
                                                  width: 18.w,
                                                  height: 18.h,
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                          AppColors.textColor,
                                                          BlendMode.srcIn),
                                                ),
                                                6.sbW,
                                                AppText(
                                                  cubit.numberCode ?? '',
                                                  style:
                                                      TextStyles.textViewRegular(
                                                              fontSize: 16.sp)
                                                          .copyWith(
                                                              color: AppColors
                                                                  .textColor2),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        prefixWidget: isPhoneChecked
                                            ? IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  size: 18,
                                                  color: AppColors.textColor2,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    isPhoneChecked = false;
                                                    passwordController.clear();
                                                    otpController.clear();
                                                  });
                                                },
                                              )
                                            : null,
                                      ),
                                    ),
                                  ),
                                  10.sbW,
                                  showCountryDropDown(cubit, setState),
                                ],
                              ),
                              20.sbH,
                              AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: Column(
                                  children: [
                                    if (isPhoneChecked) ...[
                                      if (cubit.currentAuthMode == LoginAuthMode.password) ...[
                                        MasterTextField(
                                          controller: passwordController,
                                          isPassword: true,
                                          hintText: 'كلمة المرور',
                                          validate: Validator.password,
                                        ),
                                        16.sbH,
                                      ] else if (cubit.currentAuthMode == LoginAuthMode.otp) ...[
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                                          child: Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: PinCodeTextField(
                                              appContext: context,
                                              length: 4,
                                              controller: otpController,
                                              autoDisposeControllers: false,
                                              keyboardType: TextInputType.number,
                                              animationType: AnimationType.fade,
                                              pinTheme: PinTheme(
                                                shape: PinCodeFieldShape.box,
                                                borderRadius: BorderRadius.circular(12.r),
                                                fieldHeight: 52.h,
                                                fieldWidth: 52.w,
                                                activeFillColor: Colors.white,
                                                inactiveFillColor: Colors.white,
                                                selectedFillColor: Colors.white,
                                                activeColor: AppColors.kPrimary,
                                                inactiveColor: AppColors.borderColor,
                                                selectedColor: AppColors.kPrimary,
                                              ),
                                              enableActiveFill: true,
                                              cursorColor: AppColors.kPrimary,
                                              textStyle: TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textColor,
                                              ),
                                              onChanged: (value) {
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                        12.sbH,
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (state is RequestOtpLoadingState)
                                              const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                              )
                                            else if (cubit.secondsRemaining > 0)
                                              AppText(
                                                'إعادة إرسال الرمز خلال (${cubit.secondsRemaining} ثانية)',
                                                style: TextStyles.textViewRegular(fontSize: 14.sp)
                                                    .copyWith(color: AppColors.textColor2),
                                              )
                                            else
                                              InkWell(
                                                onTap: () {
                                                  cubit.requestOtp(phone: phoneController.text.trim());
                                                },
                                                child: AppText(
                                                  'إعادة إرسال رمز التحقق',
                                                  style: TextStyles.textViewMedium(fontSize: 14.sp)
                                                      .copyWith(
                                                    color: AppColors.kPrimary,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        16.sbH,
                                      ],
                                    ],
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: isTablet ? 10.sp : 16.sp),
                                      child: ConditionalBtn(
                                        condition: state is LoginLoadingState || state is RequestOtpLoadingState,
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          if (formKey.currentState!.validate()) {
                                            if (!isPhoneChecked) {
                                              cubit.checkPhone(phone: phoneController.text.trim());
                                            } else {
                                              if (cubit.currentAuthMode == LoginAuthMode.password) {
                                                cubit.login(
                                                  phone: phoneController.text.trim(),
                                                  password: passwordController.text.trim(),
                                                );
                                              } else {
                                                if (otpController.text.trim().isEmpty) {
                                                  showErrorToast('يرجى إدخال رمز التحقق');
                                                  return;
                                                }
                                                cubit.login(
                                                  phone: phoneController.text.trim(),
                                                  otp: otpController.text.trim(),
                                                );
                                              }
                                            }
                                          }
                                        },
                                        text: !isPhoneChecked
                                            ? 'التالي'
                                            : (cubit.currentAuthMode == LoginAuthMode.password
                                                ? 'تسجيل الدخول'
                                                : 'تأكيد الدخول'),
                                      ),
                                    ),
                                    if (isPhoneChecked && bothEnabled) ...[
                                      10.sbH,
                                      InkWell(
                                        onTap: () {
                                          if (cubit.currentAuthMode == LoginAuthMode.password) {
                                            cubit.switchAuthMode(LoginAuthMode.otp);
                                            cubit.requestOtp(phone: phoneController.text.trim());
                                          } else {
                                            cubit.switchAuthMode(LoginAuthMode.password);
                                          }
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8.h),
                                          child: AppText(
                                            cubit.currentAuthMode == LoginAuthMode.password
                                                ? 'تسجيل الدخول عبر رمز التحقق (OTP) 💬'
                                                : 'تسجيل الدخول بكلمة المرور 🔑',
                                            style: TextStyles.textViewMedium(fontSize: 14.sp).copyWith(
                                              color: AppColors.kPrimary,
                                              decoration: TextDecoration.underline,
                                            ),
                                            align: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              12.sbH,
                              InkWell(
                                onTap: () {
                                  if (Navigator.of(context).canPop()) {
                                    NamedNavigatorImpl.pop();
                                  } else {
                                    NamedNavigatorImpl.pushNamed(Routes.guestHome, clean: true);
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AppText(
                                        'الدخول كزائر',
                                        style: TextStyles.textViewMedium(fontSize: 15.sp).copyWith(
                                          color: AppColors.textColor2,
                                          decoration: TextDecoration.underline,
                                        ),
                                        align: TextAlign.center,
                                      ),
                                      6.sbW,
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 13.sp,
                                        color: AppColors.textColor2,
                                      ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (isTablet) 24.sbH,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    otpController.dispose();
    super.dispose();
  }
}
