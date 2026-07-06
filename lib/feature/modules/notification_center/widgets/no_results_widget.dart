import 'package:flutter/material.dart';

import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/widgets/app_texts/app_text.dart';
import '../../../../core/widgets/ui_helpers/extensions.dart';

class NoResultsWidget extends StatelessWidget {
  final Color color;
  const NoResultsWidget({super.key, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Icon(Icons.search_off, size: 140, color: AppColors.kPrimary),
          20.sbH,
          const AppText('لا يوجد إشعارات حالياً'),
        ],
      ),
    );
  }
}
