part of '../../library_imports.dart';

class CoursesTab extends StatelessWidget {
  const CoursesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = AppResponsive.isTablet(context);
    final bool isDesktop = AppResponsive.isDesktop(context);
    final bool isLargeScreen = AppResponsive.isTabletOrLarger(context);
    final int crossAxisCount = AppResponsive.gridColumns(
      context,
      mobile: 1,
      tabletPortrait: 3,
      tabletLandscape: 4,
      desktop: 4,
    );

    return BlocProvider<LibraryCubit>(
      create: (context) => di<LibraryCubit>()..getLibraryCourses(),
      child: BlocBuilder<LibraryCubit, LibraryState>(
        builder: (context, state) {
          final cubit = LibraryCubit.of(context);
          final libraryCourses = cubit.libraryCourses?.courses;
          if (state is GetLibraryCoursesLoadingState) return const AppLoader();
          if (cubit.libraryCourses?.courses?.isEmpty ?? true) {
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 180.h,
                      child: LottieBuilder.asset(AppJsonFiles.emptyState),
                    ),
                    16.sbH,
                    AppText(
                      'لا توجد كورسات في مكتبتك بعد',
                      style: TextStyles.textViewBold(
                        size: 18.sp,
                        color: AppColors.textColor,
                      ),
                    ),
                    8.sbH,
                    AppText(
                      'اشترك في الكورسات المتاحة لتتمكن من متابعتها ومراجعتها في أي وقت.',
                      style: TextStyles.textViewRegular(
                        fontSize: 14.sp,
                        color: AppColors.textColor3,
                      ),
                      align: TextAlign.center,
                    ),
                    24.sbH,
                    ElevatedButton.icon(
                      onPressed: () {
                        BottomBarCubit.of(context).updatePageIndex(0);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kPrimary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 2,
                      ),
                      icon: const Icon(Icons.explore_outlined, color: Colors.white),
                      label: AppText(
                        'استكشف الكورسات',
                        color: Colors.white,
                        size: 14.sp,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return isLargeScreen
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    final horizontalPadding = isDesktop ? 48.0 : 32.0;
                    final spacing = isDesktop ? 20.0 : 16.0;
                    final cardWidth =
                        (constraints.maxWidth -
                            horizontalPadding -
                            (crossAxisCount - 1) * spacing) /
                        crossAxisCount;

                    return GridView.builder(
                      padding: EdgeInsets.all(isDesktop ? 24 : 16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                        mainAxisExtent: cardWidth * (9 / 16) + 140.h,
                      ),
                      itemCount: libraryCourses?.length ?? 0,
                      itemBuilder: (_, i) {
                        final model = libraryCourses![i];
                        final bool hasStageOrLevel =
                            (model.stage?.name != null && model.stage!.name!.isNotEmpty) ||
                            (model.level?.name != null && model.level!.name!.isNotEmpty);
                        final String stageLevelText = [
                          if (model.stage?.name != null && model.stage!.name!.isNotEmpty)
                            model.stage!.name!,
                          if (model.level?.name != null && model.level!.name!.isNotEmpty)
                            model.level!.name!,
                        ].join(' • ');

                        return GestureDetector(
                          onTap: () {
                            NamedNavigatorImpl.push(
                              CourseViewScreen(id: "${model.id ?? 0}"),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.kWhite,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: AppColors.borderColor.withOpacity(0.55),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(14.r),
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: (model.imageUrl == 'https://apluscore.com/media/images/logo.png' ||
                                                (model.imageUrl != null && model.imageUrl!.endsWith('logo.png')) ||
                                                model.imageUrl == null ||
                                                model.imageUrl!.isEmpty)
                                            ? Container(
                                                color: const Color(0xFFF8FAFC),
                                                padding: const EdgeInsets.all(16),
                                                child: Image.asset(AppImages.logoPng, fit: BoxFit.contain),
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: model.imageUrl!,
                                                fit: BoxFit.cover,
                                                placeholder: (_, __) => Container(color: const Color(0xFFF1F5F9)),
                                                errorWidget: (_, __, ___) => Container(
                                                  color: const Color(0xFFF8FAFC),
                                                  padding: const EdgeInsets.all(16),
                                                  child: Image.asset(AppImages.logoPng, fit: BoxFit.contain),
                                                ),
                                              ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8.h,
                                      left: 8.w,
                                      right: 8.w,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF10B981),
                                              borderRadius: BorderRadius.circular(16.r),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.check_circle_rounded, color: Colors.white, size: 11.sp),
                                                3.sbW,
                                                AppText('مشترك', color: Colors.white, size: 10.sp, weight: FontWeight.bold),
                                              ],
                                            ),
                                          ),
                                          if (hasStageOrLevel)
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.65),
                                                borderRadius: BorderRadius.circular(16.r),
                                              ),
                                              child: AppText(
                                                stageLevelText,
                                                color: Colors.white,
                                                size: 10.sp,
                                                weight: FontWeight.w600,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(isDesktop ? 14 : 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          model.title ?? '',
                                          size: isDesktop ? 15.sp : 14.sp,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          color: AppColors.textColor,
                                          weight: FontWeight.bold,
                                          align: TextAlign.start,
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(50),
                                              child: CachedNetworkImage(
                                                imageUrl: model.teacher?.imageUrl ?? '',
                                                height: isDesktop ? 28.h : 24.h,
                                                width: isDesktop ? 28.w : 24.w,
                                                fit: BoxFit.cover,
                                                errorWidget: (_, __, ___) => Image.asset(AppImages.genderPng, fit: BoxFit.cover),
                                              ),
                                            ),
                                            8.sbW,
                                            Expanded(
                                              child: AppText(
                                                model.teacher?.name ?? '',
                                                maxLines: 1,
                                                size: isDesktop ? 13.sp : 12.sp,
                                                align: TextAlign.start,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyles.textViewMedium(
                                                  color: AppColors.textColor5,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                              decoration: BoxDecoration(
                                                color: AppColors.kPrimary,
                                                borderRadius: BorderRadius.circular(8.r),
                                              ),
                                              child: AppText('متابعة', color: Colors.white, size: 11.sp, weight: FontWeight.bold),
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
                    );
                  },
                )
              : ListView.separated(
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    top: 4.h,
                    bottom: 96.h,
                  ),
                  itemCount: libraryCourses?.length ?? 0,
                  separatorBuilder: (_, __) => 16.sbH,
                  itemBuilder: (context, i) {
                    final model = libraryCourses![i];
                    final bool hasStageOrLevel =
                        (model.stage?.name != null && model.stage!.name!.isNotEmpty) ||
                        (model.level?.name != null && model.level!.name!.isNotEmpty);
                    final String stageLevelText = [
                      if (model.stage?.name != null && model.stage!.name!.isNotEmpty)
                        model.stage!.name!,
                      if (model.level?.name != null && model.level!.name!.isNotEmpty)
                        model.level!.name!,
                    ].join(' • ');

                    return GestureDetector(
                      onTap: () {
                        NamedNavigatorImpl.push(
                          CourseViewScreen(id: "${model.id ?? 0}"),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.kWhite,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.borderColor.withOpacity(0.55),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Banner with Overlays
                            Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16.r),
                                    ),
                                    child: (model.imageUrl == 'https://apluscore.com/media/images/logo.png' ||
                                            (model.imageUrl != null && model.imageUrl!.endsWith('logo.png')) ||
                                            model.imageUrl == null ||
                                            model.imageUrl!.isEmpty)
                                        ? Container(
                                            color: const Color(0xFFF8FAFC),
                                            padding: EdgeInsets.all(20.w),
                                            child: Image.asset(AppImages.logoPng, fit: BoxFit.contain),
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: model.imageUrl!,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Container(
                                              color: const Color(0xFFF1F5F9),
                                              child: const Center(
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                              ),
                                            ),
                                            errorWidget: (context, url, error) => Container(
                                              color: const Color(0xFFF8FAFC),
                                              padding: EdgeInsets.all(20.w),
                                              child: Image.asset(AppImages.logoPng, fit: BoxFit.contain),
                                            ),
                                          ),
                                  ),
                                ),
                                // Subtle top gradient
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  height: 60.h,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16.r),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.45),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Badges
                                Positioned(
                                  top: 10.h,
                                  left: 12.w,
                                  right: 12.w,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 5.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981),
                                          borderRadius: BorderRadius.circular(20.r),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.check_circle_rounded,
                                              color: Colors.white,
                                              size: 13.sp,
                                            ),
                                            5.sbW,
                                            AppText(
                                              'مشترك',
                                              color: Colors.white,
                                              size: 11.sp,
                                              weight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (hasStageOrLevel)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 5.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.65),
                                            borderRadius: BorderRadius.circular(20.r),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.school_outlined,
                                                size: 13.sp,
                                                color: Colors.white,
                                              ),
                                              5.sbW,
                                              AppText(
                                                stageLevelText,
                                                color: Colors.white,
                                                size: 11.sp,
                                                weight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Card Content
                            Padding(
                              padding: EdgeInsets.all(14.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  AppText(
                                    model.title ?? '',
                                    style: TextStyles.textViewBold(
                                      size: 16.sp,
                                      color: AppColors.textColor,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    align: TextAlign.start,
                                  ),
                                  12.sbH,
                                  Divider(
                                    color: AppColors.borderColor.withOpacity(0.4),
                                    height: 1,
                                  ),
                                  12.sbH,
                                  // Teacher & Action
                                  Row(
                                    children: [
                                      Container(
                                        width: 36.w,
                                        height: 36.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.kPrimary.withOpacity(0.25),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: model.teacher?.imageUrl ?? '',
                                            fit: BoxFit.cover,
                                            placeholder: (_, __) => Container(
                                              color: const Color(0xFFF1F5F9),
                                            ),
                                            errorWidget: (_, __, ___) => Image.asset(
                                              AppImages.genderPng,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      10.sbW,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              'المحاضر',
                                              style: TextStyles.textViewRegular(
                                                fontSize: 10.sp,
                                                color: AppColors.textColor4,
                                              ),
                                              align: TextAlign.start,
                                            ),
                                            AppText(
                                              model.teacher?.name ?? 'غير محدد',
                                              style: TextStyles.textViewMedium(
                                                fontSize: 13.sp,
                                                color: AppColors.textColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              align: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                      ),
                                      10.sbW,
                                      // "متابعة الكورس" Button
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 14.w,
                                          vertical: 9.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.kPrimary,
                                          borderRadius: BorderRadius.circular(10.r),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.kPrimary.withOpacity(0.25),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AppText(
                                              'متابعة الكورس',
                                              color: Colors.white,
                                              size: 12.sp,
                                              weight: FontWeight.bold,
                                            ),
                                            6.sbW,
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 11.sp,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
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
