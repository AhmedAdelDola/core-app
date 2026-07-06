part of '../../profile_imports.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List terms = [
'باستخدام تطبيق ${appSettings?.tenant?.name} فإنك توافق على الالتزام بهذه الشروط والأحكام.',
'يجب استخدام التطبيق للأغراض التعليمية المشروعة فقط، ويُمنع استخدامه بأي طريقة قد تؤثر على عمل التطبيق أو تضر بالمستخدمين الآخرين.',
'يلتزم المستخدم بتقديم بيانات صحيحة ودقيقة عند إنشاء الحساب، ويتحمل مسؤولية الحفاظ على سرية بيانات الدخول الخاصة به.',
'جميع المحتويات التعليمية والمواد المتوفرة داخل التطبيق محمية بحقوق الملكية الفكرية، ولا يجوز نسخها أو إعادة نشرها أو توزيعها دون الحصول على إذن مسبق.',
'يحتفظ تطبيق الحنبلي بالحق في تحديث أو تعديل المحتوى أو الخدمات أو شروط الاستخدام في أي وقت، ويتم نشر التحديثات داخل التطبيق.',
'يحق لإدارة التطبيق تعليق أو إيقاف أي حساب يخالف هذه الشروط أو يسيء استخدام المنصة.',
'لا يتحمل تطبيق الحنبلي المسؤولية عن أي أضرار ناتجة عن سوء استخدام التطبيق أو عن أي انقطاع مؤقت في الخدمة لأسباب تقنية أو خارجة عن الإرادة.',
'استمرار استخدام التطبيق بعد نشر أي تعديلات على شروط الاستخدام يُعد موافقة ضمنية على هذه التعديلات.',
];
    return Scaffold(
      appBar: const CustomAppBar(title: 'شروط الإستخدام'),
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: ListView.builder(
          itemCount: terms.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.sp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Icon(Icons.circle, size: 15, color: AppColors.kPrimary),
                  Expanded(
                    child: Text(
                      '${terms[index]}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
