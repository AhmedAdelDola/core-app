import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/di.dart';
import '../../theme/colors/app_colors.dart';
import '../../theme/theme.dart';
import '../../widgets/app_texts/app_text.dart';
import '../../widgets/app_buttons/custom_button.dart';

class SecurityAlertDialogs {
  static bool _isUpdateDialogOpen = false;

  /// Open the store link based on the platform
  static Future<void> openStore({
    String? customAndroidUrl,
    String? customIosUrl,
  }) async {
    final packageInfo = di.isRegistered<PackageInfo>()
        ? di<PackageInfo>()
        : await PackageInfo.fromPlatform();
    final packageName = packageInfo.packageName;

    if (Platform.isAndroid) {
      if (customAndroidUrl != null && customAndroidUrl.isNotEmpty) {
        final uri = Uri.parse(customAndroidUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return;
        }
      }
      final marketUri = Uri.parse('market://details?id=$packageName');
      if (await canLaunchUrl(marketUri)) {
        await launchUrl(marketUri, mode: LaunchMode.externalApplication);
      } else {
        final webUri = Uri.parse('https://play.google.com/store/apps/details?id=$packageName');
        if (await canLaunchUrl(webUri)) {
          await launchUrl(webUri, mode: LaunchMode.externalApplication);
        }
      }
    } else if (Platform.isIOS) {
      if (customIosUrl != null && customIosUrl.isNotEmpty) {
        final uri = Uri.parse(customIosUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return;
        }
      }
      final appStoreUri = Uri.parse('https://apps.apple.com/app/id$packageName');
      if (await canLaunchUrl(appStoreUri)) {
        await launchUrl(appStoreUri, mode: LaunchMode.externalApplication);
      }
    }
  }

  /// Shows a blocking dialog when the app version is outdated and an update is mandatory.
  static Future<void> showUpdateRequiredDialog(
    BuildContext context, {
    String? message,
    String? updateUrlAndroid,
    String? updateUrlIos,
    VoidCallback? onUpdate,
  }) {
    if (_isUpdateDialogOpen) return Future.value();
    _isUpdateDialogOpen = true;

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
            message ?? 'عفواً، يجب تحديث التطبيق إلى أحدث إصدار من المتجر لمتابعة الاستخدام.',
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
                    openStore(
                      customAndroidUrl: updateUrlAndroid,
                      customIosUrl: updateUrlIos,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ).then((_) {
      _isUpdateDialogOpen = false;
    });
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

  /// Shows a blocking dialog when headphones are required to watch content
  static Future<void> showHeadphonesRequiredDialog(
    BuildContext context, {
    String? message,
    VoidCallback? onRetry,
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
            Icons.headphones_rounded,
            size: 48.r,
            color: AppColors.kPrimary,
          ),
          title: AppText(
            'سماعة الأذن مطلوبة',
            style: TextStyles.textViewBold(
              size: 18.sp,
              color: AppColors.textColor,
            ),
            align: TextAlign.center,
          ),
          content: AppText(
            message ?? 'هذه الحصة محمية وتتطلب توصيل سماعة أذن (سلكية أو بلوتوث / AirPods) للبدء في المشاهدة.',
            style: TextStyles.textViewRegular(
              fontSize: 14.sp,
              color: AppColors.textColor2,
            ),
            align: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onRetry != null) ...[
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'تم التوصيل، متابعة',
                      onTap: () {
                        Navigator.of(ctx).pop();
                        onRetry();
                      },
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      if (onClose != null) {
                        onClose();
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.kPrimary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                    child: AppText(
                      'إلغاء',
                      style: TextStyles.textViewBold(
                        size: 14.sp,
                        color: AppColors.kPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
