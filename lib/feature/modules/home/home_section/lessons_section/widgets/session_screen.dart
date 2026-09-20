import 'dart:io';
import 'package:elhanbly/core/widgets/purchase_modal/course_purchase_modal.dart';
import 'package:elhanbly/feature/modules/library/widgets/files_tap/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/consts/images.dart';
import '../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../core/security/content_protection_service.dart';
import '../../../../../../core/security/widgets/security_alert_dialogs.dart';
import '../../../../../../core/services/di.dart';
import '../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../core/widgets/app_bar/custom_curved_appbar.dart';
import '../../../../../../core/widgets/app_buttons/custom_button.dart';
import '../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../core/widgets/app_texts/text_scroll.dart';
import '../../../../../../core/widgets/loader/app_loader.dart';
import '../../../../../../core/widgets/ui_helpers/alert_message.dart';
import '../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../courses_section/view/course_view/course_view_widgets/course_lessons_section/lesson_profile/lesson_profile_item.dart';
import '../cubit/lessons_section_cubit.dart';
import 'split_video_view/Splitview.dart';
import '../../../../../../core/widgets/app_buttons/master_button.dart';
import 'split_video_view/video_player.dart';

class SessionDetilesScreen extends StatelessWidget {
  final int id;
  final String title, subTitle;

