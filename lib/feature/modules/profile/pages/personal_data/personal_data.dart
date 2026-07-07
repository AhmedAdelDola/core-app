part of '../../profile_imports.dart';

class PersonalData extends StatefulWidget {
  const PersonalData({super.key});

  @override
  State<PersonalData> createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> {
   final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
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
                        Stack(alignment: AlignmentGeometry.bottomRight,
      children:[ Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.kPrimary,width: 2.5),
          shape: BoxShape.circle
        ),
        width: 100.w,
        height: 100.h,
        margin: EdgeInsets.only(top: 20.h),
        child: selectedImage != null
            ? Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: FileImage(selectedImage!), fit: BoxFit.fill),
                ),
              )
            : CachedNetworkImage(
                imageUrl: userData?.student?.imageUrl ?? Strings.placeHolderImg,
                imageBuilder: (context, img) => Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: img, fit: BoxFit.fill),
                  ),
                ),
                errorWidget: errorIconImage,
              ),
      ),
      GestureDetector(
        onTap: () async{
          final image = await MyMedia.pickImageFromGallery();
                        if (image != null) {
                          setState(() => selectedImage = image);
                        }
        },
        child: CircleAvatar(
          radius: 15,
        backgroundColor: AppColors.kPrimary,
        child: Icon(Icons.edit,color: AppColors.kWhite,size: 15,),
              ),
      )
    ]),
 
            12.sbH,
            AppText(
              '${userData?.student?.name}',
              style: TextStyle(
                color: AppColors.textColor,
                fontWeight: w500,
                fontSize: 24.sp,
              ),
            ),
            7.sbH,
            AppText(
              '${userData?.student?.level?.stage?.name} - ${userData?.student?.level?.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.textColor4,
                fontWeight: w500,
                fontSize: 16.sp,
              ),
            ),
            40.sbH,
                    MasterTextField(
                      controller: nameController,
                      validate: Validator.defaultValidator,
                      labelText: 'الاسم ',
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
                    // GestureDetector(
                    //   onTap: () async {
                    //     final image = await MyMedia.pickImageFromGallery();
                    //     if (image != null) {
                    //       setState(() => selectedImage = image);
                    //     }
                    //   },
                    //   child: Container(
                    //     width: double.infinity,
                    //     height: 110.h,
                    //     decoration: BoxDecoration(
                    //       color: AppColors.kWhite,
                    //       borderRadius: BorderRadius.circular(16.r),
                    //       border: Border.all(color: AppColors.borderColor),
                    //     ),
                    //     padding: EdgeInsets.all(12.w),
                    //     child: Row(
                    //       children: [
                    //         CircleAvatar(
                    //           radius: 32.r,
                    //           backgroundColor: AppColors.kPrimary.withAlpha((0.1 * 255).round()),
                    //           backgroundImage: selectedImage != null
                    //               ? FileImage(selectedImage!) as ImageProvider
                    //               : null,
                    //           child: selectedImage == null
                    //               ? const Icon(Icons.camera_alt_outlined)
                    //               : null,
                    //         ),
                    //         14.sbW,
                    //         Expanded(
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               AppText(
                    //                 'تغيير صورة الملف الشخصي',
                    //                 weight: w500,
                    //                 color: AppColors.textColor,
                    //               ),
                    //               6.sbH,
                    //               AppText(
                    //                 selectedImage != null
                    //                     ? 'تم اختيار صورة جديدة'
                    //                     : 'اضغط لاختيار صورة من المعرض',
                    //                 color: AppColors.textColor2,
                    //                 size: 12.sp,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                   
                    
                    200.sbH,
                    CustomButton(
                      text: 'حفظ',
                      isLoading: state is UpdateProfileLoading,
                      onTap: () {
                        if (!formKey.currentState!.validate()) return;
                        cubit.updateProfile(
                          UpdateProfileParams(
                            name: nameController.text,
                            email: emailController.text,
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
}
 Icon get prefixIcon => const Icon(Icons.person_outline, color: AppColors.textColor2);

TextStyle get textStyle => const TextStyle(color: Colors.white);
