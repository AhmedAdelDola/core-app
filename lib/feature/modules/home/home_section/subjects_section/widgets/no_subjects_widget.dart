import 'package:flutter/material.dart';

import '../../../../../../core/widgets/app_texts/app_text.dart';

class NoSubjectsWidget extends StatelessWidget {
  const NoSubjectsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppText('لا يوجد مواد دراسية', size: 16, weight: bold),
    );
  }
}
