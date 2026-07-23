import '../../../../../../core/widgets/ui_helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../cubit/home_cubit/home_cubit.dart';
import '../widgets/recommended_lessons_card.dart';

class RecommendedLessonsSection extends StatelessWidget {
  const RecommendedLessonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.sizeOf(context).width >= 600;

    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final model = HomeCubit.of(context).home?.suggestedSessions;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    'الحصص المقترحة',
                    style: TextStyle(fontSize: 18.sp, fontWeight: w700),
                  ),
                ],
              ),
            ),
            24.sbH,
            SizedBox(
              width: double.infinity,
              height: isLargeScreen ? 260 : 250.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: model?.length ?? 0,
                itemBuilder: (c, i) => Align(
                  alignment: Alignment.topCenter,
                  child: RecommendedLessonsCard(model: model?[i]),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
