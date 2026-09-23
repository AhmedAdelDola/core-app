import 'package:cached_network_image/cached_network_image.dart';
import 'package:elhanbly/core/theme/colors/app_colors.dart';
import 'package:elhanbly/core/widgets/app_texts/app_text.dart';
import 'package:elhanbly/core/widgets/ui_helpers/extensions.dart';
import 'package:elhanbly/models/home_entities/courses/course_comments_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CourseCommentCard extends StatelessWidget {
  final CourseCommentItem comment;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isHighlighted;
  final int? highlightReplyId;

  const CourseCommentCard({
    super.key,
    required this.comment,
    this.onEdit,
    this.onDelete,
    this.isHighlighted = false,
    this.highlightReplyId,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.w),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColors.kPrimary.withValues(alpha: 0.08)
            : (comment.isPinned ? const Color(0xFFFFFDF5) : AppColors.kWhite),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isHighlighted
              ? AppColors.kPrimary
              : (comment.isPinned
                  ? const Color(0xFFFFD54F)
                  : const Color(0xFFE8EEF5)),
          width: isHighlighted || comment.isPinned ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pinned Badge if pinned
          if (comment.isPinned) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              margin: EdgeInsets.only(bottom: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.push_pin_rounded,
                    size: 14.sp,
                    color: const Color(0xFFB78103),
                  ),
                  4.sbW,
                  AppText(
                    'تعليق مثبت',
                    size: 11.sp,
                    weight: FontWeight.w700,
                    color: const Color(0xFFB78103),
                  ),
                ],
              ),
            ),
          ],

          // Header: Avatar, Name, Date, Edit/Delete Menu
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatar(
                imageUrl: comment.student?.imageUrl,
                name: comment.student?.name ?? '',
                size: 38.r,
              ),
              10.sbW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: AppText(
                            comment.student?.name ?? 'طالب',
                            size: 14.sp,
                            weight: FontWeight.w700,
                            color: AppColors.textColor,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (comment.isMine) ...[
                          6.sbW,
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: AppColors.kPrimary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: AppText(
                              'أنت',
                              size: 10.sp,
                              weight: FontWeight.w600,
                              color: AppColors.kPrimary,
                            ),
                          ),
                        ],
                      ],
                    ),
                    3.sbH,
                    Row(
                      children: [
                        AppText(
                          comment.createdAt?.toDateFormat(
                                format: 'dd MMM yyyy, hh:mm a',
                                locale: 'ar',
                              ) ??
                              '',
                          size: 11.sp,
                          weight: FontWeight.w400,
                          color: AppColors.textColor4,
                        ),
                        if (comment.isEdited) ...[
                          6.sbW,
                          AppText(
                            '(معدل)',
                            size: 10.sp,
                            weight: FontWeight.w500,
                            color: AppColors.hintColor,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Actions menu for comment owner
              if (comment.isMine) ...[
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.textColor4,
                    size: 20.sp,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit?.call();
                    } else if (value == 'delete') {
                      onDelete?.call();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18.sp, color: AppColors.textColor),
                          8.sbW,
                          Text(
                            'تعديل',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded, size: 18.sp, color: AppColors.kRed),
                          8.sbW,
                          Text(
                            'حذف',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.kRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),

          10.sbH,

          // Comment body
          SelectableText(
            comment.body,
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor,
              height: 1.45,
            ),
          ),

          // Replies section
          if (comment.replies.isNotEmpty) ...[
            12.sbH,
            ...comment.replies.map((reply) => _buildReplyCard(reply)),
          ],
        ],
      ),
    );
  }

  Widget _buildReplyCard(CourseCommentReply reply) {
    final bool isReplyHighlighted = highlightReplyId != null && reply.id == highlightReplyId;
    final repliedBy = reply.repliedBy;
    final accentColor = isReplyHighlighted
        ? AppColors.kPrimary
        : (repliedBy?.isTeacher == true ? AppColors.kPrimary : const Color(0xFF00ACC1));

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      decoration: BoxDecoration(
        color: isReplyHighlighted
            ? AppColors.kPrimary.withValues(alpha: 0.08)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEDF2F7), width: 1.w),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          children: [
            // Right accent vertical bar (RTL aware)
            PositionedDirectional(
              start: 0,
              top: 0,
              bottom: 0,
              width: 4.w,
              child: ColoredBox(color: accentColor),
            ),
            // Reply content with padding
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: 14.w,
                end: 12.w,
                top: 10.h,
                bottom: 10.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildAvatar(
                        imageUrl: repliedBy?.imageUrl,
                        name: repliedBy?.name ?? '',
                        size: 30.r,
                        isInstructor: true,
                      ),
                      8.sbW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: AppText(
                                    repliedBy?.name ?? 'المحاضر',
                                    size: 13.sp,
                                    weight: FontWeight.w700,
                                    color: AppColors.textColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                6.sbW,
                                _buildRoleBadge(repliedBy),
                              ],
                            ),
                            2.sbH,
                            AppText(
                              reply.createdAt?.toDateFormat(
                                    format: 'dd MMM yyyy, hh:mm a',
                                    locale: 'ar',
                                  ) ??
                                  '',
                              size: 10.sp,
                              weight: FontWeight.w400,
                              color: AppColors.textColor4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  8.sbH,
                  SelectableText(
                    reply.body,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleBadge(CourseCommentRepliedBy? repliedBy) {
    final bool isTeacher = repliedBy?.isTeacher ?? true;
    final color = isTeacher ? AppColors.kPrimary : const Color(0xFF00ACC1);
    final text = repliedBy?.roleDisplayName ?? 'معلم';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isTeacher ? Icons.school_rounded : Icons.support_agent_rounded,
            size: 10.sp,
            color: color,
          ),
          3.sbW,
          AppText(
            text,
            size: 10.sp,
            weight: FontWeight.w700,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar({
    required String? imageUrl,
    required String name,
    required double size,
    bool isInstructor = false,
  }) {
    final hasImage = imageUrl != null && imageUrl.trim().isNotEmpty;
    final initial = name.trim().isNotEmpty ? name.trim()[0] : (isInstructor ? 'م' : 'ط');

    if (hasImage) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            border: Border.all(
              color: isInstructor ? AppColors.kPrimary.withValues(alpha: 0.5) : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
          ),
        ),
        placeholder: (context, url) => Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFEEF2F6),
          ),
        ),
        errorWidget: (context, url, error) => _fallbackAvatar(initial, size, isInstructor),
      );
    }
    return _fallbackAvatar(initial, size, isInstructor);
  }

  Widget _fallbackAvatar(String initial, double size, bool isInstructor) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isInstructor
            ? AppColors.kPrimary.withValues(alpha: 0.15)
            : const Color(0xFFE2E8F0),
        border: Border.all(
          color: isInstructor ? AppColors.kPrimary.withValues(alpha: 0.4) : const Color(0xFFCBD5E1),
          width: 1.0,
        ),
      ),
      child: AppText(
        initial,
        size: (size * 0.42).sp,
        weight: FontWeight.w700,
        color: isInstructor ? AppColors.kPrimary : AppColors.textColor2,
      ),
    );
  }
}
