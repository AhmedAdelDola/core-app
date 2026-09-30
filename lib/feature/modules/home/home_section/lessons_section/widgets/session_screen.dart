import 'dart:io';
import 'package:elhanbly/core/widgets/purchase_modal/course_purchase_modal.dart';
import 'package:elhanbly/feature/modules/library/widgets/files_tap/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../core/security/content_protection_service.dart';
import '../../../../../../core/security/widgets/security_alert_dialogs.dart';
import '../../../../../../core/services/di.dart';
import '../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../core/util/responsive/responsive_helper.dart';
import '../../../../../../core/widgets/app_bar/custom_curved_appbar.dart';
import '../../../../../../core/widgets/app_buttons/master_button.dart';
import '../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../core/widgets/app_texts/text_scroll.dart';
import '../../../../../../core/widgets/loader/app_loader.dart';
import '../../../../../../core/widgets/ui_helpers/alert_message.dart';
import '../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../courses_section/view/course_view/course_view_widgets/course_comments_section/course_comments_widget.dart';
import '../cubit/lessons_section_cubit.dart';
import 'split_video_view/Splitview.dart';
import 'split_video_view/video_player.dart';

class SessionDetilesScreen extends StatefulWidget {
  final int id;
  final String title, subTitle;
  final bool initialOpenComments;
  final int? highlightCommentId;
  final int? highlightReplyId;

  const SessionDetilesScreen({
    super.key,
    required this.id,
    required this.title,
    required this.subTitle,
    this.initialOpenComments = false,
    this.highlightCommentId,
    this.highlightReplyId,
  });

  @override
  State<SessionDetilesScreen> createState() => _SessionDetilesScreenState();
}

class _SessionDetilesScreenState extends State<SessionDetilesScreen> {
  bool _hasOpenedInitialComments = false;

