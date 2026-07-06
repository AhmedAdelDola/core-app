import '../../../../../../../../../core/widgets/app_texts/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommunityTab extends StatelessWidget {
  const CommunityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppText('المجتمع', weight: w700, size: 14.sp),
      ),
    );
  }
}
