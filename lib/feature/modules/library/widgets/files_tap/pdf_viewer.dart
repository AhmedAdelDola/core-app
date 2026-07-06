// import 'dart:typed_data';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// import '../../../../../core/consts/images.dart';
// import '../../../../../models/home_entities/courses/get_attachment_file_response.dart';

// class PdfViewer extends StatelessWidget {
//   final GetAttachmentFileResponse? pdf;

//   const PdfViewer({super.key, required this.pdf});

//   @override
//   Widget build(BuildContext context) {
//     if (pdf?.message == "هذا المحتوي غير مجاني") {
//       return Center(
//         child: Column(
//           children: [
//             Lottie.asset(
//               AppJsonFiles.lock,
//               width: 200,
//               height: 200,
//             ),
//             Text("هذا المحتوي غير مجاني"),
//           ],
//         ),
//       );
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(pdf?.data.sessionType ?? ''),
//       ),
//       body: SfPdfViewer.network(
//         pdf?.data.link ?? '',
//         onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
//           print('Error loading PDF: ${details.error}');
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text('Failed to load PDF: ${details.description}')),
//           );
//         },
//       ),
//     );
//   }
// }
