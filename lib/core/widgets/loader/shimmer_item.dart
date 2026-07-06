import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/colors/app_colors.dart';

class ShimmerItem extends StatelessWidget {
  final double width, height, radius;

  const ShimmerItem({
    super.key,
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