  String _formatSessionType(String? type) {
    if (type == null || type.isEmpty) return 'فيديو مسجل';
    switch (type) {
      case 'recorded_video':
        return 'فيديو مسجل';
      case 'pdf':
        return 'ملف PDF';
      case 'Homework':
      case 'quiz':
        return 'واجب / اختبار';
      case 'live':
        return 'بث مباشر';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = AppResponsive.isTabletOrLarger(context);
    final bool isLandscape = AppResponsive.isLandscape(context);
    final bool isMobileLandscape = AppResponsive.isMobileLandscape(context);
    final bool useTwoColumn = (isTablet && isLandscape) || (AppResponsive.width(context) >= 900);

    return BlocProvider(
      create: (context) => di<LessonsSectionCubit>()..getSessionInfo('${widget.id}'),
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
          if (widget.initialOpenComments && !_hasOpenedInitialComments) {
            _hasOpenedInitialComments = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                CourseCommentsWidget.showCommentsSheet(
                  context,
                  sessionId: widget.id,
                  highlightCommentId: widget.highlightCommentId,
                  highlightReplyId: widget.highlightReplyId,
                );
              }
            });
          }
        },
        builder: (context, state) {
          final cubit = LessonsSectionCubit.of(context);
          final model = cubit.getSessionModel;
          if (state is GetSubjectCoursesLoadingState && model == null) {
            return const Scaffold(
              backgroundColor: Color(0xFFF8FAFC),
              body: AppLoader(),
            );
          }

          final session = model?.session;
          final String displayTitle = session?.title?.isNotEmpty == true
              ? session!.title!
              : (widget.title.isNotEmpty ? widget.title : 'تفاصيل الحصة');
          final String displayType = _formatSessionType(session?.type ?? widget.subTitle);
          final bool canAccess = model?.canAccess ?? true;
          final String? pdfName = session?.pdf?.name;
          final bool hasPdf = session?.pdf != null;

          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: CustomAppBar(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppTextScroll(
                          displayTitle,
                          size: isMobileLandscape
                              ? 15.sp
                              : (isTablet ? 19.sp : 22.sp),
                          weight: FontWeight.w700,
                          color: AppColors.kWhite,
                          align: TextAlign.start,
                          mode: TextScrollMode.begin,
                          delayBefore: const Duration(milliseconds: 1300),
                        ),
                        if (!isMobileLandscape) ...[
                          3.sbH,
                          AppTextScroll(
                            displayType,
                            size: isTablet ? 13.sp : 13.5.sp,
                            weight: FontWeight.w400,
                            color: AppColors.kWhite.withValues(alpha: 0.85),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      CourseCommentsWidget.showCommentsSheet(
                        context,
                        sessionId: session?.id ?? widget.id,
                        highlightCommentId: widget.highlightCommentId,
                        highlightReplyId: widget.highlightReplyId,
                      );
                    },
                    icon: Container(
                      padding: EdgeInsets.all(isMobileLandscape ? 6.r : 8.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: AppColors.kWhite,
                        size: isMobileLandscape ? 16.sp : 20.sp,
                      ),
                    ),
                    tooltip: 'التعليقات',
                  ),
                ],
              ),
            ),
            body: AdaptiveContainer(
              maxWidth: ResponsiveBreakpoints.maxContentWidth,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24.w : 16.w,
                  vertical: isMobileLandscape ? 10.h : 16.h,
                ),
                child: useTwoColumn
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left column (Main info & PDF)
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildHeroCard(
                                  session: session,
                                  model: model,
                                  displayTitle: displayTitle,
                                  displayType: displayType,
                                  canAccess: canAccess,
                                  isTablet: isTablet,
                                  isMobileLandscape: isMobileLandscape,
                                ),
                                if (hasPdf) ...[
                                  12.sbH,
                                  _buildPdfCard(
                                    context: context,
                                    pdfName: pdfName,
                                    model: model,
                                    cubit: cubit,
                                    isTablet: isTablet,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          16.sbW,
                          // Right column (Comments, Discussions & Action Buttons)
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildCommentsCard(
                                  context: context,
                                  sessionId: session?.id ?? widget.id,
                                  isTablet: isTablet,
                                ),
                                14.sbH,
                                _buildActionButtons(
                                  context: context,
                                  canAccess: canAccess,
                                  hasPdf: hasPdf,
                                  model: model,
                                  session: session,
                                  cubit: cubit,
                                  isTablet: isTablet,
                                  isMobileLandscape: isMobileLandscape,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeroCard(
                            session: session,
                            model: model,
                            displayTitle: displayTitle,
                            displayType: displayType,
                            canAccess: canAccess,
                            isTablet: isTablet,
                            isMobileLandscape: isMobileLandscape,
                          ),
                          if (hasPdf) ...[
                            12.sbH,
                            _buildPdfCard(
                              context: context,
                              pdfName: pdfName,
                              model: model,
                              cubit: cubit,
                              isTablet: isTablet,
                            ),
                          ],
                          12.sbH,
                          _buildCommentsCard(
                            context: context,
                            sessionId: session?.id ?? widget.id,
                            isTablet: isTablet,
                          ),
                          // On mobile landscape, action buttons are placed inside the scroll view
                          if (isMobileLandscape) ...[
                            14.sbH,
                            _buildActionButtons(
                              context: context,
                              canAccess: canAccess,
                              hasPdf: hasPdf,
                              model: model,
                              session: session,
                              cubit: cubit,
                              isTablet: isTablet,
                              isMobileLandscape: isMobileLandscape,
                            ),
                          ],
                          20.sbH,
                        ],
                      ),
              ),
            ),
            bottomNavigationBar: isMobileLandscape
                ? null
                : Container(
                    decoration: BoxDecoration(
                      color: AppColors.kWhite,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: AdaptiveContainer(
                        maxWidth: ResponsiveBreakpoints.maxContentWidth,
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 24.w : 16.w,
                          vertical: 10.h,
                        ),
                        child: _buildActionButtons(
                          context: context,
                          canAccess: canAccess,
                          hasPdf: hasPdf,
                          model: model,
                          session: session,
                          cubit: cubit,
                          isTablet: isTablet,
                          isMobileLandscape: isMobileLandscape,
                        ),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons({
    required BuildContext context,
    required bool canAccess,
    required bool hasPdf,
    required dynamic model,
    required dynamic session,
    required LessonsSectionCubit cubit,
    required bool isTablet,
    required bool isMobileLandscape,
  }) {
    if (!canAccess) {
      return MasterButton(
        onPressed: () {
          CoursePurchaseModal.show(
            context: context,
            type: PurchaseTargetType.session,
            id: session?.id?.toString() ?? widget.id.toString(),
            title: session?.title ?? '',
            price: session?.singleSessionPrice?.toString() ?? '0',
            onSuccess: () {
              cubit.getSessionInfo(widget.id.toString());
            },
          );
        },
        text:
            'اشترك الآن (${session?.singleSessionPrice != null && session?.singleSessionPrice != '0' ? '${session?.singleSessionPrice} جنيه' : 'مجانا'})',
        margin: EdgeInsets.zero,
      );
    }

    final bool isPdfSession = session?.type == 'pdf' || model?.delivery?.type == 'pdf';

    if (isPdfSession) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _openPdf(context, model, cubit),
          icon: Icon(
            Icons.picture_as_pdf_rounded,
            size: isTablet ? 22.sp : 20.sp,
            color: AppColors.kWhite,
          ),
          label: AppText(
            'عرض ملف الـ PDF',
            size: isTablet ? 14.5.sp : 13.5.sp,
            weight: FontWeight.w700,
            color: AppColors.kWhite,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE53935),
            elevation: 0,
            padding: EdgeInsets.symmetric(
              vertical: isMobileLandscape ? 8.h : 11.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        ),
      );
    }

    final dynamic remainingViews = model?.remainingViews;
    final bool isWatchLimitReached = !isPdfSession &&
        remainingViews != null &&
        (remainingViews is int ? remainingViews <= 0 : (int.tryParse('$remainingViews') ?? 1) <= 0);

    return Row(
      children: [
        if (hasPdf) ...[
          Expanded(
            flex: 4,
            child: OutlinedButton.icon(
              onPressed: () => _openPdf(context, model, cubit),
              icon: Icon(
                Icons.picture_as_pdf_outlined,
                size: isTablet ? 18.sp : 16.sp,
                color: AppColors.kPrimary,
              ),
              label: AppText(
                'عرض الملف',
                size: isTablet ? 13.5.sp : 13.sp,
                weight: FontWeight.w700,
                color: AppColors.kPrimary,
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.kPrimary, width: 1.3),
                padding: EdgeInsets.symmetric(
                  vertical: isMobileLandscape ? 8.h : 11.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),
          10.sbW,
        ],
        Expanded(
          flex: 6,
          child: ElevatedButton.icon(
            onPressed: isWatchLimitReached
                ? () {
                    showErrorToast(
                        'لقد استنفدت عدد مرات المشاهدة المسموحة لهذه الحصة. تواصل مع المعلم لإضافة مشاهدات.');
                  }
                : () => _startWatchVideo(context, model, cubit),
            icon: Icon(
              isWatchLimitReached
                  ? Icons.lock_clock_outlined
                  : Icons.play_arrow_rounded,
              size: isTablet ? 22.sp : 20.sp,
              color: AppColors.kWhite,
            ),
            label: AppText(
              isWatchLimitReached ? 'استنفدت المشاهدات' : 'المشاهدة الآن',
              size: isTablet ? 14.5.sp : 13.5.sp,
              weight: FontWeight.w700,
              color: AppColors.kWhite,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isWatchLimitReached
                  ? const Color(0xFF64748B)
                  : AppColors.kPrimary,
              elevation: 0,
              padding: EdgeInsets.symmetric(
                vertical: isMobileLandscape ? 8.h : 11.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard({
    required dynamic session,
    required dynamic model,
    required String displayTitle,
    required String displayType,
    required bool canAccess,
    required bool isTablet,
    required bool isMobileLandscape,
  }) {
    final bool isPdfSession = session?.type == 'pdf' || model?.delivery?.type == 'pdf';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 18.w : 14.w),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type and Access Badge Row
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: isPdfSession
                      ? const Color(0xFFFDE8E8)
                      : AppColors.kPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPdfSession
                          ? Icons.picture_as_pdf_rounded
                          : Icons.play_circle_outline_rounded,
                      size: isTablet ? 14.sp : 12.sp,
                      color: isPdfSession ? const Color(0xFFE53935) : AppColors.kPrimary,
                    ),
                    4.sbW,
                    AppText(
                      displayType,
                      size: isTablet ? 11.5.sp : 10.5.sp,
                      weight: FontWeight.w600,
                      color: isPdfSession ? const Color(0xFFE53935) : AppColors.kPrimary,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: canAccess ? const Color(0xFFDCFCE7) : const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      canAccess ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
                      size: isTablet ? 13.sp : 11.sp,
                      color: canAccess ? const Color(0xFF15803D) : const Color(0xFFC2410C),
                    ),
                    4.sbW,
                    AppText(
                      canAccess
                          ? (isPdfSession ? 'متاح للعرض' : 'متاحة للمشاهدة')
                          : 'غير مشترك',
                      size: isTablet ? 11.sp : 10.sp,
                      weight: FontWeight.w700,
                      color: canAccess ? const Color(0xFF15803D) : const Color(0xFFC2410C),
                    ),
                  ],
                ),
              ),
            ],
          ),
          10.sbH,

          // Title
          AppText(
            displayTitle,
            size: isTablet ? 17.sp : 15.5.sp,
            weight: FontWeight.w700,
            color: AppColors.textColor,
            align: TextAlign.start,
          ),

          // Description if available
          if (session?.description != null &&
              session!.description!.trim().isNotEmpty) ...[
            6.sbH,
            AppText(
              session.description!.trim(),
              size: isTablet ? 13.5.sp : 12.5.sp,
              weight: FontWeight.w400,
              color: AppColors.textColor2,
              align: TextAlign.start,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          12.sbH,
          const Divider(color: Color(0xFFF1F5F9), height: 1, thickness: 1),
          10.sbH,

          // Info Chips Row
          Row(
            children: [
              if (model?.studentState?.status != null) ...[
                Expanded(
                  child: _buildInfoTile(
                    icon: Icons.verified_user_outlined,
                    label: 'حالة الحساب',
                    value: model!.studentState!.status == 'active'
                        ? 'نشط'
                        : model!.studentState!.status!,
                    color: const Color(0xFF16A34A),
                    isTablet: isTablet,
                  ),
                ),
                8.sbW,
              ],
              if (isPdfSession) ...[
                Expanded(
                  child: _buildInfoTile(
                    icon: Icons.picture_as_pdf_outlined,
                    label: 'نوع الحصة',
                    value: 'ملف PDF',
                    color: const Color(0xFFE53935),
                    isTablet: isTablet,
                  ),
                ),
              ] else ...[
                if (session?.watchedAfterPercent != null) ...[
                  Expanded(
                    child: _buildInfoTile(
                      icon: Icons.trending_up_rounded,
                      label: 'نسبة الإنجاز',
                      value: '${session!.watchedAfterPercent}%',
                      color: AppColors.kPrimary,
                      isTablet: isTablet,
                    ),
                  ),
                  8.sbW,
                ],
                if (model?.remainingViews != null) ...[
                  () {
                    final dynamic remaining = model!.remainingViews;
                    final bool isZero = remaining is int
                        ? remaining <= 0
                        : (int.tryParse('$remaining') ?? 1) <= 0;
                    return Expanded(
                      child: _buildInfoTile(
                        icon: isZero
                            ? Icons.warning_amber_rounded
                            : Icons.visibility_outlined,
                        label: 'المشاهدات المتبقية',
                        value: isZero ? '0 (استنفدت)' : '$remaining',
                        color: isZero
                            ? const Color(0xFFE53935)
                            : const Color(0xFF0284C7),
                        isTablet: isTablet,
                      ),
                    );
                  }(),
                ],
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPdfCard({
    required BuildContext context,
    required String? pdfName,
    required dynamic model,
    required LessonsSectionCubit cubit,
    required bool isTablet,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 14.w : 12.w),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: isTablet ? 44.r : 40.r,
            height: isTablet ? 44.r : 40.r,
            decoration: BoxDecoration(
              color: const Color(0xFFFDE8E8),
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.picture_as_pdf_rounded,
              color: const Color(0xFFE53935),
              size: isTablet ? 24.sp : 20.sp,
            ),
          ),
          10.sbW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  pdfName ?? 'ملف الحصة المرفق',
                  size: isTablet ? 13.5.sp : 12.5.sp,
                  weight: FontWeight.w700,
                  color: AppColors.textColor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  align: TextAlign.start,
                ),
                3.sbH,
                AppText(
                  'مستند PDF مرفق مع هذه الحصة',
                  size: isTablet ? 11.sp : 10.5.sp,
                  color: AppColors.textColor4,
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
          8.sbW,
          OutlinedButton(
            onPressed: () => _openPdf(context, model, cubit),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFE53935),
              side: const BorderSide(color: Color(0xFFE53935)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            ),
            child: AppText(
              'معاينة',
              size: isTablet ? 12.sp : 11.sp,
              weight: FontWeight.w600,
              color: const Color(0xFFE53935),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsCard({
    required BuildContext context,
    required int sessionId,
    required bool isTablet,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 14.w : 12.w),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.kPrimary.withValues(alpha: 0.25),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimary.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: isTablet ? 44.r : 40.r,
            height: isTablet ? 44.r : 40.r,
            decoration: BoxDecoration(
              color: AppColors.kPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.forum_rounded,
              color: AppColors.kPrimary,
              size: isTablet ? 22.sp : 20.sp,
            ),
          ),
          10.sbW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'التعليقات والمناقشات',
                  size: isTablet ? 14.sp : 13.sp,
                  weight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
                3.sbH,
                AppText(
                  'اسأل المحاضر وشارك استفساراتك حول الحصة',
                  size: isTablet ? 11.sp : 10.5.sp,
                  color: AppColors.textColor4,
                ),
              ],
            ),
          ),
          8.sbW,
          ElevatedButton(
            onPressed: () {
              CourseCommentsWidget.showCommentsSheet(
                context,
                sessionId: sessionId,
                highlightCommentId: widget.highlightCommentId,
                highlightReplyId: widget.highlightReplyId,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  'عرض',
                  size: isTablet ? 12.sp : 11.sp,
                  weight: FontWeight.w700,
                  color: AppColors.kWhite,
                ),
                4.sbW,
                Icon(Icons.arrow_forward_ios_rounded,
                    size: isTablet ? 10.sp : 9.sp, color: AppColors.kWhite),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isTablet = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: isTablet ? 13.sp : 12.sp, color: color),
              3.sbW,
              Flexible(
                child: AppText(
                  label,
                  size: isTablet ? 10.sp : 9.5.sp,
                  color: AppColors.textColor4,
                  weight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          3.sbH,
          AppText(
            value,
            size: isTablet ? 12.sp : 11.sp,
            weight: FontWeight.w700,
            color: color,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Future<void> _openPdf(BuildContext context, dynamic model, LessonsSectionCubit cubit) async {
    String? finalPdfUrl = model?.session?.pdf?.url;
    if (finalPdfUrl == null || finalPdfUrl.isEmpty) {
      if (model?.delivery?.payload is Map && model?.delivery?.payload?['url'] != null) {
        finalPdfUrl = model?.delivery?.payload?['url']?.toString();
      }
    }
    if (Platform.isAndroid && di.isRegistered<ContentProtectionService>()) {
      try {
        final contentProtection = di<ContentProtectionService>();
        final access = await contentProtection.requestPdfAccess(
          sessionId: model?.session?.id ?? widget.id,
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
    if (!context.mounted) return;
    if (finalPdfUrl == null || finalPdfUrl.isEmpty) {
      showErrorToast('لم يتم العثور على رابط ملف الـ PDF');
      return;
    }
    NamedNavigatorImpl.push(PdfViewers(
      pdfurl: finalPdfUrl,
      name: model?.session?.pdf?.name ?? model?.session?.title ?? 'ملف الحصة',
    ));
  }

  Future<void> _startWatchVideo(BuildContext context, dynamic model, LessonsSectionCubit cubit) async {
    await cubit.getvideo('${model?.session?.id}');
    final models = cubit.ShowVideoModel;
    if (!context.mounted) return;
    if (models == null || models.playerUrl == null || models.playerUrl!.isEmpty) {
      return;
    }
    bool isTablet = MediaQuery.of(context).size.width >= 600;
    if (isTablet) {
      await NamedNavigatorImpl.push(SplitViewScreen(
        model: models,
        pdfUrl: model?.session?.pdf?.url ?? '',
        pdfname: model?.session?.pdf?.name ?? '',
        sessionId: model?.session?.id ?? widget.id,
      ));
    } else {
      await NamedNavigatorImpl.push(VideoPlayer(
        model: models,
        sessionId: model?.session?.id ?? widget.id,
      ));
    }
    if (context.mounted) {
      cubit.getSessionInfo('${widget.id}');
    }
  }
}
