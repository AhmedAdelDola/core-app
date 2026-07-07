part of '../../library_imports.dart';

class CoursesTab extends StatelessWidget {
  const CoursesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1000;
    final bool isDesktop = screenWidth >= 1000;
    final bool isLargeScreen = isTablet || isDesktop;

    // Determine grid columns based on screen size
    int crossAxisCount = 1;
    if (isDesktop) {
      crossAxisCount = 4;
    } else if (isTablet) {
      crossAxisCount = 3;
    }

    return BlocProvider<LibraryCubit>(
      create: (context) => di<LibraryCubit>()..getLibraryCourses(),
      child: BlocBuilder<LibraryCubit, LibraryState>(
        builder: (context, state) {
          final cubit = LibraryCubit.of(context);
          final libraryCourses = cubit.libraryCourses?.courses;
          if (state is GetLibraryCoursesLoadingState) return const AppLoader();
          if(cubit.libraryCourses?.courses?.isEmpty ?? true) {
            return LottieBuilder.asset( 
                AppJsonFiles.emptyState
            );
          }
          return isLargeScreen
              ? GridView.builder(
                  padding: EdgeInsets.all(isDesktop ? 24 : 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.67,
                    crossAxisSpacing: isDesktop ? 20 : 16,
                    mainAxisSpacing: isDesktop ? 20 : 16,
                  ),
                  itemCount: libraryCourses?.length ?? 0,
                  itemBuilder: (_, i) {
                    final model = libraryCourses![i];
                    return GestureDetector(
                      onTap: () {
                        NamedNavigatorImpl.push(
                          CourseViewScreen(id:  "${model.id ?? 0}"),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 12,
                                    child: NetworkImagesWidgets(
                                        url: model.imageUrl ?? '',
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                // if (model.isFree == 1)
                                //   Positioned(
                                //     bottom: 8,
                                //     right: 8,
                                //     child: Container(
                                //       padding: EdgeInsets.symmetric(
                                //           horizontal: 12.w, vertical: 6.h),
                                //       decoration: BoxDecoration(
                                //         color: AppColors.kPrimary,
                                //         borderRadius: BorderRadius.circular(8),
                                //       ),
                                //       child: AppText(
                                //         'مجاني',
                                //         color: Colors.white,
                                //         size: isDesktop ? 13.sp : 12.sp,
                                //       ),
                                //     ),
                                //   ),
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(isDesktop ? 14 : 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                     
                                        // Row(
                                        //   children: [
                                        //     AppRatingBar(
                                        //       size: isDesktop ? 15.sp : 14.sp,
                                        //       initialRating: double.tryParse(
                                        //           '${model.rating?.rate ?? 0.0}'),
                                        //       onRatingUpdate: null,
                                        //     ),
                                        //     SizedBox(width: isDesktop ? 7 : 6),
                                        //     Flexible(
                                        //       child: AppText(
                                        //         '${model.rating?.rate ?? 0.0} (${model.rating?.raters ?? 0.0})',
                                        //         textDirection:
                                        //             TextDirection.ltr,
                                        //         size: isDesktop ? 12.sp : 11.sp,
                                        //         style:
                                        //             TextStyles.textViewMedium(
                                        //           color: AppColors.textColor5,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                     
                                        SizedBox(
                                            height: isDesktop ? 10.h : 8.h),
                                        AppText(
                                          model.title ?? '',
                                          size: isDesktop ? 15.sp : 14.sp,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          color: AppColors.textColor,
                                          centerText: false,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: isDesktop ? 10.h : 8.h),
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadiusGeometry.circular(50),
                                          child: NetworkImagesWidgets(
                                            url: model.teacher?.imageUrl,
                                            height: isDesktop ? 26.h : 24.h,
                                            width: isDesktop ? 26.w : 24.w,
                                          ),
                                        ),
                                        SizedBox(width: isDesktop ? 10.w : 8.w),
                                        Expanded(
                                          child: AppText(
                                            model.teacher?.name ?? '',
                                            maxLines: 1,
                                            size: isDesktop ? 13.sp : 12.sp,
                                            align: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyles.textViewMedium(
                                                color: AppColors.textColor5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : ListView.builder(
                  itemCount: libraryCourses?.length ?? 0,
                  itemBuilder: (_, i) {
                    final model = libraryCourses![i];
                    return GestureDetector(
                      onTap: () {
                        NamedNavigatorImpl.push(
                          CourseViewScreen(id: "${model.id ?? 0}"),
                        );
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.90,
                          height: MediaQuery.of(context).size.width * 0.77,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FloatingTextOnImg(
                                  img: '${model.imageUrl}',
                                  isFree:  0,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 12.w, top: 20.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      // Row(
                                      //   children: [
                                      //     AppRatingBar(
                                      //       size: 20,
                                      //       initialRating: double.tryParse(
                                      //           '${model.rating?.rate ?? 0.0}'),
                                      //       onRatingUpdate: null,
                                      //     ),
                                      //     8.sbW,
                                      //     AppText(
                                      //       '${model.rating?.rate ?? 0.0} (${model.rating?.raters ?? 0.0})',
                                      //       textDirection: TextDirection.ltr,
                                      //       style: TextStyles.textViewMedium(
                                      //         color: AppColors.textColor5,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                     
                                      5.sbH,
                                      AppTextScroll(
                                        model.title ?? '',
                                        size: 18.sp,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        color: AppColors.textColor,
                                        centerText: false,
                                      ),
                                      5.sbH,
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadiusGeometry.circular(50),
                                            child: NetworkImagesWidgets(
                                              url: model.teacher?.imageUrl ?? '',
                                              height: 32.h,
                                              width: 32.w,
                                            ),
                                          ),
                                          8.sbW,
                                          AppText(
                                            model.teacher?.name ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyles.textViewMedium(
                                                color: AppColors.textColor5),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
