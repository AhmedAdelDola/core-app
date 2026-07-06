// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../../core/consts/strings.dart';
// import '../../../../core/navigator/named_navigator_impl.dart';
// import '../../../../core/navigator/named_navigator_routes.dart';
// import '../../../../core/theme/colors/app_colors.dart';
// import '../../../../core/widgets/app_bar/custom_curved_appbar.dart';
// import '../../../../core/widgets/app_buttons/master_button.dart';
// import '../../../../core/widgets/app_texts/app_text.dart';
// import '../../../../core/widgets/app_texts/text_scroll.dart';
// import '../../../../core/widgets/loader/app_loader.dart';
// import '../../../../core/widgets/ui_helpers/extensions.dart';
// import '../../../../models/exams/get_exam_deatils.dart';
// import '../../home/home_section/courses_section/view/course_view/course_view_widgets/course_details_instructor.dart';
// import '../../home/home_section/courses_section/view/course_view/course_view_widgets/course_view_appbar.dart';
// import '../exam_screen.dart';
// import 'exam/exam_cubit.dart';

// class SingleExamScreen extends StatelessWidget {
//   const SingleExamScreen({
//     super.key,
//     required this.examId,
//     required this.name,
//     required this.courseName,
//     required this.ChapterName,
//   });
//   final String examId;
//   final String? name;
//   final String? courseName;
//   final String? ChapterName;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             AppTextScroll(
//               name ?? "تفاصيل الامتحان",
//               size: 28.sp,
//               weight: w500,
//               color: AppColors.kWhite,
//               align: TextAlign.start,
//               mode: TextScrollMode.begin,
//               delayBefore: Duration(milliseconds: 1300),
//             ),
//             Row(
//               children: [
//                 AppText(
//                   ChapterName ?? '',
//                   size: 20.sp,
//                   weight: w400,
//                   color: AppColors.kWhite,
//                 ),
//                 AppText(
//                   '-',
//                   size: 20.sp,
//                   weight: w400,
//                   color: AppColors.kWhite,
//                 ),
//                 AppText(
//                   courseName ?? '',
//                   size: 20.sp,
//                   weight: w400,
//                   color: AppColors.kWhite,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: BlocBuilder<ExamCubit, ExamState>(
//           bloc: ExamCubit.get(context)..getExamDetails(examId),
//           builder: (context, state) {
//             var cubit = ExamCubit.get(context);
//             final exam = cubit.singleExam?.data;
//             if (state.isLoading) {
//               return const Center(child: AppLoader());
//             }
//             if (state.errorMessage != null) {
//               return Center(child: Text(state.errorMessage!));
//             }

//             return SingleChildScrollView(
//               padding: EdgeInsets.all(16.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // --- Exam Image ---
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(16.r),
//                     child: Image.network(
//                       exam?.image ??
//                           "https://via.placeholder.com/400x200.png?text=Exam+Image",
//                       width: double.infinity,
//                       height: 200.h,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   SizedBox(height: 16.h),

//                   // --- Titles ---
//                   AppText(
//                     exam?.name ?? "Exam Title",
//                     size: 22.sp,
//                     weight: FontWeight.w700,
//                     color: AppColors.kPrimary,
//                   ),
//                   SizedBox(height: 4.h),
//                   AppText(
//                     "Course: ${exam?.courseName ?? '-'}",
//                     size: 16.sp,
//                     color: AppColors.kGray,
//                   ),
//                   AppText(
//                     "Chapter: ${exam?.chapterName ?? '-'}",
//                     size: 16.sp,
//                     color: AppColors.kGray,
//                   ),
//                   SizedBox(height: 12.h),

//                   // --- Info Cards ---
//                   Wrap(
//                     spacing: 12.w,
//                     runSpacing: 12.h,
//                     children: [
//                       _infoCard(
//                           Icons.access_time, "Duration", exam?.duration ?? "-"),
//                       _infoCard(
//                           Icons.star, "Points", "${exam?.points ?? 0} pts"),
//                       _infoCard(Icons.date_range, "Start",
//                           "${exam?.startDate ?? '-'} • ${exam?.startHour ?? ''}"),
//                       _infoCard(Icons.flag, "End",
//                           "${exam?.endDate ?? '-'} • ${exam?.endHour ?? ''}"),
//                       if (exam?.progress != null)
//                         _infoCard(
//                             Icons.percent, "Progress", "${exam?.progress}%"),
//                     ],
//                   ),

