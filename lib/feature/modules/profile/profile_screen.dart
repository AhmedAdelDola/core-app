part of 'profile_imports.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetProfileCubit>(
      create: (context) => di<GetProfileCubit>()..getProfile(),
      child: BlocBuilder<GetProfileCubit, GetProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [

                ProfileItem(
                  onTap: () => NamedNavigatorImpl.push(const PersonalData()),
                  img: AppImages.person,
                  title: 'البيانات الشخصية',
                  subTitle: 'البيانات المسجله للحساب الشخصي',
                ),

                ProfileItem(
                  onTap: () => NamedNavigatorImpl.push(const WalletScreen()),
                  img: AppImages.wallet,
                  title: 'محفظتي',
                  subTitle: 'البيانات المسجله للحساب الشخصي',
                  child: const WalletProfileItem(),
                ),

                // ProfileItem(
                //   onTap: () => NamedNavigatorImpl.push(const FavouriteScreen()),
                //   img: AppImages.heart,
                //   title: 'المفضلة',
                //   subTitle: 'البيانات المسجله للحساب الشخصي',
                // ),
                ProfileItem(
                  onTap: () {
                    ///
                  },
                  img: AppImages.share,
                  title: 'مشاركة التطبيق',
                  subTitle: 'البيانات المسجله للحساب الشخصي',
                ),

                ProfileItem(
                  onTap: () => NamedNavigatorImpl.push(const AboutAppScreen()),
                  img: AppImages.aboutApp,
                  title: 'عن التطبيق',
                  subTitle: 'اعرف المزيد عن A plus',
                ),

                ProfileItem(
                  onTap: () => NamedNavigatorImpl.push(const TechnicalSupport()),
                  img: AppImages.suggestions,
                  title: 'الشكاوى و المقترحات',
                  subTitle: 'نعمل علي ان تكون سعيد بالتعامل',
                ),

                ProfileItem(
                  onTap: () => NamedNavigatorImpl.push(const TermsOfUseScreen()),
                  img: AppImages.termsOfUse,
                  title: 'شروط الإستخدام',
                  subTitle: 'بعض الشروط الواجب تواجدها',
                ),
                60.sbH,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LogoutBtn(),
                    DeleteAccountBtn(),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
