import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../../../../../core/security/widgets/security_alert_dialogs.dart';
import '../../../../../../../core/services/screen_security_service.dart';
import '../../../../../../../models/Session/show_video_response.dart';
import '../../../courses_section/view/course_view/course_view_widgets/course_comments_section/course_comments_widget.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({Key? key, required this.model, this.sessionId}) : super(key: key);

  final ShowVideo? model;
  final dynamic sessionId;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  bool _isChecking = true;
  bool _isBlocked = false;

  @override
  void initState() {
    super.initState();
    ScreenSecurityService.enable();
    ScreenSecurityService.addListener(_onRecordingChanged);
    _checkRecording();
  }

  Future<void> _checkRecording() async {
    final recording = await ScreenSecurityService.isScreenRecording();
    if (!mounted) return;
    if (recording) {
      _blockAndClose();
    } else {
      setState(() {
        _isChecking = false;
      });
    }
  }

  void _onRecordingChanged(bool isRecording) {
    if (isRecording && mounted) {
      _blockAndClose();
    }
  }

  void _blockAndClose() {
    if (_isBlocked) return;
    setState(() {
      _isBlocked = true;
      _isChecking = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      SecurityAlertDialogs.showScreenRecordingDetectedDialog(
        context,
        onClose: () {
          if (mounted && Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
        },
      );
    });
  }

  @override
  void dispose() {
    ScreenSecurityService.removeListener(_onRecordingChanged);
    ScreenSecurityService.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isBlocked || _isChecking) {
      return const ColoredBox(
        color: Colors.black,
        child: SizedBox.expand(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox(
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
                  URLRequest(url: WebUri(widget.model?.playerUrl ?? "")),
            ),
          ),
          if (widget.sessionId != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 12,
              child: SafeArea(
                child: Material(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      CourseCommentsWidget.showCommentsSheet(
                        context,
                        sessionId: widget.sessionId,
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'التعليقات',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
