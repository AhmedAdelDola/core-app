import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors/app_colors.dart';

class AppText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final int? maxLines;
  final FontWeight? weight;
  final TextDirection? textDirection;
  final bool? centerText, underLintText, withOverFlow;
  final TextStyle? style;
  final TextOverflow? overflow;
  final TextAlign? align;
  final EdgeInsets? padding, margin;

  const AppText(
    this.text, {
    super.key,
    this.color,
    this.size,
    this.weight,
    this.centerText = true,
    this.underLintText,
    this.withOverFlow,
    this.maxLines,
    this.textDirection,
    this.style,
    this.overflow,
    this.align,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.zero,
      margin: margin ?? EdgeInsets.zero,
      child: AutoSizeText(
        text,
        textAlign:
            align ?? (centerText == true ? TextAlign.center : TextAlign.start),
        overflow: overflow ??
            (withOverFlow == true ? TextOverflow.ellipsis : TextOverflow.clip),
        maxLines: maxLines ?? 2,
        textDirection: textDirection,
        style: style ??
            TextStyle(
                overflow: TextOverflow.ellipsis,
                color: color ?? AppColors.kBlack,
                fontSize: size?.sp ?? 14.sp,
                fontWeight: weight ?? w400,
                decoration:
                    underLintText == true ? TextDecoration.underline : null),
      ),
    );
  }
}

FontWeight get w100 => FontWeight.w100;
FontWeight get w200 => FontWeight.w200;
FontWeight get w300 => FontWeight.w300;
FontWeight get w400 => FontWeight.w400;
FontWeight get w500 => FontWeight.w500;
FontWeight get w600 => FontWeight.w600;
FontWeight get w700 => FontWeight.w700;
FontWeight get w800 => FontWeight.w800;
FontWeight get w900 => FontWeight.w900;
FontWeight get normal => FontWeight.normal;
FontWeight get bold => FontWeight.bold;
