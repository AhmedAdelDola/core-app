import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_texts/app_text.dart';
import '../../../../core/widgets/network_img.dart';
import '../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../../models/profile/get_notifications_response.dart';
import '../cubit/get_notifications_cubit.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification item;
  const NotificationCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final hasImage = item.image != null && item.image!.isNotEmpty;
    final isRead = item.isRead;

    return InkWell(
      onTap: () {
        if (!isRead) {
          context.read<GetNotificationsCubit>().markAsRead(item.id);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 14.w),
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : const Color(0xFFF0F7FF),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isRead ? const Color(0xFFEEEEEE) : AppColors.kPrimary.withOpacity(0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isRead ? const Color(0xFFF5F5F5) : AppColors.kPrimary.withOpacity(0.1),
              ),
              child: hasImage
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: item.image!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Icon(
                          Icons.notifications_outlined,
                          color: AppColors.kPrimary,
                          size: 22.r,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.notifications_outlined,
                      color: isRead ? AppColors.hintColor : AppColors.kPrimary,
                      size: 22.r,
                    ),
            ),
            12.sbW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            if (!isRead) ...[
                              Container(
                                width: 8.r,
                                height: 8.r,
                                margin: EdgeInsetsDirectional.only(end: 6.w),
                                decoration:  BoxDecoration(
                                  color: AppColors.kPrimary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                            Flexible(
                              child: AppText(
                                item.title ?? 'إشعار جديد',
                                style: TextStyles.textViewBold(
                                  size: 14.sp,
                                  color: AppColors.textColor,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (item.createdAt != null) ...[
                        6.sbW,
                        AppText(
                          item.createdAt!.toDateFormat(
                            format: 'dd/MM/yyyy',
                            locale: 'ar',
                          ),
                          style: TextStyles.textViewRegular(
                            fontSize: 11.sp,
                            color: AppColors.hintColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                  6.sbH,
                  AppText(
                    item.body ?? item.message ?? '',
                    style: TextStyles.textViewRegular(
                      fontSize: 13.sp,
                      color: isRead ? AppColors.textColor2 : AppColors.textColor,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    align: TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
