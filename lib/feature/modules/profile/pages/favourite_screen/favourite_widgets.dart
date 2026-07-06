part of '../../profile_imports.dart';

class ImgPlaceHolderRemoveFav extends StatelessWidget {
  final Function() onTabRemoveFav;
  const ImgPlaceHolderRemoveFav({super.key, required this.onTabRemoveFav});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      left: 8,
      child: InkWell(
        onTap: onTabRemoveFav,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.red.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
          ),
          child: Center(
            child: Row(
              children: [
                const Icon(Icons.delete_forever_outlined, color: AppColors.red),
                AppText(
                  'حذف',
                  style: TextStyles.textViewMedium(
                    color: AppColors.red,
                    fontSize: 16.sp,
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

class ImgPlaceHolder extends StatelessWidget {
  const ImgPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 382.w,
      height: 171.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        image: const DecorationImage(
          image: NetworkImage(Strings.placeHolderImg),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class ImgPlaceHolderCourseState extends StatelessWidget {
  const ImgPlaceHolderCourseState({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8,
      right: 8,
      child: Container(
        width: 62.w,
        height: 32.h,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.kPrimary,
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
        child: Center(
          child: AppText(
            'TEXT',
            style: TextStyles.textViewMedium(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}
