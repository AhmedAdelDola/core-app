import 'package:elhanbly/core/services/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/consts/images.dart';
import '../../core/theme/colors/app_colors.dart';
import '../../core/util/launcher.dart';
import '../../core/widgets/app_bar/default_app_bar.dart/default_app_bar.dart';
import '../../core/widgets/nav_bar/bottom_navigation_bar.dart';
import 'cubit/home_lay_out_cubit.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomBarCubit, BottomBarState>(
      builder: (context, state) {
        final cubit = BottomBarCubit.of(context);
        return Scaffold(
          appBar:  DefaultAppBar(),
          body: cubit.currentWidget,
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onItemTap: (index) => cubit.updatePageIndex(index),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () =>
                AppLauncher.launchWhatsApp(number: "${appSettings?.contacts?.where( (element) => element.type == 'support').first.value ?? ''}"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r)),
            backgroundColor: AppColors.kPrimary,
            child: SvgPicture.asset(
              AppImages.whatsappSvg,
              colorFilter:
                  const ColorFilter.mode(AppColors.kWhite, BlendMode.srcIn),
            ),
          ),
        );
      },
    );
  }
}
