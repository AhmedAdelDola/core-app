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
            showSuccessToast('تم إرسال رمز التحقق بنجاح');
          } else if (state is RequestOtpErrorState) {
            showErrorToast(state.message);
          } else if (state is LoginErrorState) {
            if (state.message.contains('Phone number not found') ||
                state.message.contains('not found') ||
                state.message.contains('404')) {
              NamedNavigatorImpl.push(
                RegisterScreen(
                  phone: "${cubit.numberCode}${phoneController.text.trim()}",
                ),
              );
            } else if (state.message.contains('required')) {
              if (!isPhoneChecked) {
                setState(() {
                  isPhoneChecked = true;
                });
                if (cubit.currentAuthMode == LoginAuthMode.otp) {
                  cubit.requestOtp(phone: phoneController.text.trim());
                }
              }
            } else {
              showErrorToast(state.message);
            }
          }
        },
        builder: (context, state) {
          final cubit = LoginCubit.of(context);
          final bool bothEnabled = cubit.isPasswordEnabled && cubit.isOtpEnabled;

          return AuthBg(
            child: Scaffold(
              backgroundColor: AppColors.kPrimary,
              body: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    // Responsive logo
                    loginLogo,

                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              24.sbH,
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
                                align: TextAlign.center,
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
                                  showCountryDropDown(cubit, setState),
                                  10.sbW,
                                  Expanded(
                                    flex: 7,
                                    child: Center(
                                      child: MasterTextField(
                                        controller: phoneController,
                                        readOnly: isPhoneChecked,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(),
                                        validate: AppValidators.number,
                                        textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.right,
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
                                        prefixWidget: Container(
                                          width: 90.w,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Row(
                                            children: [
                                              AppText(
                                                cubit.numberCode ?? '',
                                                style:
                                                    TextStyles.textViewRegular(
                                                            fontSize: 16.sp)
                                                        .copyWith(
                                                            color: AppColors
                                                                .textColor2),
                                              ),
                                              SvgPicture.asset(
                                                AppImages.phone,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                        AppColors.textColor,
                                                        BlendMode.srcIn),
                                              ),
                                            ],
                                          ),
                                        ),
                                        suffixWidget: isPhoneChecked
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
