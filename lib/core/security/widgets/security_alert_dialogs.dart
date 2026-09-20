import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/colors/app_colors.dart';
import '../../theme/theme.dart';
import '../../widgets/app_texts/app_text.dart';
import '../../widgets/app_buttons/custom_button.dart';

class SecurityAlertDialogs {
  /// Shows a blocking dialog when the app version is outdated and an update is mandatory.
  static Future<void> showUpdateRequiredDialog(
    BuildContext context, {
    VoidCallback? onUpdate,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          icon: Icon(
            Icons.system_update,
            size: 48.r,
            color: AppColors.kPrimary,
          ),
          title: AppText(
            'تحديث التطبيق مطلوب',
            style: TextStyles.textViewBold(
              size: 18.sp,
              color: AppColors.textColor,
            ),
            align: TextAlign.center,
          ),
          content: AppText(
            'يتطلب تشغيل المحتوى المحمي تحديث التطبيق إلى أحدث إصدار متوفر على متجر التطبيقات.',
            style: TextStyles.textViewRegular(
              fontSize: 14.sp,
              color: AppColors.textColor2,
            ),
            align: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'تحديث الآن',
                onTap: () {
                  if (onUpdate != null) {
                    onUpdate();
                  } else {
                    Navigator.of(ctx).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows an alert dialog when device attestation fails or the device is untrusted.
  static Future<void> showDeviceNotTrustedDialog(
    BuildContext context, {
    String? message,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        icon: Icon(
          Icons.gpp_bad,
          size: 48.r,
          color: AppColors.red,
        ),
        title: AppText(
          'تعذر التحقق من أمان الجهاز',
          style: TextStyles.textViewBold(
            size: 18.sp,
            color: AppColors.textColor,
          ),
          align: TextAlign.center,
        ),
        content: AppText(
          message ??
              'لا يفي جهازك بمتطلبات الأمان اللازمة لحماية المحتوى التعليمي. قد يكون الجهاز معدلاً أو غير مدعوم.',
          style: TextStyles.textViewRegular(
            fontSize: 14.sp,
            color: AppColors.textColor2,
          ),
          align: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'حسناً',
              onTap: () => Navigator.of(ctx).pop(),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a blocking dialog when screen recording or mirroring is detected.
  static Future<void> showScreenRecordingDetectedDialog(
    BuildContext context, {
    VoidCallback? onClose,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          icon: Icon(
            Icons.videocam_off_rounded,
            size: 48.r,
            color: AppColors.red,
          ),
          title: AppText(
            'تنبيه: تسجيل الشاشة ممنوع',
            style: TextStyles.textViewBold(
              size: 18.sp,
              color: AppColors.textColor,
            ),
            align: TextAlign.center,
          ),
          content: AppText(
            'تم اكتشاف محاولة تسجيل الشاشة أو مشاركتها. غير مسموح بتشغيل المحتوى أثناء التسجيل لحماية حقوق الملكية. يرجى إيقاف التسجيل للمتابعة.',
            style: TextStyles.textViewRegular(
              fontSize: 14.sp,
              color: AppColors.textColor2,
            ),
            align: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'إغلاق',
                onTap: () {
                  Navigator.of(ctx).pop();
                  if (onClose != null) {
                    onClose();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
