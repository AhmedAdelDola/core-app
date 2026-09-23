import 'package:elhanbly/core/theme/colors/app_colors.dart';
import 'package:elhanbly/core/widgets/app_texts/app_text.dart';
import 'package:elhanbly/core/widgets/ui_helpers/alert_message.dart';
import 'package:elhanbly/core/widgets/ui_helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CourseCommentInput extends StatefulWidget {
  final Future<bool> Function(String text) onSubmit;
  final bool isLoading;

  const CourseCommentInput({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<CourseCommentInput> createState() => _CourseCommentInputState();
}

class _CourseCommentInputState extends State<CourseCommentInput> {
  final TextEditingController _controller = TextEditingController();
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
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

  void _handleSubmit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      return;
    }
    if (text.length < 2) {
      showErrorToast('يجب أن يحتوي التعليق على حرفين على الأقل');
      return;
    }
    if (text.length > 2000) {
      showErrorToast('الحد الأقصى للتعليق هو 2000 حرف');
      return;
    }

    final success = await widget.onSubmit(text);
    if (success && mounted) {
      _controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canSubmit = _charCount >= 2 && _charCount <= 2000 && !widget.isLoading;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      padding: EdgeInsets.fromLTRB(12.w, 6.h, 12.w, 6.h),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  constraints: BoxConstraints(maxHeight: 100.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FC),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: _charCount > 2000 ? AppColors.kRed : const Color(0xFFE2E8F0),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.newline,
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: 'اكتب سؤالك أو تعليقك هنا...',
                      hintStyle: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.hintColor,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              8.sbW,
              InkWell(
                onTap: canSubmit ? _handleSubmit : null,
                borderRadius: BorderRadius.circular(24.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: canSubmit ? AppColors.kPrimary : const Color(0xFFE2E8F0),
                    shape: BoxShape.circle,
                  ),
                  child: widget.isLoading
                      ? Center(
                          child: SizedBox(
                            width: 20.r,
                            height: 20.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: AppColors.kWhite,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.send_rounded,
                          size: 20.sp,
                          color: canSubmit ? AppColors.kWhite : const Color(0xFF94A3B8),
                        ),
                ),
              ),
            ],
          ),
          if (_charCount > 0) ...[
            4.sbH,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Row(
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
                    size: 10.5.sp,
                    weight: FontWeight.w500,
                    color: _charCount > 2000 ? AppColors.kRed : AppColors.textColor4,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
