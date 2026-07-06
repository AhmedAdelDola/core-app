part of '../profile_imports.dart';

class DeleteAccountBtn extends StatelessWidget {
  const DeleteAccountBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetProfileCubit, GetProfileState>(
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is DeleteLoading,
          builder: (context) => const AppLoader(),
          fallback: (context) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                height: 42.h,
                width: 132.w,
                decoration: BoxDecoration(
                  color: AppColors.kWhite,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.red, width: 1),
                ),
                child: Center(
                  child: AppText('حذف الحساب', color: AppColors.red, size: 14.sp, weight: w600),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
