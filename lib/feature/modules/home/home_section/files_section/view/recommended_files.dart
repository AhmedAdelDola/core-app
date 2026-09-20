import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final cubit = HomeCubit.of(context);
        final files = cubit.home?.featuredFiles;

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
                  horizontal: isTablet ? 20.w : 10.w,
                ),
                child: isTablet
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final bool isTablet = screenWidth >= 600;

    return Scaffold(
      appBar: const CustomAppBar(title: 'الملفات المقترحة'),
      body: isTablet
          ? GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 10,
              ),
              itemCount: model.length,
              itemBuilder: (c, i) => RecommendedFilesItem(model: model[i]),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              itemCount: model.length,
              itemBuilder: (c, i) => RecommendedFilesItem(model: model[i]),
            ),
    );
  }
}
