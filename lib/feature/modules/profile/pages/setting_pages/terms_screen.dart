part of '../../profile_imports.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appName = appSettings?.tenant?.name ??
        appSettings?.branding?.displayName ??
        ClientConfig.appName;

    final List<Map<String, String>> terms = [
      {
        'title': 'الموافقة على الشروط',
        'body':
            'باستخدامك لتطبيق $appName فإنك توافق على الالتزام الكامل بهذه الشروط والأحكام وسياسة الاستخدام المعتمدة.',
      },
      {
        'title': 'الاستخدام المشروع',
        'body':
            'يجب استخدام التطبيق للأغراض التعليمية المشروعة فقط، ويُمنع منعاً باتاً استخدامه بأي طريقة قد تعطل خدمات التطبيق أو تضر بالمستخدمين الآخرين.',
      },
      {
        'title': 'دقة البيانات وأمان الحساب',
        'body':
            'يلتزم المستخدم بتقديم بيانات صحيحة ودقيقة عند إنشاء الحساب، ويتحمل المسؤولية الكاملة عن الحفاظ على سرية بيانات الدخول وعدم مشاركتها.',
      },
      {
        'title': 'حقوق الملكية الفكرية',
        'body':
            'جميع المحتويات التعليمية، الفيديوهات، والملفات داخل التطبيق محمية بحقوق الملكية الفكرية، ولا يجوز نسخها أو تسجيلها أو إعادة نشرها بأي شكل.',
      },
      {
        'title': 'تحديث وتعديل الخدمات',
        'body':
            'تحتفظ إدارة المنصة بالحق في تحديث أو تعديل المحتوى التعليمي أو الخدمات أو شروط الاستخدام في أي وقت لضمان استمرار الجودة وتطوير المنصة.',
      },
      {
        'title': 'سياسة إيقاف الحسابات',
        'body':
            'يحق لإدارة التطبيق إيقاف أو تعليق أي حساب يثبت مخالفته لهذه الشروط أو إساءة استخدامه للمنصة والأنظمة التابعة لها.',
      },
      {
        'title': 'إخلاء المسؤولية التقنية',
        'body':
            'تبذل إدارة المنصة أقصى جهد لضمان استقرار الخدمة، ولا تتحمل المسؤولية عن أي انقطاع مؤقت ناجم عن صيانة دورية أو ظروف تقنية طارئة خارجة عن الإرادة.',
      },
      {
        'title': 'استمرار الاستخدام',
        'body':
            'استمرارك في استخدام التطبيق بعد أي تحديث لهذه الشروط يُعد موافقة صريحة على تلك التعديلات.',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CustomAppBar(title: 'شروط الإستخدام'),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        children: [
          // Header Card
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.kPrimary,
                  AppColors.kPrimary.withOpacity(0.85),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.kPrimary.withOpacity(0.2),
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
                    Icons.gavel_rounded,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اتفاقية الاستخدام والخصوصية',
                        style: TextStyles.textViewBold(
                          size: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'يرجى قراءة الشروط بعناية قبل استخدام المنصة لضمان أفضل تجربة لك',
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

          // Terms List
          ...terms.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final numStr = (index + 1).toString().padLeft(2, '0');

            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      numStr,
                      style: TextStyles.textViewBold(
                        size: 13.sp,
                        color: AppColors.kPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: TextStyles.textViewBold(
                            size: 13.5.sp,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          item['body']!,
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            fontFamily: fontFamilyDINNextLT,
                            color: const Color(0xFF64748B),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          // Bottom Note
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              'آخر تحديث: سبتمبر 2026',
              style: TextStyles.textViewRegular(
                fontSize: 11.5.sp,
                color: const Color(0xFF94A3B8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
