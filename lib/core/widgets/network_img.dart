import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/colors/app_colors.dart';

class NetworkImagesWidgets extends StatelessWidget {
  final String url;
  final double? width, height;
  final BoxFit? fit;
  final Widget Function(BuildContext, String, Object)? errorWidget;
  const NetworkImagesWidgets(
      {super.key,
      required this.url,
      this.errorWidget,
      this.fit,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        errorWidget: errorWidget ?? errorIconImage,
        progressIndicatorBuilder: (context, _, __) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Center(child: LoadingImage(w: width)),
          );
        },
      ),
    );
  }
}

class LoadingImage extends StatelessWidget {
  final double? w;
  const LoadingImage({super.key, this.w});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: Container(
          width: w ?? double.infinity,
          color: AppColors.textColor2,
        ),
      ),
    );
  }
}

Widget errorIconImage(c, s, e) => const Icon(Icons.error, color: AppColors.red);
