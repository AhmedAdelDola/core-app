import '../../../../../../../../core/consts/images.dart';
import '../../../../../../../../core/consts/strings.dart';
import '../../../../../../../../core/widgets/network_img.dart';
import '../../../cubit/courses_section_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotSubscribeSlider extends StatefulWidget {
  const NotSubscribeSlider({super.key});

  @override
  State<NotSubscribeSlider> createState() => _NotSubscribeSliderState();
}

class _NotSubscribeSliderState extends State<NotSubscribeSlider> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesSectionCubit, CoursesSectionState>(
      builder: (context, state) {
        final cubit = CoursesSectionCubit.of(context);
        final model = cubit.courseData;
        return CarouselSlider(
          carouselController: cubit.controller,
          options: CarouselOptions(
            height: 414.h,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
            onPageChanged: cubit.changeIndex,
          ),
          items: List.generate(
            model?.course?.chapters?.length ?? 0,
            (i) => SizedBox(
              height: 414.h,
              width: double.infinity,
              child: model?.course?.imageUrl?[i] ==
                      'https://apluscore.com/media/images/logo.png'
                  ? Image.asset(AppImages.logoPng, fit: BoxFit.fill)
                  : CachedNetworkImage(
                      imageUrl: model?.course?.imageUrl ?? Strings.placeHolderImg,
                      fit: BoxFit.fill,
                      errorWidget: errorIconImage,
                      progressIndicatorBuilder: (c, _, __) =>
                          const LoadingImage(),
                    ),
            ),
          ),
        );
      },
    );
  }
}
