import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/theme.dart';
import '../app_buttons/master_button.dart';
import '../app_texts/app_text.dart';
import 'extensions.dart';

Widget imageDialog({void Function()? camera, void Function()? gallery}) {
  return SizedBox(
    height: 150.h,
    child: Column(
      children: [
        20.sbH,
        AppText('قم باختيار صورة', style: TextStyles.textViewSemiBold()),
        20.sbH,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            children: [
              Expanded(
                child: MasterButton(
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  text: 'الكاميرا',
                  onPressed: camera,
                ),
              ),
              Expanded(
                child: MasterButton(
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  text: 'المعرض',
                  onPressed: gallery,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
