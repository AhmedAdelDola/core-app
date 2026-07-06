// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:permission_handler/permission_handler.dart';

// import '../../navigator/named_navigator_impl.dart';
// import '../../services/di.dart';
// import '../../theme/colors/app_colors.dart';
// import '../text_field/master_text_field.dart';
// import 'custom_curved_appbar.dart';

// class QRScannerPage extends StatefulWidget {
//   @override
//   _QRScannerPageState createState() => _QRScannerPageState();
// }

// class _QRScannerPageState extends State<QRScannerPage> {
//   final MobileScannerController controller = MobileScannerController(
//     detectionSpeed: DetectionSpeed.noDuplicates,
//     returnImage: false,
//   );

//   @override
//   void initState() {
//     super.initState();
//     _requestCameraPermission();
//   }

//   Future<void> _requestCameraPermission() async {
//     final status = await Permission.camera.status;
//     if (status.isDenied) {
//       await Permission.camera.request();
//     }
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController textController = TextEditingController();

//     return BlocProvider(
//       create: (context) => di<HomeCubit>(),
//       child: BlocBuilder<HomeCubit, HomeStates>(
//         builder: (context, state) {
//           var cubit = HomeCubit.of(context);

//           return Scaffold(
//             extendBodyBehindAppBar: true,
//             appBar: PreferredSize(
//               preferredSize: Size.fromHeight(kToolbarHeight),
//               child: CustomAppBar(title: 'Scan QR Code'),
//             ),
//             body: Stack(
//               children: [
//                 // Mobile Scanner
//                 MobileScanner(
//                   controller: controller,
//                   onDetect: (BarcodeCapture barcodeCapture) {
//                     for (Barcode barcode in barcodeCapture.barcodes) {
//                       debugPrint('Detected barcode: ${barcode.rawValue}');
//                       if (barcode.rawValue != null) {
//                         cubit.ScanQr(barcode.rawValue.toString()).then((value) {
//                           NamedNavigatorImpl.pop();
//                         });
//                       }
//                     }
//                   },
//                 ),

//                 // Custom Overlay with cutout
//                 CustomPaint(
//                   painter: ScannerOverlayPainter(
//                     scanAreaSize: 280,
//                     borderColor: AppColors.kPrimary,
//                     borderWidth: 1,
//                     borderLength: 100,
//                     borderRadius: 20,
//                   ),
//                   child: Container(),
//                 ),

//                 // Bottom Sheet
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     color: Colors.black,
//                     padding: EdgeInsets.all(30),
//                     child: Directionality(
//                       textDirection: TextDirection.ltr,
//                       child: MasterTextField(
//                         controller: textController,
//                         hintText: 'Enter Code',
//                         borderRadius: 13,
//                         borderWidth: 5,
//                         borderColor: AppColors.kPrimary,
//                         suffixWidget: Container(
//                           decoration: BoxDecoration(
//                             color: AppColors.kPrimary,
//                             borderRadius: BorderRadius.circular(11),
//                           ),
//                           child: IconButton(
//                             onPressed: () {
//                               cubit.ScanQr(textController.text).then((value) {
//                                 NamedNavigatorImpl.pop();
//                               });
//                             },
//                             icon: Icon(
//                               Icons.send,
//                               color: AppColors.disabledBtnColor,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // Custom painter for scanner overlay with cutout
// class ScannerOverlayPainter extends CustomPainter {
//   final double scanAreaSize;
//   final Color borderColor;
//   final double borderWidth;
//   final double borderLength;
//   final double borderRadius;

//   ScannerOverlayPainter({
//     required this.scanAreaSize,
//     required this.borderColor,
//     required this.borderWidth,
//     required this.borderLength,
//     required this.borderRadius,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final double scanAreaLeft = (size.width - scanAreaSize) / 2;
//     final double scanAreaTop = (size.height - scanAreaSize) / 2;
//     final Rect scanAreaRect = Rect.fromLTWH(
//       scanAreaLeft,
//       scanAreaTop,
//       scanAreaSize,
//       scanAreaSize,
//     );

//     // Draw semi-transparent overlay
//     final Paint overlayPaint = Paint()..color = Colors.black.withOpacity(0.5);

//     canvas.drawPath(
//       Path.combine(
//         PathOperation.difference,
//         Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
//         Path()
//           ..addRRect(
//             RRect.fromRectAndRadius(
//               scanAreaRect,
//               Radius.circular(borderRadius),
//             ),
//           ),
//       ),
//       overlayPaint,
//     );

//     // Draw corner borders
//     final Paint borderPaint = Paint()
//       ..color = borderColor
//       ..strokeWidth = borderWidth
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;

//     // Top-left corner
//     canvas.drawPath(
//       Path()
//         ..moveTo(scanAreaLeft + borderRadius, scanAreaTop)
//         ..lineTo(scanAreaLeft + borderLength, scanAreaTop)
//         ..moveTo(scanAreaLeft, scanAreaTop + borderRadius)
//         ..lineTo(scanAreaLeft, scanAreaTop + borderLength),
//       borderPaint,
//     );

//     // Top-right corner
//     canvas.drawPath(
//       Path()
//         ..moveTo(scanAreaLeft + scanAreaSize - borderLength, scanAreaTop)
//         ..lineTo(scanAreaLeft + scanAreaSize - borderRadius, scanAreaTop)
//         ..moveTo(scanAreaLeft + scanAreaSize, scanAreaTop + borderRadius)
//         ..lineTo(scanAreaLeft + scanAreaSize, scanAreaTop + borderLength),
//       borderPaint,
//     );

//     // Bottom-left corner
//     canvas.drawPath(
//       Path()
//         ..moveTo(scanAreaLeft, scanAreaTop + scanAreaSize - borderLength)
//         ..lineTo(scanAreaLeft, scanAreaTop + scanAreaSize - borderRadius)
//         ..moveTo(scanAreaLeft + borderRadius, scanAreaTop + scanAreaSize)
//         ..lineTo(scanAreaLeft + borderLength, scanAreaTop + scanAreaSize),
//       borderPaint,
//     );

//     // Bottom-right corner
//     canvas.drawPath(
//       Path()
//         ..moveTo(scanAreaLeft + scanAreaSize,
//             scanAreaTop + scanAreaSize - borderLength)
//         ..lineTo(scanAreaLeft + scanAreaSize,
//             scanAreaTop + scanAreaSize - borderRadius)
//         ..moveTo(scanAreaLeft + scanAreaSize - borderRadius,
//             scanAreaTop + scanAreaSize)
//         ..lineTo(scanAreaLeft + scanAreaSize - borderLength,
//             scanAreaTop + scanAreaSize),
//       borderPaint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
