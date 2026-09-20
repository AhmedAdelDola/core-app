part of 'profile_imports.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final bool isTablet = screenWidth >= 600;

    return BlocProvider<GetProfileCubit>(
      create: (context) => di<GetProfileCubit>()..getProfile(),
      child: BlocBuilder<GetProfileCubit, GetProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(top: 8.h, bottom: 96.h),
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 650 : double.infinity,
                ),
                child: Column(
                  children: [
                    ProfileItem(
                      onTap: () => NamedNavigatorImpl.push(const PersonalData()),
                      img: AppImages.person,
                      title: 'البيانات الشخصية',
                      subTitle: 'عرض وتعديل معلومات حسابك',
                      iconColor: const Color(0xFF2563EB),
                      iconBgColor: const Color(0xFFEFF6FF),
                    ),
                    ProfileItem(
                      onTap: () => NamedNavigatorImpl.push(const WalletScreen()),
                      img: AppImages.wallet,
                      title: 'محفظتي',
                      subTitle: 'الرصيد المتاح وسجل المعاملات والشحن',
                      iconColor: const Color(0xFF059669),
                      iconBgColor: const Color(0xFFECFDF5),
                      child: const WalletProfileItem(),
                    ),
                    ProfileItem(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                            text:
                                'حمّل تطبيق ${appSettings?.tenant?.name ?? "المنصة"} الآن لمتابعة أقوى الكورسات والمحاضرات!',
                          ),
                        );
                        showSuccessToast('تم نسخ رسالة المشاركة بنجاح');
                      },
                      img: AppImages.share,
                      title: 'مشاركة التطبيق',
                      subTitle: 'شارك التطبيق مع أصدقائك وزملائك',
                      iconColor: const Color(0xFF7C3AED),
                      iconBgColor: const Color(0xFFF5F3FF),
                    ),
                    ProfileItem(
                      onTap: () => NamedNavigatorImpl.push(const AboutAppScreen()),
                      img: AppImages.aboutApp,
                      title: 'عن التطبيق',
                      subTitle: 'اعرف المزيد عن ${appSettings?.tenant?.name ?? "المنصة"}',
                      iconColor: const Color(0xFF0284C7),
                      iconBgColor: const Color(0xFFF0F9FF),
                    ),
                    ProfileItem(
                      onTap: () => NamedNavigatorImpl.push(const TechnicalSupport()),
                      img: AppImages.suggestions,
                      title: 'الشكاوى والمقترحات',
                      subTitle: 'نحن هنا لمساعدتك والاستماع لآرائك',
                      iconColor: const Color(0xFFD97706),
                      iconBgColor: const Color(0xFFFFFBEB),
                    ),
                    ProfileItem(
                      onTap: () => NamedNavigatorImpl.push(const TermsOfUseScreen()),
                      img: AppImages.termsOfUse,
                      title: 'شروط الإستخدام',
                      subTitle: 'الشروط والأحكام وسياسة الخصوصية',
                      iconColor: const Color(0xFF4B5563),
                      iconBgColor: const Color(0xFFF3F4F6),
                    ),
                    24.sbH,
                    const LogoutBtn(),
                    8.sbH,
                    const DeleteAccountBtn(),
                    
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
