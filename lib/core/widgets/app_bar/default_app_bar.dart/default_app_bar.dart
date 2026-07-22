import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../feature/home_layout/cubit/home_lay_out_cubit.dart';
import '../../../consts/images.dart';
import '../../../consts/strings.dart';
import '../../../navigator/named_navigator_impl.dart';
import '../../../services/di.dart';
import '../../../theme/colors/app_colors.dart';
import '../../app_texts/app_text.dart';
import '../qr_scanner.dart';
import 'default_app_bar_widgets.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  List<Widget>? action ;
   DefaultAppBar({super.key , this.action});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final double iconSize = isTablet ? 20.0 : 24.0;
    final double appBarHeight = isTablet ? 50.h : 60.h;

    return BlocBuilder<BottomBarCubit, BottomBarState>(
      builder: (context, state) {
        final cubit = BottomBarCubit.of(context);
        return AppBar(
          centerTitle: false,
          toolbarHeight: appBarHeight,
          title: setAppBarTitle(cubit.currentIndex),
          leading: (
                  cubit.currentIndex != 3 &&
                  cubit.currentIndex != 1)
              ? const AppBarImageWidget()
              : null,
          actions: action ?? null,
          
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}

Widget setAppBarTitle(int i) {
  if (i == 6) {
    return appBarTrainingView;
  } else if (i == 1) {
    return appBarLibraryView;
  } else if (i == 5) {
    return appBarNotifcationView;
  } else if (i == 2) {
    return appBarBodyView;
  }
  return appBarBodyView;
}

class AppBarImageWidget extends StatelessWidget {
  const AppBarImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final double avatarRadius = isTablet ? 16.r : 20.r;
    final double containerSize = isTablet ? 32.w : 40.w;
    final double errorFontSize = isTablet ? 16.0 : 20.0;

    return Padding(
      padding:
          EdgeInsetsDirectional.symmetric(horizontal: isTablet ? 2.w : 4.w),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.kPrimary),
        ),
        child: CircleAvatar(
          radius: avatarRadius,
          backgroundColor: AppColors.kWhite,
          child: CachedNetworkImage(
            placeholder: (context, url) => Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage(AppImages.genderPng),
                    fit: BoxFit.contain),
              ),
            ),
            imageUrl: userData?.student?.imageUrl ?? Strings.placeHolderImg,
            imageBuilder: (context, img) => Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: img, fit: BoxFit.contain),
              ),
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              radius: avatarRadius,
              backgroundColor: AppColors.kPrimary,
              child: AppText(
                userData?.student?.name?.substring(0, 1) ?? 'guest',
                style: TextStyle(
                  color: AppColors.kWhite,
                  fontSize: errorFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
