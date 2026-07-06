import 'dart:typed_data';
import 'dart:io';
import 'package:elhanbly/core/widgets/ui_helpers/alert_message.dart';
import 'package:elhanbly/models/Session/get_session_info_response.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../core/consts/images.dart';
import 'package:pdfrx/pdfrx.dart';

class PdfViewers extends StatelessWidget {
  final String? pdfurl;
final String? name ;
  const PdfViewers({super.key, required this.pdfurl, required this.name});

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: Text(name ?? ''),
      ),
      body: PdfViewer.uri( Uri.parse(pdfurl ?? ''),
        params: PdfViewerParams(errorBannerBuilder: (context, error, stackTrace, documentRef) {
          print(pdfurl);
        return  showErrorToast(error.toString());
          
          },),
       
      ),
    );
  }
}
