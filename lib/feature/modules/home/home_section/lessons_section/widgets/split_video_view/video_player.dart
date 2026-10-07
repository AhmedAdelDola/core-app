import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../../../../../core/security/widgets/security_alert_dialogs.dart';
import '../../../../../../../core/services/headphone_detector_service.dart';
import '../../../../../../../core/services/screen_security_service.dart';
import '../../../../../../../models/Session/show_video_response.dart';
import '../../../courses_section/view/course_view/course_view_widgets/course_comments_section/course_comments_widget.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    Key? key,
    required this.model,
    this.sessionId,
    this.requiresHeadphones = false,
  }) : super(key: key);

  final ShowVideo? model;
  final dynamic sessionId;
  final bool requiresHeadphones;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  bool _isChecking = true;
  bool _isBlocked = false;
  bool _isLoading = true;
  bool _isHeadphonesDisconnected = false;
  InAppWebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    ScreenSecurityService.enable();
    ScreenSecurityService.addListener(_onRecordingChanged);
    _checkRecording();

    if (widget.requiresHeadphones) {
      HeadphoneDetectorService.addListener(_onHeadphonesChanged);
      _checkHeadphones();
    }
  }

  Future<void> _checkHeadphones() async {
    final connected = await HeadphoneDetectorService.isHeadphonesConnected();
    if (!mounted) return;
    setState(() {
      _isHeadphonesDisconnected = !connected;
    });
    if (!connected) {
      _pauseVideo();
    }
  }

  void _onHeadphonesChanged(bool isConnected) {
    if (!mounted) return;
    setState(() {
      _isHeadphonesDisconnected = !isConnected;
    });
    if (!isConnected) {
      _pauseVideo();
    }
  }

  void _pauseVideo() {
    try {
      _webViewController?.evaluateJavascript(
        source: 'try { document.querySelectorAll("video").forEach(v => v.pause()); } catch(e){}',
      );
    } catch (_) {}
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
    if (widget.requiresHeadphones) {
      HeadphoneDetectorService.removeListener(_onHeadphonesChanged);
    }
    ScreenSecurityService.removeListener(_onRecordingChanged);
    ScreenSecurityService.disable();
    super.dispose();
  }

  static String? extractYoutubeVideoId(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final url = raw.trim();

    if (RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(url)) {
      return url;
    }

    final match = RegExp(
      r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=|shorts\/|live\/)|youtu\.be\/)([^"&?\/ ]{11})',
      caseSensitive: false,
    ).firstMatch(url);

    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }
    return null;
  }


  static String buildYoutubeHtml(String videoId) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    html, body { width: 100%; height: 100%; background-color: #000000; overflow: hidden; display: flex; align-items: center; justify-content: center; }
    .video-wrapper { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
    iframe { width: 100%; height: 100%; border: 0; }
  </style>
</head>
<body>
  <div class="video-wrapper">
    <iframe
      src="https://www.youtube.com/embed/$videoId?autoplay=1&playsinline=1&enablejsapi=1&rel=0&modestbranding=1&fs=0"
      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope">
    </iframe>
  </div>
</body>
</html>
''';
  }

  static const String _disableFullscreenScript = '''
    (function() {
      function disableFs() {
        Element.prototype.requestFullscreen = function() {
          return Promise.reject(new Error('Fullscreen disabled'));
        };
        if (Element.prototype.webkitRequestFullscreen) {
          Element.prototype.webkitRequestFullscreen = function() {
            return Promise.reject(new Error('Fullscreen disabled'));
          };
        }
        if (Element.prototype.mozRequestFullScreen) {
          Element.prototype.mozRequestFullScreen = function() {
            return Promise.reject(new Error('Fullscreen disabled'));
          };
        }
        if (Element.prototype.msRequestFullscreen) {
          Element.prototype.msRequestFullscreen = function() {
            return Promise.reject(new Error('Fullscreen disabled'));
          };
        }
        Document.prototype.exitFullscreen = function() {
          return Promise.resolve();
        };
        if (Document.prototype.webkitExitFullscreen) {
          Document.prototype.webkitExitFullscreen = function() {};
        }
        try {
          Object.defineProperty(document, 'fullscreenEnabled', {
            get: function() { return false; },
            configurable: true
          });
          Object.defineProperty(document, 'webkitFullscreenEnabled', {
            get: function() { return false; },
            configurable: true
          });
        } catch(e) {}
      }
      disableFs();
      document.addEventListener('DOMContentLoaded', disableFs);
    })();
  ''';

  @override
  Widget build(BuildContext context) {
    if (_isBlocked) {
      return const ColoredBox(
        color: Colors.black,
        child: SizedBox.expand(),
      );
    }

    final rawUrl = widget.model?.playerUrl?.trim() ?? '';
    final youtubeId = extractYoutubeVideoId(rawUrl);

    String normalizedUrl = rawUrl;
    if (normalizedUrl.isNotEmpty &&
        !normalizedUrl.startsWith('http://') &&
        !normalizedUrl.startsWith('https://')) {
      normalizedUrl = 'https://$normalizedUrl';
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: normalizedUrl.isNotEmpty || youtubeId != null
                ? InAppWebView(
                    initialSettings: InAppWebViewSettings(
                      javaScriptEnabled: true,
                      mediaPlaybackRequiresUserGesture: false,
                      allowsInlineMediaPlayback: true,
                      useHybridComposition: true,
                      allowsPictureInPictureMediaPlayback: false,
                      transparentBackground: true,
                      domStorageEnabled: true,
                      databaseEnabled: true,
                      allowFileAccess: true,
                      allowContentAccess: true,
                      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                      useWideViewPort: true,
                      loadWithOverviewMode: true,
                      userAgent:
                          'Mozilla/5.0 (Linux; Android 13; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36',
                    ),
                    initialData: youtubeId != null
                        ? InAppWebViewInitialData(
                            data: buildYoutubeHtml(youtubeId),
                            baseUrl: WebUri('https://www.youtube.com'),
                            encoding: 'utf-8',
                            mimeType: 'text/html',
                          )
                        : null,
                    initialUrlRequest: youtubeId == null
                        ? URLRequest(url: WebUri(normalizedUrl))
                        : null,
                    onWebViewCreated: (controller) {
                      _webViewController = controller;
                      controller.evaluateJavascript(source: _disableFullscreenScript);
                    },
                    onLoadStop: (controller, url) {
                      controller.evaluateJavascript(source: _disableFullscreenScript);
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    onReceivedError: (controller, request, error) {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    onReceivedHttpError: (controller, request, errorResponse) {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                  )
                : const Center(
                    child: Text(
                      'رابط الفيديو غير متاح',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
          ),
          if (_isLoading || _isChecking)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            ),
          if (_isHeadphonesDisconnected && widget.requiresHeadphones)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.94),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.headphones_rounded,
                        color: Colors.amber,
                        size: 56,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'تم إيقاف الفيديو مؤقتاً',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'هذه الحصة تتطلب توصيل سماعة أذن (سلكية أو AirPods / Bluetooth).\nيرجى إعادة توصيل السماعة للمتابعة.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _checkHeadphones,
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('تحقق من التوصيل'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[700],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Back / Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 12,
            child: SafeArea(
              child: Material(
                color: Colors.black54,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
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
