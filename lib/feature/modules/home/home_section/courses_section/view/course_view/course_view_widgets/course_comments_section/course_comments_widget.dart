import 'package:elhanbly/core/services/di.dart';
import 'package:elhanbly/core/theme/colors/app_colors.dart';
import 'package:elhanbly/core/widgets/app_texts/app_text.dart';
import 'package:elhanbly/core/widgets/loader/app_loader.dart';
import 'package:elhanbly/core/widgets/ui_helpers/alert_message.dart';
import 'package:elhanbly/core/widgets/ui_helpers/extensions.dart';
import 'package:elhanbly/feature/modules/home/home_section/courses_section/cubit/course_comments_cubit.dart';
import 'package:elhanbly/feature/modules/home/home_section/courses_section/cubit/course_comments_state.dart';
import 'package:elhanbly/models/home_entities/courses/course_comments_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'course_comment_card.dart';
import 'course_comment_input.dart';
import 'course_edit_comment_dialog.dart';

typedef SessionCommentsWidget = CourseCommentsWidget;

class CourseCommentsWidget extends StatefulWidget {
  final dynamic sessionId;
  dynamic get courseId => sessionId;
  final int? highlightCommentId;
  final int? highlightReplyId;
  final VoidCallback? onSubscribeRequested;

  const CourseCommentsWidget({
    super.key,
    dynamic sessionId,
    dynamic courseId,
    this.highlightCommentId,
    this.highlightReplyId,
    this.onSubscribeRequested,
  }) : sessionId = sessionId ?? courseId;

  static void showCommentsSheet(
    BuildContext context, {
    dynamic sessionId,
    dynamic courseId,
    int? highlightCommentId,
    int? highlightReplyId,
    VoidCallback? onSubscribeRequested,
  }) {
    final targetId = sessionId ?? courseId;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              Expanded(
                child: CourseCommentsWidget(
                  sessionId: targetId,
                  highlightCommentId: highlightCommentId,
                  highlightReplyId: highlightReplyId,
                  onSubscribeRequested: onSubscribeRequested,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  State<CourseCommentsWidget> createState() => _CourseCommentsWidgetState();
}

class _CourseCommentsWidgetState extends State<CourseCommentsWidget> {
  late final CourseCommentsCubit _cubit;
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolledToHighlight = false;

  @override
  void initState() {
    super.initState();
    _cubit = di<CourseCommentsCubit>(param1: widget.sessionId)..getComments();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cubit.loadMoreComments();
    }
  }

  void _checkScrollToHighlight(List<CourseCommentItem> comments) {
    if (_hasScrolledToHighlight || widget.highlightCommentId == null) return;

    final index = comments.indexWhere(
      (e) =>
          e.id == widget.highlightCommentId ||
          (widget.highlightReplyId != null &&
              e.replies.any((r) => r.id == widget.highlightReplyId)),
    );

    if (index != -1) {
      _hasScrolledToHighlight = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          final targetOffset = (index * 130.0).clamp(
            0.0,
            _scrollController.position.maxScrollExtent,
          );
          _scrollController.animateTo(
            targetOffset,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _showDeleteDialog(int commentId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: AppColors.kRed, size: 22.sp),
            8.sbW,
            AppText('حذف التعليق', size: 15.sp, weight: FontWeight.w700),
          ],
        ),
        content: AppText(
          'هل أنت متأكد من رغبتك في حذف هذا التعليق نهائياً؟',
          size: 13.sp,
          color: AppColors.textColor2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: AppText('إلغاء', size: 13.sp, color: AppColors.textColor4),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _cubit.deleteComment(commentId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kRed,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            child: AppText('حذف', size: 13.sp, weight: FontWeight.w700, color: AppColors.kWhite),
          ),
        ],
      ),
    );
  }

