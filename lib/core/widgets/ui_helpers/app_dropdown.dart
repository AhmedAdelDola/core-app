import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors/app_colors.dart';
import '../../theme/theme.dart';
import '../app_texts/app_text.dart';

class AppDropdown extends StatefulWidget {
  final String hintText;
  final String? value;
  final List<String> items;
  final IconData? iconData;
  final Color? backgroundColor;
  final void Function(String?)? onChanged;

  const AppDropdown({
    super.key,
    required this.hintText,
    required this.value,
    required this.items,
    this.iconData,
    this.backgroundColor,
    required this.onChanged,
  });

  @override
  State<AppDropdown> createState() => _AppDropdownState();
}

class _AppDropdownState extends State<AppDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: widget.backgroundColor ?? AppColors.kWhite,
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: DropdownButton<String>(
        value: widget.value,
        icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.hintColor),
        hint: Builder(builder: (BuildContext context) {
          if (widget.iconData != null) {
            return Row(
              children: <Widget>[
                Icon(
                  widget.iconData,
                  color: AppColors.textColor2,
                ),
                SizedBox(width: 8.w),
                AppText(
                  widget.hintText,
                  style: TextStyles.textViewRegular(fontSize: 16.sp)
                      .copyWith(color: AppColors.hintColor),
                ),
              ],
            );
          }
          return Text(
            widget.hintText,
            style: TextStyles.textViewRegular(fontSize: 16.sp).copyWith(color: AppColors.hintColor),
          );
        }),
        borderRadius: BorderRadius.circular(8.r),
        isExpanded: true,
        underline: const SizedBox(),
        items: widget.items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Row(
              children: <Widget>[
                Icon(widget.iconData, color: AppColors.textColor2),
                SizedBox(width: 8.w),
                AppText(
                  item,
                  style: TextStyles.textViewRegular(fontSize: 16.sp)
                      .copyWith(color: AppColors.hintColor),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: widget.onChanged,
      ),
    );
  }
}
