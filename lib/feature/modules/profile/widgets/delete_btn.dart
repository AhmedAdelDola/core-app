part of '../profile_imports.dart';

class DeleteAccountBtn extends StatelessWidget {
  const DeleteAccountBtn({super.key});

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red.shade700,
                    size: 28.sp,
                  ),
                ),
              ),
              14.sbH,
              AppText(
                'حذف الحساب نهائياً',
                style: TextStyles.textViewBold(
                  size: 17.sp,
                  color: AppColors.textColor,
                ),
              ),
              8.sbH,
              AppText(
                'هل أنت متأكد من رغبتك في حذف الحساب؟ سيتم مسح كافة البيانات والاشتراكات بشكل دائم ولا يمكن استرجاعها.',
                style: TextStyles.textViewRegular(
                  fontSize: 13.sp,
                  color: AppColors.textColor4,
                ),
                align: TextAlign.center,
              ),
              20.sbH,
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: AppText(
                        'إلغاء',
                        style: TextStyles.textViewMedium(
                          fontSize: 14.sp,
                          color: AppColors.textColor5,
                        ),
                      ),
                    ),
                  ),
                  10.sbW,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        di<GetProfileCubit>().delete();
                        UserPreferencesHelper().clearUserPreference();
                        di<BottomBarCubit>().updatePageIndex(0);
                        NamedNavigatorImpl.pushNamed(Routes.login, clean: true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        elevation: 0,
                      ),
                      child: AppText(
                        'حذف نهائي',
                        style: TextStyles.textViewBold(
                          size: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetProfileCubit, GetProfileState>(
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is DeleteLoading,
          builder: (context) => const AppLoader(),
          fallback: (context) {
            return TextButton(
              onPressed: () => _showDeleteDialog(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    size: 16.sp,
                    color: Colors.grey.shade400,
                  ),
                  6.sbW,
                  AppText(
                    'حذف الحساب',
                    color: Colors.grey.shade500,
                    size: 12.5.sp,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
