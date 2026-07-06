part of '../../profile_imports.dart';

class EditPersonalData extends StatefulWidget {
  const EditPersonalData({super.key});

  @override
  State<EditPersonalData> createState() => _EditPersonalDataState();
}

class _EditPersonalDataState extends State<EditPersonalData> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String genderType = '';
  List<String> genderList = ['male', 'female'];
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    nameController.text = userData?.student?.name ?? '';
    emailController.text = userData?.student?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'البيانات الاساسية'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        physics: const BouncingScrollPhysics(),
        child: BlocProvider(
          create: (context) => di<UpdateProfileCubit>(),
          child: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
            listener: (context, state) {
              if (state is UpdateProfileError) {
                showErrorToast(state.message);
              }
              if (state is UpdateProfileSuccess) {
                showSuccessToast(state.message);
                Future.microtask(() async {
                  await context.read<GetProfileCubit>().getProfile();
                  if (mounted) {
                    NamedNavigatorImpl.pop();
                  }
                });
              }
            },
            builder: (context, state) {
              var cubit = UpdateProfileCubit.of(context);
              return Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    MasterTextField(
                      controller: nameController,
                      validate: Validator.defaultValidator,
                      labelText: 'الاسم الاول',
                      prefixWidget: prefixIcon,
                    ),
                    20.sbH,
                    MasterTextField(
                      controller: emailController,
                      validate: Validator.defaultValidator,
                      labelText: 'البريد الإلكتروني',
                      prefixWidget: prefixIcon,
                    ),
                    20.sbH,
                    GestureDetector(
                      onTap: () async {
                        final image = await MyMedia.pickImageFromGallery();
                        if (image != null) {
                          setState(() => selectedImage = image);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 110.h,
                        decoration: BoxDecoration(
                          color: AppColors.kWhite,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        padding: EdgeInsets.all(12.w),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 32.r,
                              backgroundColor: AppColors.kPrimary.withAlpha((0.1 * 255).round()),
                              backgroundImage: selectedImage != null
                                  ? FileImage(selectedImage!) as ImageProvider
                                  : null,
                              child: selectedImage == null
                                  ? const Icon(Icons.camera_alt_outlined)
                                  : null,
                            ),
                            14.sbW,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                    'تغيير صورة الملف الشخصي',
                                    weight: w500,
                                    color: AppColors.textColor,
                                  ),
                                  6.sbH,
                                  AppText(
                                    selectedImage != null
                                        ? 'تم اختيار صورة جديدة'
                                        : 'اضغط لاختيار صورة من المعرض',
                                    color: AppColors.textColor2,
                                    size: 12.sp,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                   
                    
                    20.sbH,
                    CustomButton(
                      text: 'حفظ',
                      isLoading: state is UpdateProfileLoading,
                      onTap: () {
                        if (!formKey.currentState!.validate()) return;
                        cubit.updateProfile(
                          UpdateProfileParams(
                            name: nameController.text,
                            email: emailController.text,
                            gender: genderType.isNotEmpty ? genderType : null,
                          ),
                          image: selectedImage,
                        );
                      },
                    ),
                    20.sbH,
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Icon get prefixIcon => const Icon(Icons.person_outline, color: AppColors.textColor2);

  TextStyle get textStyle => const TextStyle(color: Colors.white);
}