  const SessionDetilesScreen(
      {super.key,
      required this.id,
      required this.title,
      required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<LessonsSectionCubit>()..getSessionInfo('$id'),
      child: BlocConsumer<LessonsSectionCubit, LessonsSectionState>(
        listener: (context, state) {
          if (state is GetSubjectCoursesErrorState) {
            final err = state.error;
            if (err.contains('MOBILE_APP_UPDATE_REQUIRED') || err.contains('426')) {
              SecurityAlertDialogs.showUpdateRequiredDialog(context);
            } else if (err.contains('DEVICE_NOT_TRUSTED') ||
                err.contains('APP_INTEGRITY_FAILED') ||
                err.contains('DEVICE_REVOKED')) {
              SecurityAlertDialogs.showDeviceNotTrustedDialog(context);
            } else {
              showErrorToast(err);
            }
          }
        },
        builder: (context, state) {
          final cubit = LessonsSectionCubit.of(context);
          final model = cubit.getSessionModel;
          if (state is GetSubjectCoursesLoadingState && model == null)
            return Scaffold(body: const AppLoader());

          return Scaffold(
            appBar: CustomAppBar(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextScroll(
                    title,
                    size: 28.sp,
                    weight: w500,
                    color: AppColors.kWhite,
                    align: TextAlign.start,
                    mode: TextScrollMode.begin,
                    delayBefore: Duration(milliseconds: 1300),
                  ),
                  AppTextScroll(
                    subTitle,
                    size: 20.sp,
                    weight: w400,
                    color: AppColors.kWhite,
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.sbH,
                    AppText(
                      'تفاصيل الملف',
                      size: 20.sp,
                      align: TextAlign.start,
                      weight: w500,
                      color: AppColors.textColor,
                    ),
                    14.sbH,
                    AppText(
                      model?.session?.description ?? '',
                      size: 16.sp,
                      align: TextAlign.start,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      weight: w400,
                      color: AppColors.textColor2,
                    ),
                    16.sbH,
                    const Divider(thickness: 1.5),
                    20.sbH,
                    AppText(
                      'تفاصيل الدرس',
                      size: 20.sp,
                      align: TextAlign.start,
                      weight: w500,
                      color: AppColors.textColor,
                    ),
                    14.sbH,
                    AppText(
                      model?.session?.title ?? '',
                      size: 16.sp,
                      align: TextAlign.start,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      weight: w400,
                      color: AppColors.textColor2,
                    ),
                    20.sbH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LessonProfileItem(
                          title: 'الحاله',
                          subTitle: model?.studentState?.status  ?? '',
                          icon: AppImages.alertCircle,
                          
                        ),
                        // LessonProfileItem(
                        //   title: 'التقدم',
                        //   subTitle: '${model?. ?? 0} %',
                        //   icon: AppImages.medalStar,
                        // ),
                        // LessonProfileItem(
                        //   title: 'النقاط',
                        //   subTitle: model?.point.toString() ?? '',
                        //   icon: AppImages.ranking,
                        // ),
                      ],
                    ),
                    20.sbH,
                    // LessonProfileItem(
                    //   title: 'مدة الحصه',
                    //   subTitle: model?.session?.lesson..toString() ?? '0',
                    //   icons: Icon(
                    //     Icons.timer,
                    //     color: AppColors.kPrimary,
                    //   ),
                    // ),
                    // 16.sbH,
                    const Divider(thickness: 1.5),
                    20.sbH,
                    LessonProfileItem(
                      title: 'تاريخ اخر مشاهده',
                      subTitle: '${model?.session?.watchedAfterSeconds ?? ''}',
                      icons: Icon(
                        Icons.date_range_sharp,
                        color: AppColors.kPrimary,
                      ),
                    ),
                    16.sbH,
                    const Divider(thickness: 1.5),
                    20.sbH,
                    Row(
                      children: [
                        // LessonProfileItem(
                        //   title: ' عدد مشاهدات الطالب',
                        //   subTitle: model?.session..toString() ?? '0',
                        //   icons: Icon(
                        //     Icons.pause_circle_outline_rounded,
                        //     color: AppColors.kPrimary,
                        //   ),
                        // ),
                        if(model?.session?.pdf != null)
                        LessonProfileItem(
                          title: 'الملف',
                          subTitle: model?.session?.pdf?.name  ?? '',
                          icons: Icon(
                            Icons.pause_circle_outline_rounded,
                            color: AppColors.kPrimary,
                          ),
                        ),
                        
                      ],
                    ),
                    20.sbH,
                    // AppText(
                    //   'تفاصيل المدرس',
                    //   size: 20.sp,
                    //   align: TextAlign.start,
                    //   weight: w500,
                    //   color: AppColors.textColor,
                    // ),
                    // 14.sbH,
                    // CourseInstructor(
                    //   avatar: model?.teacher?.avatar.toString() ??
                    //       Strings.placeHolderImg,
                    //   name: model?.teacher?.name ?? '',
                    //   telegram: model?.teacher?.telegram ?? '',
                    //   whatsapp: model?.teacher?.whatsapp ?? '',
                    // ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: model?.canAccess == true
                ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    spacing: 8,
                    children: [
                      if(model?.session?.pdf != null)
                          Expanded(
                            child: CustomButton(
                                          text: 'عرض الملف',
                                          onTap: () async {
                                            String? finalPdfUrl = model?.session?.pdf?.url;
                                            if (Platform.isAndroid && di.isRegistered<ContentProtectionService>()) {
                                              try {
                                                final contentProtection = di<ContentProtectionService>();
                                                final access = await contentProtection.requestPdfAccess(
                                                  sessionId: model?.session?.id ?? id,
                                                  fallbackUrl: finalPdfUrl,
                                                );
                                                if (access.pdfUrl != null && access.pdfUrl!.isNotEmpty) {
                                                  finalPdfUrl = access.pdfUrl;
                                                }
                                              } catch (e) {
                                                final err = e.toString();
                                                if (!context.mounted) return;
                                                if (err.contains('MOBILE_APP_UPDATE_REQUIRED') || err.contains('426')) {
                                                  SecurityAlertDialogs.showUpdateRequiredDialog(context);
                                                  return;
                                                } else if (err.contains('DEVICE_NOT_TRUSTED') ||
                                                    err.contains('APP_INTEGRITY_FAILED') ||
                                                    err.contains('DEVICE_REVOKED')) {
                                                  SecurityAlertDialogs.showDeviceNotTrustedDialog(context);
                                                  return;
                                                }
                                              }
                                            }
                                            NamedNavigatorImpl.push(
                                                PdfViewers(pdfurl: finalPdfUrl, name: model?.session?.pdf?.name));
                                          },
                                        ),
                          ),
                             
                      Expanded(
                        child: CustomButton(
                          text: 'المشاهده الان',
                          onTap: () async {
                            await cubit.getvideo('${model?.session?.id}');
                            final models = cubit.ShowVideoModel;
                            if (!context.mounted) return;
                            bool isTablet = MediaQuery.of(context).size.width >= 600;
                            if(isTablet){
                            NamedNavigatorImpl.push(SplitViewScreen(model: models,pdfUrl: model?.session?.pdf?.url ?? '',pdfname: model?.session?.pdf?.name ?? '',
                            ));
                            }else{
                              NamedNavigatorImpl.push(VideoPlayer(model: models));
                            }
                            
                          },
                        ),
                      ),
                    ],
                  ),
                )
                : MasterButton(
                    onPressed: () {
                      CoursePurchaseModal.show(
                        context: context,
                        type: PurchaseTargetType.session,
                        id: model?.session?.id?.toString() ?? id.toString(),
                        title: model?.session?.title ?? '',
                        price: model?.session?.singleSessionPrice?.toString() ?? '0',
                        onSuccess: () {
                          cubit.getSessionInfo(id.toString());
                        },
                      );
                    },
                    text:
                        '  اشترك الان (${model?.session?.singleSessionPrice != null && model?.session?.singleSessionPrice != '0' && model?.session?.singleSessionPrice != 0 ? '${model?.session?.singleSessionPrice} جنيه' : 'مجانا'}  )',
                    margin: EdgeInsets.all(25.sp),
                  ),
          );
        },
      ),
    );
  }
}
