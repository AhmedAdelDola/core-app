import 'package:elhanbly/core/theme/colors/app_colors.dart';
import 'package:elhanbly/core/widgets/app_texts/app_text.dart';
import 'package:elhanbly/core/widgets/ui_helpers/alert_message.dart';
import 'package:elhanbly/core/widgets/ui_helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CourseEditCommentDialog extends StatefulWidget {
  final String initialBody;
  final String dialogTitle;
  final String hintText;
  final String buttonText;
  final Future<bool> Function(String text) onSave;

  const CourseEditCommentDialog({
    super.key,
    required this.initialBody,
    this.dialogTitle = 'تعديل التعليق',
    this.hintText = 'اكتب التعديل هنا...',
    this.buttonText = 'حفظ التعديل',
    required this.onSave,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String initialBody,
    String dialogTitle = 'تعديل التعليق',
    String hintText = 'اكتب التعديل هنا...',
    String buttonText = 'حفظ التعديل',
    required Future<bool> Function(String text) onSave,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => CourseEditCommentDialog(
        initialBody: initialBody,
        dialogTitle: dialogTitle,
        hintText: hintText,
        buttonText: buttonText,
        onSave: onSave,
      ),
    );
  }

  @override
  State<CourseEditCommentDialog> createState() => _CourseEditCommentDialogState();
}

class _CourseEditCommentDialogState extends State<CourseEditCommentDialog> {
  late final TextEditingController _controller;
  bool _isLoading = false;
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialBody);
    _charCount = widget.initialBody.trim().length;
    _controller.addListener(() {
      setState(() {
        _charCount = _controller.text.trim().length;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSave() async {
    final text = _controller.text.trim();
    if (text.length < 2) {
      showErrorToast('يجب أن يحتوي التعليق على حرفين على الأقل');
      return;
    }
    if (text.length > 2000) {
      showErrorToast('الحد الأقصى للتعليق هو 2000 حرف');
      return;
    }

    setState(() => _isLoading = true);
    final success = await widget.onSave(text);
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canSave = _charCount >= 2 && _charCount <= 2000 && !_isLoading;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      backgroundColor: AppColors.kWhite,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.edit_note_rounded, color: AppColors.kPrimary, size: 24.sp),
                8.sbW,
                AppText(
                  widget.dialogTitle,
                  size: 16.sp,
                  weight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ],
            ),
            14.sbH,
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FC),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: _charCount > 2000 ? AppColors.kRed : const Color(0xFFE2E8F0),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              child: TextField(
                controller: _controller,
                minLines: 3,
                maxLines: 7,
                autofocus: true,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.hintColor,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            6.sbH,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_charCount < 2)
                  AppText(
                    'أقل عدد حروف هو حرفين',
                    size: 10.sp,
                    color: AppColors.kRed,
                  )
                else
                  const SizedBox.shrink(),
                AppText(
                  '$_charCount / 2000',
                  size: 11.sp,
                  weight: FontWeight.w500,
                  color: _charCount > 2000 ? AppColors.kRed : AppColors.textColor4,
                ),
              ],
            ),
            18.sbH,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      padding: EdgeInsets.symmetric(vertical: 11.h),
                    ),
                    child: AppText(
                      'إلغاء',
                      size: 13.sp,
                      weight: FontWeight.w600,
                      color: AppColors.textColor2,
                    ),
                  ),
                ),
                12.sbW,
                Expanded(
                  child: ElevatedButton(
                    onPressed: canSave ? _handleSave : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kPrimary,
                      disabledBackgroundColor: const Color(0xFFE2E8F0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      padding: EdgeInsets.symmetric(vertical: 11.h),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 18.r,
                            height: 18.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.kWhite,
                            ),
                          )
                        : AppText(
                            widget.buttonText,
                            size: 13.sp,
                            weight: FontWeight.w700,
                            color: canSave ? AppColors.kWhite : const Color(0xFF94A3B8),
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
