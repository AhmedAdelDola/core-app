import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/util/responsive/responsive_helper.dart';
import '../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../core/widgets/app_bar/custom_curved_appbar.dart';
import '../../../../../../models/home_entities/home/get_home.dart';
import '../../../cubit/home_cubit/home_cubit.dart';
import '../../../widgets/show_all_widget.dart';
import '../widgets/no_fiels_added.dart';
import 'recommended_files_item.dart';

class RecommendedFiles extends StatelessWidget {
  const RecommendedFiles({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = AppResponsive.isTabletOrLarger(context);
    final int crossAxisCount = AppResponsive.gridColumns(
      context,
      mobile: 1,
      tabletPortrait: 2,
      tabletLandscape: 3,
      desktop: 3,
    );

    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final cubit = HomeCubit.of(context);
        final rawFiles = cubit.home?.featuredFiles;
        final files = rawFiles
            ?.where((f) =>
                f.type?.toLowerCase() == 'pdf' ||
                f.kind?.toLowerCase() == 'pdf')
            .toList();

        if (files == null || files.isEmpty) {
          return const NoFilesAdded();
        } else {
          return Column(
            children: [
              ShowAllWidget(
                'الملفات المقترحة',
                () => NamedNavigatorImpl.push(
                  RecommendedFilesScreen(model: files),
                ),
              ),
              SizedBox(height: isTablet ? 14.h : 10.h),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 20.w : 14.w,
                ),
                child: isTablet
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 4.8,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: files.length,
                        itemBuilder: (c, i) => RecommendedFilesItem(
                          model: files[i],
                        ),
                      )
                    : Column(
                        children: List.generate(
                          files.length,
                          (i) => RecommendedFilesItem(model: files[i]),
                        ),
                      ),
              ),
            ],
          );
        }
      },
    );
  }
}

class RecommendedFilesScreen extends StatelessWidget {
  final List<FeaturedFile> model;

  const RecommendedFilesScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = AppResponsive.isTabletOrLarger(context);
    final int crossAxisCount = AppResponsive.gridColumns(
      context,
      mobile: 1,
      tabletPortrait: 2,
      tabletLandscape: 3,
      desktop: 3,
    );

    return Scaffold(
      appBar: const CustomAppBar(title: 'الملفات المقترحة'),
      body: AdaptiveContainer(
        maxWidth: ResponsiveBreakpoints.maxContentWidth,
        child: isTablet
            ? GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 4.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 10,
                ),
                itemCount: model.length,
                itemBuilder: (c, i) => RecommendedFilesItem(model: model[i]),
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                itemCount: model.length,
                itemBuilder: (c, i) => RecommendedFilesItem(model: model[i]),
              ),
      ),
    );
  }
}
