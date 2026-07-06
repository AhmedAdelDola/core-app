import '../../../../../../core/widgets/ui_helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/widgets/app_texts/app_text.dart';

class NoFilesAdded extends StatelessWidget {
  const NoFilesAdded({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        24.sbH,
        Center(
          child: AppText(
            'لم يتم إضافة ملفات بعد',
            size: 18.sp,
            weight: FontWeight.bold,
          ),
        ),
        24.sbH,
      ],
    );
  }
}
