import 'dart:math' as math;
import 'package:elhanbly/core/security/widgets/security_alert_dialogs.dart';
import 'package:elhanbly/core/services/di.dart';
import 'package:elhanbly/core/services/screen_security_service.dart';
import 'package:elhanbly/core/widgets/ui_helpers/alert_message.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class PdfViewers extends StatefulWidget {
  final String? pdfurl;
  final String? name;
  const PdfViewers({super.key, required this.pdfurl, required this.name});

  @override
  State<PdfViewers> createState() => _PdfViewersState();
}

class _PdfViewersState extends State<PdfViewers> {
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

  String _getWatermarkText() {
    final student = userData?.student;
    final name = student?.name?.trim() ?? '';
    final phone = student?.phone?.trim() ?? '';

    if (name.isNotEmpty && phone.isNotEmpty) {
      return '$name\n$phone';
    } else if (name.isNotEmpty) {
      return name;
    } else if (phone.isNotEmpty) {
      return phone;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    if (_isBlocked || _isChecking) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.name ?? '')),
        body: const ColoredBox(
          color: Colors.black,
          child: SizedBox.expand(),
        ),
      );
    }

    final watermarkText = _getWatermarkText();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name ?? ''),
      ),
      body: PdfViewer.uri(
        Uri.parse(widget.pdfurl ?? ''),
        params: PdfViewerParams(
          pageOverlaysBuilder: watermarkText.isEmpty
              ? null
              : (context, pageRect, page) {
                  return [
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          size: pageRect.size,
                          painter: _PdfWatermarkPainter(text: watermarkText),
                        ),
                      ),
                    ),
                  ];
                },
          errorBannerBuilder: (context, error, stackTrace, documentRef) {
            return showErrorToast(error.toString());
          },
        ),
      ),
    );
  }
}

class _PdfWatermarkPainter extends CustomPainter {
  final String text;

  _PdfWatermarkPainter({required this.text});

  @override
  void paint(Canvas canvas, Size size) {
    if (text.isEmpty) return;

    final textStyle = TextStyle(
      color: Colors.black.withValues(alpha: 0.13),
      fontSize: 13,
      fontWeight: FontWeight.w600,
      height: 1.3,
    );

    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    const double stepX = 220.0;
    const double stepY = 160.0;

    canvas.save();

    for (double x = -stepX; x < size.width + stepX; x += stepX) {
      for (double y = -stepY; y < size.height + stepY; y += stepY) {
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(-math.pi / 6); // -30 degrees
        textPainter.paint(
          canvas,
          Offset(-textPainter.width / 2, -textPainter.height / 2),
        );
        canvas.restore();
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PdfWatermarkPainter oldDelegate) =>
      oldDelegate.text != text;
}
