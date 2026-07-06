part of '../../profile_imports.dart';

class PersonalData extends StatelessWidget {
  const PersonalData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'البيانات الشخصية'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const UserImg(),
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
            ProfileItem(
              onTap: () => NamedNavigatorImpl.push(const EditPersonalData()),
              title: 'البيانات الاساسية',
              subTitle: 'البيانات المسجلة للحساب الشخصي',
              img: AppImages.person,
            ),
            ProfileItem(
              onTap: () {},
              title: 'البيانات الدراسية',
              subTitle: 'البيانات المسجلة للحساب الشخصي',
              img: AppImages.libraryNav,
            ),
            ProfileItem(
              onTap: () => NamedNavigatorImpl.push(const EditPhoneScreen()),
              title: 'تعديل رقم الهاتف',
              subTitle: 'البيانات المسجلة للحساب الشخصي',
              img: AppImages.phone,
            ),
          ],
        ),
      ),
    );
  }
}

class UserImg extends StatelessWidget {
  const UserImg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      margin: EdgeInsets.only(top: 20.h),
      child: CachedNetworkImage(
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
    );
  }
}