//                   SizedBox(height: 24.h),

//                   // --- Teacher Info ---
//                   if (exam?.teacher != null) ...[
//                     Divider(color: AppColors.kGray.withOpacity(0.2)),
//                     SizedBox(height: 12.h),
//                     AppText(
//                       'تفاصيل المدرس',
//                       size: 20.sp,
//                       align: TextAlign.start,
//                       weight: w500,
//                       color: AppColors.textColor,
//                     ),
//                     14.sbH,
//                     CourseInstructor(
//                       avatar: exam?.teacher?.avatar.toString() ??
//                           Strings.placeHolderImg,
//                       name: exam?.teacher?.name ?? '',
//                       telegram: exam?.teacher?.telegram ?? '',
//                       whatsapp: exam?.teacher?.whatsapp ?? '',
//                     ),
//                     SizedBox(height: 16.h),
//                   ],

//                   // --- Exam Result Info (if already solved) ---
//                   if (exam?.isStartExam == 1 && exam?.isShowResult == 1) ...[
//                     Divider(color: AppColors.kGray.withOpacity(0.2)),
//                     _infoRow("Result", exam?.result ?? "-"),
//                     _infoRow("Correct Answers",
//                         "${exam?.sucessAnswersCount ?? 0} / ${exam?.asksCount ?? 0}"),
//                     _infoRow(
//                         "Wrong Answers", "${exam?.wrongAnswersCount ?? 0}"),
//                     SizedBox(height: 24.h),
//                   ],

//                   // --- Main Button ---
//                   Center(
//                     child: MasterButton(
//                         text: _getButtonTitle(exam!),
//                         onPressed: () async {
//                           if (exam.isJoined == 1 && exam.isStartExam == 1) {
//                             Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => ExamScreen(
//                                           id: exam.id ?? 0,
//                                           chapterTitle: exam.chapterName,
//                                           duration: Duration(
//                                               minutes: int.tryParse(
//                                                       exam.duration ?? '0') ??
//                                                   0),
//                                           showResults: true,
//                                           subjectTitle: exam.courseName,
//                                           title: exam.name,
//                                         )));
//                           } else {
//                             await cubit.startExam(exam.id.toString());
//                             Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => ExamScreen(
//                                           id: exam.id ?? 0,
//                                           chapterTitle: exam.chapterName,
//                                           duration: Duration(
//                                               minutes: int.tryParse(
//                                                       exam.duration ?? '0') ??
//                                                   0),
//                                           showResults: exam.isShowResult == 1,
//                                           subjectTitle: exam.courseName,
//                                           title: exam.name,
//                                         )));
//                           }
//                         }),
//                   ),
//                 ],
//               ),
//             );
//           }),
//     );
//   }

//   Widget _infoCard(IconData icon, String label, String value) {
//     return Container(
//       padding: EdgeInsets.all(12.w),
//       width: 160.w,
//       decoration: BoxDecoration(
//         color: AppColors.kWhite,
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: AppColors.kPrimary),
//           SizedBox(height: 6.h),
//           AppText(label, size: 14.sp, color: AppColors.kGray),
//           AppText(value, size: 16.sp, weight: FontWeight.w600),
//         ],
//       ),
//     );
//   }

//   Widget _infoRow(String title, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           AppText(title, size: 16.sp, color: AppColors.kGray),
//           AppText(value,
//               size: 16.sp, weight: FontWeight.w600, color: AppColors.kPrimary),
//         ],
//       ),
//     );
//   }

//   Widget _contactIcon(
//       {required IconData icon, required Color color, VoidCallback? onTap}) {
//     return Padding(
//       padding: EdgeInsets.only(right: 8.w),
//       child: InkWell(
//         onTap: onTap,
//         child: CircleAvatar(
//           radius: 22.r,
//           backgroundColor: color.withOpacity(0.15),
//           child: Icon(icon, color: color, size: 22.sp),
//         ),
//       ),
//     );
//   }

//   String _getButtonTitle(Data exam) {
//     if (exam.isJoined == 1 && exam.isStartExam == 1) {
//       return "عرض النتيجة"; // View Result
//     } else {
//       return "ابدأ الامتحان"; // Start
//     }
//   }
// }
