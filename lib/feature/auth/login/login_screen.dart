part of 'login_imports.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool showPasswordField = false;

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
          if(state is SuccessLoginState) {
            NamedNavigatorImpl.push(
              const HomeLayout(),
              clean: true,
            );
          }
          if (state is LoginErrorState) {
            if (state.message.contains('Phone number not found')) {
              NamedNavigatorImpl.push(
                RegisterScreen(
                  phone:"${ context.read<LoginCubit>().numberCode }${ phoneController.text.trim()}"
                ),
              );
            } else if (state.message.contains('required')) {
              
              if (!showPasswordField) {
                                              setState(() {
                                                showPasswordField = true;
                                              });
                                              return;
                                            }

            }else {
              showErrorToast(state.message);
            }
            
          }
        },
        builder: (context, state) {
          final cubit = LoginCubit.of(context);
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
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              24.sbH,
                              // Responsive header
                              AppText(
                                'تسجيل الدخول',
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
                                    if (showPasswordField) ...[
                                      MasterTextField(
                                        controller: passwordController,
                                        isPassword: true,
                                        hintText: 'كلمة المرور',
                                        validate: Validator.password,
                                      ),
                                      16.sbH,
                                    ],
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: isTablet ? 10.sp : 16.sp),
                                      child: ConditionalBtn(
                                        condition: state is LoginLoadingState,
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          if (formKey.currentState!.validate()) {
                                            
                                            cubit.login(
                                              phone: phoneController.text.trim(),
                                              password: showPasswordField
                                                  ? passwordController.text.trim()
                                                  : null,
                                            );
                                          }
                                        },
                                        text: showPasswordField ? 'تسجيل الدخول' : 'التالي',
                                      ),
                                    ),
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
    super.dispose();
  }
}
