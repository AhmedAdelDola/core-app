part of '../../profile_imports.dart';

class TechnicalSupport extends StatelessWidget {
  const TechnicalSupport({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = appSettings?.contacts ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CustomAppBar(title: 'الدعم الفني'),
      body: AdaptiveContainer(
        maxWidth: 680,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          children: [
            // Top Banner
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0F766E),
                  const Color(0xFF14B8A6),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F766E).withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.support_agent_rounded,
                    color: Colors.white,
                    size: 26.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'فريق الدعم الفني والمساعدة',
                        style: TextStyles.textViewBold(
                          size: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'نحن هنا لمساعدتك على مدار الساعة، اختر القناة المناسبة للتواصل',
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
          ),
          SizedBox(height: 16.h),

          if (contacts.isEmpty) ...[
            Container(
              padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.contact_support_outlined,
                    size: 48.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'لا تتوفر جهات اتصال حالياً',
                    style: TextStyles.textViewMedium(
                      fontSize: 14.sp,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            ...contacts.map((contact) {
              final isAvailable = contact.isActive == true;
              final label = contact.label ?? 'خدمة العملاء';
              final phone = contact.value ?? '';

              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // WhatsApp / Chat Icon
                    Container(
                      width: 44.w,
                      height: 44.w,
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: SvgPicture.asset(
                        AppImages.whatsappSvg,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                label,
                                style: TextStyles.textViewBold(
                                  size: 14.sp,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              // Status pill
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isAvailable
                                      ? const Color(0xFFECFDF5)
                                      : const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: isAvailable
                                        ? const Color(0xFFA7F3D0)
                                        : const Color(0xFFFECACA),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6.w,
                                      height: 6.w,
                                      decoration: BoxDecoration(
                                        color: isAvailable
                                            ? const Color(0xFF10B981)
                                            : const Color(0xFFEF4444),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      isAvailable ? 'متاح' : 'غير متاح',
                                      style: TextStyle(
                                        fontSize: 10.5.sp,
                                        fontFamily: fontFamilyDINNextLT,
                                        color: isAvailable
                                            ? const Color(0xFF065F46)
                                            : const Color(0xFF991B1B),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            phone.isNotEmpty
                                ? phone
                                : 'تواصل معنا مباشرة عبر محادثة واتساب',
                            style: TextStyles.textViewRegular(
                              fontSize: 12.sp,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action Button
                    InkWell(
                      onTap: () {
                        if (phone.isNotEmpty) {
                          AppLauncher.launchWhatsApp(number: phone);
                        }
                      },
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'مراسلة',
                              style: TextStyles.textViewBold(
                                size: 12.sp,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 11.sp,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
      ),
    );
  }
}
