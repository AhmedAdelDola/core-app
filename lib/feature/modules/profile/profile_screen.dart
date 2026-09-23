part of 'profile_imports.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = AppResponsive.isTablet(context);
    final bool isMobileLandscape = AppResponsive.isMobileLandscape(context);
    final bool isLandscape = AppResponsive.isLandscape(context);
    final bool useTwoColumns = isMobileLandscape || (isTablet && isLandscape);

    return BlocProvider<GetProfileCubit>(
      create: (context) => di<GetProfileCubit>()..getProfile(),
      child: BlocBuilder<GetProfileCubit, GetProfileState>(
        builder: (context, state) {
          final items = [
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
          ];

          return SingleChildScrollView(
            padding: EdgeInsets.only(
              top: isMobileLandscape ? 6.0 : 8.h,
              bottom: isMobileLandscape ? 50.0 : 96.h,
            ),
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: useTwoColumns ? 850 : (isTablet ? 650 : double.infinity),
                ),
                child: useTwoColumns
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            for (int i = 0; i < items.length; i += 2)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    Expanded(child: items[i]),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: (i + 1 < items.length)
                                          ? items[i + 1]
                                          : const SizedBox(),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(height: isMobileLandscape ? 8 : 16),
                            Row(
                              children: [
                                const Expanded(child: LogoutBtn()),
                                SizedBox(width: isMobileLandscape ? 8 : 16),
                                const Expanded(child: DeleteAccountBtn()),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          ...items,
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