  void _showForbiddenDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Row(
          children: [
            Icon(Icons.lock_outline_rounded, color: AppColors.kPrimary, size: 22.sp),
            8.sbW,
            AppText('تنبيه الاشتراك', size: 15.sp, weight: FontWeight.w700),
          ],
        ),
        content: AppText(
          message,
          size: 13.sp,
          color: AppColors.textColor2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: AppText('حسناً', size: 13.sp, color: AppColors.textColor4),
          ),
          if (widget.onSubscribeRequested != null)
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                widget.onSubscribeRequested!();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              child: AppText('اشترك الآن', size: 13.sp, weight: FontWeight.w700, color: AppColors.kWhite),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<CourseCommentsCubit, CourseCommentsState>(
        listener: (context, state) {
          if (state is AddCommentErrorState) {
            if (state.isForbidden) {
              _showForbiddenDialog(state.message);
            } else {
              showErrorToast(state.message);
            }
          } else if (state is AddCommentSuccessState) {
            showToast('تمت إضافة التعليق بنجاح');
          } else if (state is EditCommentErrorState) {
            showErrorToast(state.message);
          } else if (state is EditCommentSuccessState) {
            showToast('تم تعديل التعليق بنجاح');
          } else if (state is DeleteCommentErrorState) {
            showErrorToast(state.message);
          } else if (state is DeleteCommentSuccessState) {
            showToast('تم حذف التعليق');
          }
        },
        builder: (context, state) {
          final comments = _cubit.comments;
          final bool isInitialLoading = state is CourseCommentsLoadingState && comments.isEmpty;
          final bool isSubmitting = state is AddCommentLoadingState;

          if (isInitialLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: AppLoader(),
              ),
            );
          }

          if (state is CourseCommentsErrorState && comments.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline_rounded, size: 48.sp, color: AppColors.kRed),
                    12.sbH,
                    AppText(
                      state.message,
                      size: 14.sp,
                      color: AppColors.textColor2,
                      centerText: true,
                    ),
                    16.sbH,
                    ElevatedButton(
                      onPressed: () => _cubit.getComments(isRefresh: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      ),
                      child: AppText('إعادة المحاولة', size: 13.sp, color: AppColors.kWhite),
                    ),
                  ],
                ),
              ),
            );
          }

          _checkScrollToHighlight(comments);

          return Stack(
            children: [
              Column(
                children: [
                  // Comments count header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          'التعليقات (${_cubit.total})',
                          size: 15.sp,
                          weight: FontWeight.w700,
                          color: AppColors.textColor,
                        ),
                        if (_cubit.comments.any((e) => e.isPinned))
                          Row(
                            children: [
                              Icon(Icons.push_pin_rounded, size: 13.sp, color: const Color(0xFFB78103)),
                              4.sbW,
                              AppText(
                                'المثبت بالأعلى',
                                size: 11.sp,
                                color: const Color(0xFFB78103),
                                weight: FontWeight.w600,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  // Comment Input bar at top for immediate visibility
                  CourseCommentInput(
                    isLoading: isSubmitting,
                    onSubmit: (text) => _cubit.addComment(text),
                  ),

                  // Comments List
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => _cubit.getComments(isRefresh: true),
                      color: AppColors.kPrimary,
                      child: comments.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.all(24.r),
                              children: [
                                SizedBox(height: 20.h),
                                Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  size: 48.sp,
                                  color: AppColors.hintColor.withOpacity(0.6),
                                ),
                                12.sbH,
                                AppText(
                                  'لا توجد تعليقات بعد',
                                  size: 15.sp,
                                  weight: FontWeight.w700,
                                  color: AppColors.textColor3,
                                  centerText: true,
                                ),
                                6.sbH,
                                AppText(
                                  'كن أول من يشارك استفساره أو رأيه مع المعلم والطلاب!',
                                  size: 12.5.sp,
                                  color: AppColors.textColor4,
                                  centerText: true,
                                ),
                                20.sbH,
                                Center(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      CourseEditCommentDialog.show(
                                        context,
                                        initialBody: '',
                                        dialogTitle: 'إضافة تعليق جديد',
                                        hintText: 'اكتب سؤالك أو تعليقك هنا...',
                                        buttonText: 'إرسال التعليق',
                                        onSave: (text) => _cubit.addComment(text),
                                      );
                                    },
                                    icon: const Icon(Icons.add_comment_rounded, color: Colors.white, size: 18),
                                    label: AppText(
                                      'أضف تعليقاً الآن',
                                      size: 13.sp,
                                      weight: FontWeight.w700,
                                      color: AppColors.kWhite,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.kPrimary,
                                      elevation: 0,
                                      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 14.h),
                              itemCount: comments.length + (_cubit.isLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == comments.length) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12.h),
                                    child: const Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                                  );
                                }

                                final comment = comments[index];
                                final isHighlighted = widget.highlightCommentId != null &&
                                    comment.id == widget.highlightCommentId;

                                return CourseCommentCard(
                                  key: ValueKey('comment_${comment.id}'),
                                  comment: comment,
                                  isHighlighted: isHighlighted,
                                  highlightReplyId: widget.highlightReplyId,
                                  onEdit: () {
                                    CourseEditCommentDialog.show(
                                      context,
                                      initialBody: comment.body,
                                      onSave: (newBody) => _cubit.editComment(comment.id, newBody),
                                    );
                                  },
                                  onDelete: () => _showDeleteDialog(comment.id),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
