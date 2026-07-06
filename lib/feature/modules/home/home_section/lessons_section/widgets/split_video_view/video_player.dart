import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../../core/consts/images.dart';
import '../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../core/util/launcher.dart';
import '../../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../../../../../models/Session/show_video_response.dart';

class VideoPlayer extends StatelessWidget {
  const VideoPlayer({Key? key, required this.model}) : super(key: key);

  final ShowVideo? model;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: InAppWebView(
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,
                useHybridComposition: true,
              ),
              initialUrlRequest:
                  URLRequest(url: WebUri(model?.playerUrl ?? "")),
            ),
          );
  }
}
