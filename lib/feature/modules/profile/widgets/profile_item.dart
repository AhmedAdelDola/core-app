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
    final bool isMobileLandscape = AppResponsive.isMobileLandscape(context);
    final effectiveIconColor = iconColor ?? AppColors.kPrimary;
    final effectiveIconBg = iconBgColor ?? effectiveIconColor.withOpacity(0.08);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobileLandscape ? 2 : 16.w,
        vertical: isMobileLandscape ? 3 : 5.h,
      ),
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
            padding: EdgeInsets.symmetric(
              horizontal: isMobileLandscape ? 10 : 14.w,
              vertical: isMobileLandscape ? 8 : 12.h,
            ),
            child: Row(
              children: [
                Container(
                  width: isMobileLandscape ? 36.0 : 44.w,
                  height: isMobileLandscape ? 36.0 : 44.h,
                  padding: EdgeInsets.all(isMobileLandscape ? 8.0 : 10.r),
                  decoration: BoxDecoration(
                    color: effectiveIconBg,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: SvgPicture.asset(
                    img,
                    colorFilter: ColorFilter.mode(effectiveIconColor, BlendMode.srcIn),
                  ),
                ),
                (isMobileLandscape ? 8.0 : 12.0).sbW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        title,
                        style: TextStyles.textViewBold(
                          size: isMobileLandscape ? 12.5.sp : 14.sp,
                          color: AppColors.textColor,
                        ),
                        align: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      (isMobileLandscape ? 2.0 : 3.0).sbH,
                      AppText(
                        subTitle,
                        style: TextStyles.textViewRegular(
                          fontSize: isMobileLandscape ? 10.sp : 11.5.sp,
                          color: AppColors.textColor4,
                        ),
                        align: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                (isMobileLandscape ? 6.0 : 8.0).sbW,
                child ??
                    Container(
                      width: isMobileLandscape ? 22.0 : 28.w,
                      height: isMobileLandscape ? 22.0 : 28.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8FAFC),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: isMobileLandscape ? 10.sp : 12.sp,
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
