// part of '../../library_imports.dart';

// class ScreenItem extends StatefulWidget {
//   final int itemCount;
//   bool isVisible;
//   ScreenItem({super.key, required this.itemCount, required this.isVisible});
//
//   @override
//   State<ScreenItem> createState() => _ScreenItemState();
// }
//
// class _ScreenItemState extends State<ScreenItem> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ScreenItemRow(
//           onPressed: () {
//             widget.isVisible = !widget.isVisible;
//             setState(() {});
//           },
//           isVisible: widget.isVisible,
//         ),
//         8.sbH,
//         Visibility(
//           visible: widget.isVisible,
//           child: SizedBox(
//             height: widget.itemCount * 100.h,
//             child: ListView.separated(
//               padding: EdgeInsets.zero,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: widget.itemCount,
//               separatorBuilder: (context, index) => 16.sbH,
//               itemBuilder: (context, index) => const ScreenItemCard(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ScreenItemCard extends StatelessWidget {
//   const ScreenItemCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 110.h,
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration:
//           BoxDecoration(border: Border.all(color: AppColors.borderColor), borderRadius: BorderRadius.circular(12.r)),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 30.r,
//             backgroundColor: AppColors.textColor4.withOpacity(0.1),
//             child: const Icon(Icons.file_copy),
//           ),
//           16.sbW,
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.63,
//                 child: Row(
//                   children: [
//                     AppText(
//                       'File Name',
//                       color: AppColors.textColor,
//                       size: 16.sp,
//                       weight: w500,
//                     ),
//                     const Spacer(),
//                     const PriceContainer(title: 'مجاني'),
//                   ],
//                 ),
//               ),
//               // 8.sbH,
//               AppText(
//                 'أكملت 80%',
//                 color: AppColors.textColor2,
//                 size: 14.sp,
//                 weight: w400,
//               ),
//               16.sbH,
//               // create indicator
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.63,
//                 child: LinearPercentIndicator(
//                   lineHeight: 8.h,
//                   percent: 0.8,
//                   barRadius: Radius.circular(12.r),
//                   isRTL: true,
//                   progressColor: AppColors.kDarkModeGreen,
//                   backgroundColor: AppColors.kDarkModeGreen.withOpacity(0.1),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
