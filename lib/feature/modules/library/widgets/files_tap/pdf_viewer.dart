import 'package:elhanbly/core/security/widgets/security_alert_dialogs.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name ?? ''),
      ),
      body: PdfViewer.uri(
        Uri.parse(widget.pdfurl ?? ''),
        params: PdfViewerParams(
          errorBannerBuilder: (context, error, stackTrace, documentRef) {
            return showErrorToast(error.toString());
          },
        ),
      ),
    );
  }
}
