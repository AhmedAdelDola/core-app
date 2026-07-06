part of 'register_imports.dart';

class RegisterScreen extends StatefulWidget {
   RegisterScreen({super.key, required this.phone});
   String phone;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(di<Repository>())..fetchStages(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterStagesErrorState || state is RegisterErrorState) {
            showErrorToast((state as dynamic).message);
          }

          if (state is RegisterSuccessState) {
            showErrorToast('تم التسجيل بنجاح');
            NamedNavigatorImpl.pop();
          }
        },
        builder: (context, state) {
          final cubit = RegisterCubit.of(context);
          return Scaffold(
            backgroundColor: AppColors.kPrimary,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                24.sbH,
                _buildHeader(),
                24.sbH,
                Expanded(
                  child: Container(
                    
                    decoration: BoxDecoration(
                      color: AppColors.kWhite,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                      child: _buildForm(context, cubit, state),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                    30.sbH,

          AppText(
            'انشاء حساب جديد',
            style: TextStyles.textViewSemiBold(fontSize: 26.sp, color: AppColors.kWhite),
            align: TextAlign.start,
          ),
          8.sbH,
          AppText(
            'سجل حسابك لتتمكن من الوصول إلى المحتوى التعليمي الخاص بك',
            style: TextStyles.textViewRegular(fontSize: 14.sp, color: AppColors.kWhite),
            align: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, RegisterCubit cubit, RegisterState state) {
    if (state is RegisterStagesLoadingState) {
      return Center(child: AppLoader());
    }

    if (state is RegisterStagesErrorState) {
      return Column(
        children: [
          AppText(
            state.message,
            style: TextStyles.textViewRegular(color: AppColors.textColor),
          ),
          20.sbH,
          CustomButton(
            text: 'إعادة المحاولة',
            onTap: cubit.fetchStages,
          ),
        ],
      );
    }

    final showStageSelector = cubit.stages.length > 1;
    final levelItems = cubit.currentLevels.map((level) => level.name).toList();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MasterTextField(
            controller: _nameController,
            hintText: 'الاسم',
            validate: AppValidators.requiredOnly,
          ),
          16.sbH,
          MasterTextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            hintText: widget.phone,
            readOnly: true,
          ),
                             
          
          16.sbH,
          MasterTextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'البريد الالكتروني',
            validate: Validator.email,
          ),
          16.sbH,
          MasterTextField(
            controller: _passwordController,
            isPassword: true,
            hintText: 'كلمة المرور',
            validate: Validator.password,
          ),
          16.sbH,
          
          if (showStageSelector) ...[
            AppDropdown(
              hintText: 'اختر المرحلة',
              value: cubit.selectedStage?.name,
              items: cubit.stages.map((stage) => stage.name).toList(),
              onChanged: (value) {
                if (value != null) {
                  final matches = cubit.stages.where((stage) => stage.name == value);
                  if (matches.isNotEmpty) cubit.selectStage(matches.first.id);
                }
              },
            ),
            16.sbH,
          ],
          AppDropdown(
            hintText: 'اختر الصف',
            value: cubit.selectedLevel?.name,
            items: levelItems,
            onChanged: (value) {
              if (value != null) {
                final matches = cubit.currentLevels.where((level) => level.name == value);
                if (matches.isNotEmpty) cubit.selectLevel(matches.first.id);
              }
            },
          ),
          24.sbH,
          CustomButton(
            text: state is RegisterSubmittingState ? 'جاري التسجيل...' : 'تسجيل',
            isLoading: state is RegisterSubmittingState,
            onTap: () {
              if (_formKey.currentState?.validate() != true) return;
              cubit.register(
                name: _nameController.text.trim(),
                phone: widget.phone,
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              );
            },
          ),
          16.sbH,
          AppText(
            'ستتم مشاركة بياناتك بأمان وفقًا لسياسات التطبيق.',
            style: TextStyles.textViewRegular(fontSize: 12.sp, color: AppColors.textColor2),
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
