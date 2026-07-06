import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors/app_colors.dart';
import '../../theme/theme.dart';
import '../../util/text_input_formatter.dart';
import '../../util/validator/validator.dart';

class MasterTextField extends StatefulWidget {
  final double? sidePadding;
  final double? fieldWidth;
  final bool? readOnly;
  final TextEditingController? controller;
  final Color? hintColor;
  final TextInputType? keyboardType;
  final bool? isPassword;
  final bool? autofocus;
  final Color? borderColor;
  final Color? textFieldColor;
  final String? errorText;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final double? elevation;
  final Color? shadowColor;
  final bool? enabled;
  final double? borderRadius;
  final Widget? prefixWidget;
  final String? suffixText;
  final IconData? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final Color? suffixColor;
  final Color? prefixColor;
  final int? maxLines;
  final int? minLines;
  final Function(String)? onChanged;
  final int? borderWidth;
  final Function(String)? onSubmit;
  final Function()? onTap;
  final String? Function(String?) validate;
  final Widget? suffix;
  final Color? fillColor;
  final TextAlign? textAlign;
  final Widget? suffixWidget;
  final void Function(String?)? onSaved;
  final TextDirection? textDirection;
  final List<BoxShadow>? boxShadow;
  const MasterTextField({
    super.key,
    this.inputFormatters,
    this.sidePadding,
    this.fieldWidth,
    this.suffixWidget,
    this.readOnly,
    this.controller,
    this.hintColor,
    this.keyboardType,
    this.isPassword,
    this.autofocus,
    this.borderColor,
    this.textFieldColor,
    this.errorText,
    this.hintText,
    this.hintStyle,
    this.labelStyle,
    this.labelText,
    this.elevation,
    this.shadowColor,
    this.enabled,
    this.borderRadius,
    this.prefixWidget,
    this.suffixText,
    this.suffixIcon,
    this.suffixColor,
    this.boxShadow,
    this.prefixColor,
    this.maxLines,
    this.minLines,
    this.onChanged,
    this.borderWidth,
    this.onSubmit,
    this.onTap,
    this.validate = Validator.defaultEmptyValidator,
    this.suffix,
    this.fillColor,
    this.textAlign,
    this.onSaved,
    this.textDirection = TextDirection.rtl,
  });

  @override
  State<MasterTextField> createState() => _MasterTextFieldState();
}

class _MasterTextFieldState extends State<MasterTextField> {
  bool secure = false;
  TextDirection? textDirection;
  String? fontFamily;
  @override
  void initState() {
    super.initState();
    secure = widget.isPassword ?? false;
    textDirection = widget.textDirection;
    // if (widget.keyboardType == TextInputType.number) {
    //   fontFamily = '';
    // }
  }

  @override
  void didUpdateWidget(covariant MasterTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  void _checkForArabicLetter(String text) {
    final RegExp arabicRegex = RegExp(r'[ء-ي-_ .]*$');
    final RegExp englishRegex = RegExp(r'[a-zA-Z ]');
    final RegExp spi = RegExp("[\$&+,:;=?@#|'<>.^*()%!-]+");
    final RegExp numbers = RegExp('^[0-9]*\$');
    setState(() {
      text.contains(arabicRegex) &&
              !text.startsWith(englishRegex) &&
              !text.startsWith(spi) &&
              !text.startsWith(numbers)
          ? textDirection = TextDirection.rtl
          : textDirection = TextDirection.ltr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly ?? false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      onChanged: (String value) {
        // _checkForArabicLetter(value);
        if (widget.onChanged != null) widget.onChanged!(value);
      },
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
        final controller = widget.controller;
        if (controller == null || controller.text.isEmpty) return;
        if (controller.selection ==
            TextSelection.fromPosition(TextPosition(offset: controller.text.length - 1))) {
          setState(() {
            controller.selection =
                TextSelection.fromPosition(TextPosition(offset: controller.text.length));
          });
        }
      },
      keyboardType: widget.keyboardType,
      obscureText: secure,
      maxLines: widget.maxLines ?? 1,
      minLines: widget.minLines ?? 1,
      autofocus: widget.autofocus ?? false,
      style: TextStyles.textViewRegular(fontSize: 16.sp, color: AppColors.hintColor),
      enabled: widget.enabled,
      onSaved: widget.onSaved,
      validator: widget.validate,
      onFieldSubmitted: widget.onSubmit,
      textDirection: textDirection,
      inputFormatters: widget.inputFormatters ?? [ArabicNumberTextInputFormatter()],
      onTapOutside: (value) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        filled: true,
        fillColor: widget.fillColor ?? AppColors.kWhite,
        errorMaxLines: 2,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.r),
          borderSide: BorderSide(
            color: widget.borderColor ?? AppColors.textFieldBorderColor,
            width: 1,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.r),
          borderSide: BorderSide(
            color: widget.borderColor ?? AppColors.textFieldBorderColor,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.r),
          borderSide: BorderSide(
            color: widget.borderColor ?? AppColors.textFieldBorderColor,
            width: 1,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor ?? AppColors.textFieldBorderColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 16.r)),
            borderSide: BorderSide(
              color: widget.errorText != null ? AppColors.red : AppColors.textColor,
              width: 1,
              style: BorderStyle.solid,
            )),
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle ??
            TextStyles.textViewRegular(fontSize: 16.sp).copyWith(color: AppColors.hintColor),
        labelStyle: widget.labelStyle ??
            TextStyles.textViewRegular(fontSize: 16.sp).copyWith(color: AppColors.hintColor),
        suffixIconColor: widget.suffixColor ?? AppColors.kPrimary,
        prefixIconColor: widget.prefixColor ?? AppColors.kPrimary,
        suffix: widget.suffix,
        prefixIcon: widget.prefixWidget,
        suffixIcon: widget.suffixWidget ??
            (widget.isPassword ?? false
                ? IconButton(
                    onPressed: () => setState(() {
                          secure = !secure;
                        }),
                    icon: Icon(
                      !secure ? Icons.visibility : Icons.visibility_off,
                      color: widget.suffixColor,
                    ))
                : widget.suffixIcon == null
                    ? null
                    : Icon(
                        widget.suffixIcon,
                        color: widget.suffixColor,
                      )),
      ),
    );
  }
}
