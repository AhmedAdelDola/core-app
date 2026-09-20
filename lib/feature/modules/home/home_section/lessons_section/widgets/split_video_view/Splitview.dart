import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:elhanbly/core/widgets/app_texts/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_split_view/multi_split_view.dart';
import '../../../../../../../core/security/widgets/security_alert_dialogs.dart';
import '../../../../../../../core/services/di.dart';
import '../../../../../../../core/services/screen_security_service.dart';
import '../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../models/Session/show_video_response.dart';
import '../../../../../library/widgets/files_tap/pdf_viewer.dart';
import '../../../courses_section/view/course_view/subscribe_view/tabs/course_files.dart';
import '../../cubit/lessons_section_cubit.dart';
import 'video_player.dart';

class SplitViewScreen extends StatefulWidget {
  final String pdfUrl,pdfname;
  final ShowVideo? model;

  const SplitViewScreen({
    Key? key,
    required this.pdfUrl,
    required this.model, required this.pdfname,
  }) : super(key: key);

  @override
  _SplitViewScreenState createState() => _SplitViewScreenState();
}

class _SplitViewScreenState extends State<SplitViewScreen> {
  late MultiSplitViewController _controller;
  bool fingerprint = false;
  bool isSplitEnabled = false; // Track split view state
  bool _isChecking = true;
  bool _isBlocked = false;

  @override
  void initState() {
    super.initState();
    ScreenSecurityService.enable();
    ScreenSecurityService.addListener(_onRecordingChanged);
    _checkRecording();
    _controller = MultiSplitViewController(areas: [
      Area(
          builder: (context, area) => VideoPlayer(
                model: widget.model,
              )),
      Area(builder: (context, area) => PdfViewers(pdfurl:widget.pdfUrl , name: widget.pdfname,)),
    ]);
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      deviceInfo.androidInfo.then((value) {
        if (value.isPhysicalDevice) {
          setState(() {
            fingerprint = true;
          });
        }
      });
    } else {
      deviceInfo.iosInfo.then((value) {
        if (value.isPhysicalDevice) {
          setState(() {
            fingerprint = true;
          });
        }
      });
    }
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

  void _toggleSplitView() {
    setState(() {
      isSplitEnabled = !isSplitEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isBlocked || _isChecking) {
      return const Scaffold(backgroundColor: Colors.black);
    }
    bool isTablet = MediaQuery.of(context).size.width >= 600;

    return BlocProvider(
        create: (context) => di<LessonsSectionCubit>(),
        child: BlocBuilder<LessonsSectionCubit, LessonsSectionState>(
            builder: (context, selectorState) {
          var cubit = LessonsSectionCubit.of(context);

          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  // Toggle button for split view
                  Padding(
                    padding: EdgeInsets.all(16.sp),
                    child: Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _toggleSplitView,
                          icon: Icon(
                            isSplitEnabled
                                ? Icons.close_fullscreen
                                : Icons.splitscreen,
                            color: AppColors.kWhite,
                          ),
                          label: AppText(
                            isSplitEnabled ? "Close Split" : "Open Split",
                            color: AppColors.kWhite,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.kPrimary,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.sp,
                              vertical: 12.sp,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.sp),
                            ),
                          ),
                        ),
                        if (isTablet && isSplitEnabled) ...[
                          SizedBox(width: 16.sp),
                          Expanded(child: AxisItem()),
                        ],
                      ],
                    ),
                  ),
                  Expanded(
                    child: isSplitEnabled
                        ? MultiSplitView(
                            controller: _controller,
                            axis: isTablet ? cubit.currentAxis : Axis.vertical,
                            dividerBuilder: (axis, index, resizable, dragging,
                                    highlighted, themeData) =>
                                Container(
                              color: const Color.fromARGB(255, 155, 92, 15),
                            ),
                          )
                        : VideoPlayer(
                            model: widget.model,
                          ),
                  ),
                ],
              ),
            ),
          );
        }));
  }
  @override
  void dispose() {
    ScreenSecurityService.removeListener(_onRecordingChanged);
    ScreenSecurityService.disable();
    super.dispose();
  }
}

class AxisItem extends StatelessWidget {
  AxisItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonsSectionCubit, LessonsSectionState>(
      builder: (context, selectorState) {
        var cubit = LessonsSectionCubit.of(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                    onTap: () => cubit.setAxis(Axis.horizontal),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.sp, vertical: 12.sp),
                      decoration: BoxDecoration(
                        color: cubit.currentAxis == Axis.horizontal
                            ? AppColors.kPrimary
                            : AppColors.kWhite,
                        border: Border.all(color: AppColors.borderColor),
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            cubit.currentAxis == Axis.horizontal
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            size: 20.sp,
                            color: cubit.currentAxis == Axis.horizontal
                                ? AppColors.kWhite
                                : AppColors.kGrayText,
                          ),
                          SizedBox(width: 4.sp),
                          AppText(
                            "Horizontal",
                            color: cubit.currentAxis == Axis.horizontal
                                ? AppColors.kWhite
                                : AppColors.textColor2,
                          ),
                        ],
                      ),
                    )),
              ),
              SizedBox(width: 8.sp),
              Expanded(
                child: GestureDetector(
                    onTap: () => cubit.setAxis(Axis.vertical),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.sp, vertical: 12.sp),
                      decoration: BoxDecoration(
                        color: cubit.currentAxis == Axis.vertical
                            ? AppColors.kPrimary
                            : AppColors.kWhite,
                        border: Border.all(color: AppColors.borderColor),
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            cubit.currentAxis == Axis.vertical
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            size: 20.sp,
                            color: cubit.currentAxis == Axis.vertical
                                ? AppColors.kWhite
                                : AppColors.kGrayText,
                          ),
                          SizedBox(width: 4.sp),
                          AppText(
                            "Vertical",
                            color: cubit.currentAxis == Axis.vertical
                                ? AppColors.kWhite
                                : AppColors.textColor2,
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  
}
