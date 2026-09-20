part of '../profile_imports.dart';

class ProfileItem extends StatelessWidget {
  final String title, subTitle, img;
  final void Function() onTap;
  final Widget? child;
  final Color? iconColor;
  final Color? iconBgColor;

  const ProfileItem({
    super.key,
    required this.title,
    required this.subTitle,
    required this.img,
    required this.onTap,
    this.child,
    this.iconColor,
    this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppColors.kPrimary;
    final effectiveIconBg = iconBgColor ?? effectiveIconColor.withOpacity(0.08);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: effectiveIconBg,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: SvgPicture.asset(
                    img,
                    colorFilter: ColorFilter.mode(effectiveIconColor, BlendMode.srcIn),
                  ),
                ),
                12.sbW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        title,
                        style: TextStyles.textViewBold(
                          size: 14.sp,
                          color: AppColors.textColor,
                        ),
                        align: TextAlign.start,
                      ),
                      3.sbH,
                      AppText(
                        subTitle,
                        style: TextStyles.textViewRegular(
                          fontSize: 11.5.sp,
                          color: AppColors.textColor4,
                        ),
                        align: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                8.sbW,
                child ??
                    Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8FAFC),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12.sp,
                        color: AppColors.textColor4,
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
