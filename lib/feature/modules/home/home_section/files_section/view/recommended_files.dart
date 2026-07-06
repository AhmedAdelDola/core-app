import 'package:elhanbly/models/home_entities/home/get_home.dart';

import '../../../../../../core/navigator/named_navigator_impl.dart';
import '../widgets/no_fiels_added.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/app_bar/custom_curved_appbar.dart';
import '../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../../../../models/home_entities/files/get_recommended_files_response.dart';
import '../../../cubit/home_cubit/home_cubit.dart';
import '../../../widgets/show_all_widget.dart';
import 'recommended_files_item.dart';

class RecommendedFiles extends StatelessWidget {
  const RecommendedFiles({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final cubit = HomeCubit.of(context);
        if (cubit.home?.featuredFiles?.isEmpty ?? true) {
          return const NoFilesAdded();
        } else {
          return Column(
            children: [
              ShowAllWidget(
                'الملفات المقترحة',
                () => NamedNavigatorImpl.push(RecommendedFilesScreen(model: cubit.home?.featuredFiles ?? [])),
              ),
              24.sbH,
              ...List.generate(
                cubit.home?.featuredFiles?.length ?? 0,
                (i) => RecommendedFilesItem(model: cubit.home?.featuredFiles?[i]),
              ),
              24.sbH,
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
    return Scaffold(
      appBar: const CustomAppBar(title: 'الملفات المقترحة'),
      body: ListView.builder(
        itemCount: model.length,
        itemBuilder: (c, i) => RecommendedFilesItem(model: model[i]),
      ),
    );
  }
}
