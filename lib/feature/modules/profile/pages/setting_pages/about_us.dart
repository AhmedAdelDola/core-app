part of '../../profile_imports.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'عن التطبيق'),
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Text.rich(TextSpan(
          text: 'تطبيق ${appSettings?.tenant?.name} هو منصة تعليمية متكاملة تهدف إلى تقديم تجربة تعليمية سهلة ومميزة للطلاب، من خلال توفير المحتوى التعليمي والدروس والاختبارات والمواد المساندة في بيئة رقمية حديثة وآمنة. يتيح التطبيق للطلاب الوصول إلى المحتوى التعليمي في أي وقت ومن أي مكان، مع توفير أدوات تساعدهم على متابعة تقدمهم الدراسي وتحقيق أفضل النتائج نسعى في تطبيق الحنبلي إلى تقديم محتوى تعليمي عالي الجودة، وتطوير تجربة تعليمية تفاعلية تواكب احتياجات الطلاب وتدعم رحلتهم التعليمية.',
          style: const TextStyle(fontSize: 14),
        ),)
      ),
    );
  }
}
