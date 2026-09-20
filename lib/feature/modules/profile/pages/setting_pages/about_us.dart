part of '../../profile_imports.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appName = appSettings?.tenant?.name ??
        appSettings?.branding?.displayName ??
        ClientConfig.appName;
    final slogan = appSettings?.branding?.slogan ??
        'منصتك التعليمية المتكاملة لرحلة دراسية ناجحة ومميزة';
    final logoUrl = appSettings?.branding?.logoUrl;

    // Find technical support phone if exists
    final supportContact = appSettings?.contacts?.firstWhere(
      (c) =>
          c.type?.toLowerCase() == 'support' ||
          (c.label ?? '').contains('دعم') ||
          (c.label ?? '').contains('فني'),
      orElse: () => (appSettings?.contacts?.isNotEmpty == true
          ? appSettings!.contacts!.first
          : Contact()),
    );
    final supportPhone = supportContact?.value ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CustomAppBar(title: 'عن التطبيق'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            // ── Hero Branding Header ──────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // App Logo in elevated frame
                  Container(
                    width: 86.w,
                    height: 86.w,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.kPrimary.withOpacity(0.2),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.kPrimary.withOpacity(0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: logoUrl != null && logoUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: logoUrl,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.kPrimary,
                                ),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                AppImages.logoPng,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Image.asset(
                              AppImages.logoPng,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Academy / Platform Name
                  Text(
                    appName,
                    style: TextStyles.textViewBold(
                      size: 20.sp,
                      color: const Color(0xFF0F172A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6.h),

                  // Tagline / Slogan
                  Text(
                    slogan,
                    style: TextStyles.textViewRegular(
                      fontSize: 13.sp,
                      color: const Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),

                  // Version Chip
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppColors.kPrimary.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          size: 14.sp,
                          color: AppColors.kPrimary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'الإصدار 1.0.0',
                          style: TextStyles.textViewMedium(
                            fontSize: 11.5.sp,
                            color: AppColors.kPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // ── About Platform Description Card ───────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.kPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.auto_stories_rounded,
                          size: 20.sp,
                          color: AppColors.kPrimary,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'من نحن',
                        style: TextStyles.textViewBold(
                          size: 16.sp,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'منصة $appName هي بيئة تعليمية متكاملة تهدف إلى تقديم تجربة دراسية استثنائية وسلسة للطلاب، من خلال إتاحة محتوى تعليمي ثري يشمل الدروس التفاعلية، الاختبارات الدورية، والمتابعة الشاملة لمستوى التحصيل الدراسي في بيئة رقمية حديثة وآمنة.\n\nنسعى جاهدين لتمكين الطلاب من الوصول لأفضل الكورسات التعليمية في أي وقت ومن أي مكان، وتوفير كل ما يلزمهم لتحقيق التفوق والوصول إلى أعلى الدرجات.',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontFamily: fontFamilyDINNextLT,
                      color: const Color(0xFF334155),
                      height: 1.65,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // ── Features Highlights ────────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.stars_rounded,
                          size: 20.sp,
                          color: const Color(0xFFD97706),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'ما يميز المنصة',
                        style: TextStyles.textViewBold(
                          size: 16.sp,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Feature items
                  _buildFeatureTile(
                    icon: Icons.play_circle_filled_rounded,
                    iconBg: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF2563EB),
                    title: 'محاضرات وشروحات بجودة عالية',
                    subtitle:
                        'دروس مسجلة ومباشرة بأعلى وضوح ومحتوى منظم يضمن الفهم والاستيعاب الكامل.',
                  ),
                  SizedBox(height: 12.h),
                  _buildFeatureTile(
                    icon: Icons.assignment_turned_in_rounded,
                    iconBg: const Color(0xFFECFDF5),
                    iconColor: const Color(0xFF16A34A),
                    title: 'اختبارات ومتابعة دورية',
                    subtitle:
                        'امتحانات تدريبية وواجبات تفاعلية لقياس مستواك ومعرفة نقاط القوة وتطويرها.',
                  ),
                  SizedBox(height: 12.h),
                  _buildFeatureTile(
                    icon: Icons.account_balance_wallet_rounded,
                    iconBg: const Color(0xFFF5F3FF),
                    iconColor: const Color(0xFF7C3AED),
                    title: 'محفظة وأكواد شحن فورية',
                    subtitle:
                        'شحن رصيد سهل وسريع، وتفعيل مباشر للكورسات والحصص بأكواد الاشتراك.',
                  ),
                  SizedBox(height: 12.h),
                  _buildFeatureTile(
                    icon: Icons.support_agent_rounded,
                    iconBg: const Color(0xFFFFFBEB),
                    iconColor: const Color(0xFFD97706),
                    title: 'دعم فني وأكاديمي متواصل',
                    subtitle:
                        'فريق متكامل مستعد لمساعدتك والإجابة عن أي استفسارات على مدار اليوم.',
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // ── Contact / Support Card ─────────────────────────────────
            if (supportPhone.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF065F46),
                      const Color(0xFF047857),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF047857).withOpacity(0.25),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.headset_mic_rounded,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'هل لديك أي استفسار أو مشكلة؟',
                                style: TextStyles.textViewBold(
                                  size: 14.5.sp,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'فريق الدعم الفني جاهز لمساعدتك عبر واتساب',
                                style: TextStyles.textViewRegular(
                                  fontSize: 12.sp,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    InkWell(
                      onTap: () => AppLauncher.launchWhatsApp(
                        number: supportPhone,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppImages.whatsappSvg,
                              width: 18.w,
                              height: 18.w,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'تواصل مع الدعم الفني الآن',
                              style: TextStyles.textViewBold(
                                size: 13.5.sp,
                                color: const Color(0xFF065F46),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
            ],

            // ── Footer / Copyright ────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Column(
                children: [
                  Text(
                    'جميع الحقوق محفوظة © ${DateTime.now().year} $appName',
                    style: TextStyles.textViewRegular(
                      fontSize: 12.sp,
                      color: const Color(0xFF94A3B8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'صُمّم وطُوّر لتقديم تجربة تعليمية رائدة 🌟',
                    style: TextStyles.textViewRegular(
                      fontSize: 11.sp,
                      color: const Color(0xFFCBD5E1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.textViewBold(
                    size: 13.5.sp,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: fontFamilyDINNextLT,
                    color: const Color(0xFF64748B),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
