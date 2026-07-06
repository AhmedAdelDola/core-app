part of '../profile_imports.dart';

class ProfileItem extends StatelessWidget {
  final String title, subTitle, img;
  final void Function() onTap;
  final Widget? child;

  const ProfileItem({
    super.key,
    required this.title,
    required this.subTitle,
    required this.img,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          // borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset:  Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.h,
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                    color: const Color(0xffF7FAFE), borderRadius: BorderRadius.circular(12.r)),
                child: SvgPicture.asset(
                  img,
                  colorFilter:  ColorFilter.mode(AppColors.kPrimary, BlendMode.srcIn),
                ),
              ),
              12.sbW,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    style: TextStyles.textViewMedium(color: AppColors.textColor),
                  ),
                  2.sbH,
                  AppText(
                    subTitle,
                    style: TextStyles.textViewRegular(color: AppColors.textColor4),
                  ),
                ],
              ),
              const Spacer(),
              child ?? Icon(Icons.arrow_forward_ios, size: 16.r),
            ],
          ),
        ),
      ),
    );
  }
}
