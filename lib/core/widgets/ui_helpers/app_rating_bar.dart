import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors/app_colors.dart';

class AppRatingBar extends StatelessWidget {
  final double? size, initialRating;
  final void Function(double)? onRatingUpdate;

  const AppRatingBar({
    this.size,
    this.onRatingUpdate,
    this.initialRating,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: initialRating ?? 0.0,
      itemSize: size ?? 40.r,
      minRating: 1,
      maxRating: 5,
      itemCount: 5,
      direction: Axis.horizontal,
      allowHalfRating: true,
      glow: true,
      textDirection: TextDirection.ltr,
      ignoreGestures: onRatingUpdate == null,
      onRatingUpdate: onRatingUpdate ?? (double value) {},
      ratingWidget: RatingWidget(
        empty:  Icon(Icons.star_border_rounded, color: AppColors.kPrimary),
        half:  Icon(Icons.star_half_rounded, color: AppColors.kPrimary),
        full:  Icon(Icons.star_rate_rounded, color: AppColors.kPrimary),
      ),
    );
  }
}
