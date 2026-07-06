import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/colors/app_colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isIOS == true
          ? const CupertinoActivityIndicator()
          :  CircularProgressIndicator(color: AppColors.kPrimary),
    );
  }
}

// class AppLoader extends StatelessWidget {
//   final Color? color;
//   final double? strokeAlign;
//
//   const AppLoader({super.key, this.color, this.strokeAlign});
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: CircularProgressIndicator(
//         strokeAlign: strokeAlign ?? 1,
//         valueColor: AlwaysStoppedAnimation<Color>(
//           color ?? AppColors.kPrimary,
//         ),
//       ),
//     );
//   }
// }
