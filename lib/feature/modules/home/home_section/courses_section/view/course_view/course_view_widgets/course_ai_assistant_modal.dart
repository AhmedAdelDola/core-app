import 'dart:io';

import 'package:elhanbly/feature/modules/home/home_section/courses_section/cubit/course_ai_bot_cubit.dart';
import 'package:elhanbly/feature/modules/home/home_section/courses_section/cubit/course_ai_bot_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../core/services/di.dart';
import '../../../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../../../core/widgets/loader/app_loader.dart';
import '../../../../../../../../core/widgets/ui_helpers/alert_message.dart';
import '../../../../../../../../models/ai_bot/course_ai_bot_model.dart';


class CourseAiAssistantModal extends StatefulWidget {
  final dynamic courseId;
  final String courseTitle;

  const CourseAiAssistantModal({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  static Future<void> show({
    required BuildContext context,
    required dynamic courseId,
    required String courseTitle,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (ctx) => CourseAiAssistantModal(
        courseId: courseId,
        courseTitle: courseTitle,
      ),
    );
  }

  @override
  State<CourseAiAssistantModal> createState() => _CourseAiAssistantModalState();
}

class _CourseAiAssistantModalState extends State<CourseAiAssistantModal> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _confirmReset(BuildContext context, CourseAiBotCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          'مسح سجل المحادثة',
          style: TextStyle(
            fontFamily: 'DINNextLT',
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            color: AppColors.textColor,
          ),
        ),
        content: Text(
          'هل تريد مسح سجل المحادثة وبدء جلسة جديدة مع المساعد الذكي؟',
          style: TextStyle(
            fontFamily: 'DINNextLT',
            fontSize: 14.sp,
            color: AppColors.textColor2,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: 'DINNextLT',
                color: AppColors.textColor2,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              final success = await cubit.resetChat();
              if (success) {
                showSuccessToast('تم مسح المحادثة بنجاح.');
              }
            },
            child: Text(
              'مسح المحادثة',
              style: TextStyle(
                fontFamily: 'DINNextLT',
                color: AppColors.red,
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenH = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => di<CourseAiBotCubit>(param1: widget.courseId)..fetchHistory(),
      child: BlocConsumer<CourseAiBotCubit, CourseAiBotState>(
        listener: (context, state) {
          if (state is SendAiBotMessageErrorState) {
            showErrorToast(state.error);
          } else if (state is SendAiBotMessageSuccessState || state is CourseAiBotLoadedState) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          final cubit = CourseAiBotCubit.of(context);
          final history = cubit.history;
          final messages = cubit.messages;
          final isSending = cubit.isSending;

          return Container(
            height: screenH * 0.88,
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top drag handle
                Container(
                  margin: EdgeInsets.only(top: 10.h, bottom: 6.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.kLightGray.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),

                // Header
                _buildHeader(context, cubit, history, messages),
                const Divider(height: 1, color: AppColors.borderColor),

                // Body (Messages or Loader or Error)
                Expanded(
                  child: state is CourseAiBotLoadingState
                      ? const Center(child: AppLoader())
                      : state is CourseAiBotErrorState && history == null
                          ? _buildErrorView(context, cubit, state.error)
                          : _buildChatList(history, messages, isSending),
                ),

                // Footer (Input Bar)
                Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: _buildInputBar(cubit, isSending),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    CourseAiBotCubit cubit,
    CourseAiBotHistoryResponse? history,
    List<AiBotMessage> messages,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          // Bot Avatar
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: AppColors.kPrimary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text('🤖', style: TextStyle(fontSize: 22)),
          ),
          SizedBox(width: 12.w),

          // Bot name and course info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  history?.bot?.name ?? 'المساعد الذكي للمادة',
                  weight: w700,
                  size: 15.sp,
                  color: AppColors.kBlack,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                AppText(
                  widget.courseTitle,
                  size: 12.sp,
                  color: AppColors.textColor2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Actions: Reset & Close
          if (messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textColor4),
              tooltip: 'مسح المحادثة',
              onPressed: cubit.isResetting ? null : () => _confirmReset(context, cubit),
            ),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.textColor),
            tooltip: 'إغلاق',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (file != null) {
        setState(() {
          _selectedImage = File(file.path);
        });
      }
    } catch (e) {
      showErrorToast('تعذر اختيار الصورة.');
    }
  }

  void _showImageSourcePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.kWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'إرفاق صورة للسؤال',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'DINNextLT',
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.camera_alt_rounded, color: AppColors.kPrimary, size: 22.r),
                ),
                title: Text(
                  'التقاط صورة بالكاميرا',
                  style: TextStyle(
                    fontFamily: 'DINNextLT',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.photo_library_rounded, color: AppColors.kPrimary, size: 22.r),
                ),
                title: Text(
                  'اختيار من المعرض',
                  style: TextStyle(
                    fontFamily: 'DINNextLT',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context, {String? imageUrl, String? localPath}) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(12.r),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              clipBehavior: Clip.none,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: localPath != null && File(localPath).existsSync()
                      ? Image.file(File(localPath))
                      : (imageUrl != null
                          ? Image.network(imageUrl)
                          : const SizedBox.shrink()),
                ),
              ),
            ),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
              ),
              icon: const Icon(Icons.close_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(
    CourseAiBotHistoryResponse? history,
    List<AiBotMessage> messages,
    bool isSending,
  ) {
    final welcomeText = history?.bot?.welcomeMessage ??
        'أهلاً بك يا بطل! أنا المساعد الذكي لكورس ${widget.courseTitle}. اسألني أي سؤال في المنهج أو أرفق صورة وسأساعدك فوراً.';

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: 1 + messages.length + (isSending ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == 0) {
          // Welcome message
          return _buildMessageBubble(
            isStudent: false,
            text: welcomeText,
            time: null,
          );
        }

        final messageIndex = index - 1;
        if (messageIndex < messages.length) {
          final msg = messages[messageIndex];
          return _buildMessageBubble(
            isStudent: msg.role == 'student',
            text: msg.content,
            imageUrl: msg.imageUrl,
            localImagePath: msg.localImagePath,
            time: msg.createdAt,
          );
        }

        // Typing indicator
        return _buildTypingBubble();
      },
    );
  }

  Widget _buildMessageBubble({
    required bool isStudent,
    required String text,
    String? imageUrl,
    String? localImagePath,
    DateTime? time,
  }) {
    final timeStr = time != null ? DateFormat('hh:mm a', 'ar').format(time) : '';
    final hasImage = localImagePath != null || (imageUrl != null && imageUrl.isNotEmpty);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: isStudent ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isStudent) ...[
            Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                color: AppColors.kPrimary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.person, size: 18.r, color: AppColors.kPrimary),
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isStudent ? AppColors.kPrimary : const Color(0xFFF3F5F8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: isStudent ? Radius.zero : Radius.circular(16.r),
                  bottomRight: isStudent ? Radius.circular(16.r) : Radius.zero,
                ),
                border: isStudent
                    ? null
                    : Border.all(color: AppColors.borderColor.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasImage) ...[
                    GestureDetector(
                      onTap: () => _showFullImage(
                        context,
                        imageUrl: imageUrl,
                        localPath: localImagePath,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: 220.h,
                            maxWidth: 240.w,
                          ),
                          margin: EdgeInsets.only(bottom: text.isNotEmpty ? 6.h : 0),
                          child: localImagePath != null && File(localImagePath).existsSync()
                              ? Image.file(
                                  File(localImagePath),
                                  fit: BoxFit.cover,
                                )
                              : (imageUrl != null && imageUrl.isNotEmpty)
                                  ? Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (ctx, child, progress) {
                                        if (progress == null) return child;
                                        return Container(
                                          height: 140.h,
                                          color: Colors.black12,
                                          child: const Center(
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          ),
                                        );
                                      },
                                      errorBuilder: (ctx, _, __) => Container(
                                        height: 100.h,
                                        color: Colors.black12,
                                        child: const Center(
                                          child: Icon(Icons.broken_image_outlined, color: Colors.grey),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ],
                  if (text.isNotEmpty && text != 'سؤال مرفق بصورة')
                    SelectableText(
                      text,
                      style: TextStyle(
                        fontFamily: 'DINNextLT',
                        fontSize: 14.sp,
                        color: isStudent ? AppColors.kWhite : AppColors.textColor,
                        height: 1.45,
                      ),
                    ),
                  if (timeStr.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      timeStr,
                      style: TextStyle(
                        fontFamily: 'DINNextLT',
                        fontSize: 10.sp,
                        color: isStudent
                            ? AppColors.kWhite.withValues(alpha: 0.7)
                            : AppColors.textColor4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (!isStudent) ...[
            SizedBox(width: 8.w),
            Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                color: const Color(0xFFE8EEF5),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text('🤖', style: TextStyle(fontSize: 16)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingBubble() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5F8),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(),
                SizedBox(width: 4.w),
                _buildDot(),
                SizedBox(width: 4.w),
                _buildDot(),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 32.r,
            height: 32.r,
            decoration: const BoxDecoration(
              color: Color(0xFFE8EEF5),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text('🤖', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 6.r,
      height: 6.r,
      decoration: BoxDecoration(
        color: AppColors.kPrimary.withValues(alpha: 0.7),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, CourseAiBotCubit cubit, String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline_rounded, size: 48.r, color: AppColors.red),
            SizedBox(height: 12.h),
            AppText(
              error,
              align: TextAlign.center,
              size: 14.sp,
              color: AppColors.textColor2,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              onPressed: () => cubit.fetchHistory(),
              child: AppText('إعادة المحاولة', color: AppColors.kWhite, weight: w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(CourseAiBotCubit cubit, bool isSending) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Preview Container (if selected)
          if (_selectedImage != null) ...[
            Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.kPrimary.withValues(alpha: 0.3)),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.file(
                      _selectedImage!,
                      width: 72.r,
                      height: 72.r,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: isSending
                          ? null
                          : () {
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration:  BoxDecoration(
                          color: Colors.black87,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Input Row
          Row(
            children: [
              // Image Picker Button
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 38.r, minHeight: 38.r),
                icon: Icon(
                  Icons.add_photo_alternate_outlined,
                  color: _selectedImage != null ? AppColors.kPrimary : AppColors.textColor4,
                  size: 26.r,
                ),
                tooltip: 'إرفاق صورة',
                onPressed: isSending ? null : () => _showImageSourcePicker(context),
              ),
              SizedBox(width: 4.w),

              // Text field
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F6F9),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.6)),
                  ),
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.send,
                    enabled: !isSending,
                    minLines: 1,
                    maxLines: 4,
                    onSubmitted: (val) => _handleSend(cubit),
                    style: TextStyle(
                      fontFamily: 'DINNextLT',
                      fontSize: 14.sp,
                      color: AppColors.textColor,
                    ),
                    decoration: InputDecoration(
                      hintText: _selectedImage != null
                          ? 'أضف تعليقاً على الصورة (اختياري)...'
                          : 'اكتب سؤالك هنا عن محتوى الكورس...',
                      hintStyle: TextStyle(
                        fontFamily: 'DINNextLT',
                        fontSize: 13.sp,
                        color: AppColors.hintColor,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),

              // Send button
              InkWell(
                onTap: isSending ? null : () => _handleSend(cubit),
                borderRadius: BorderRadius.circular(24.r),
                child: Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: isSending ? AppColors.disabledBtnColor : AppColors.kPrimary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: isSending
                      ? SizedBox(
                          width: 18.r,
                          height: 18.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.textColor2,
                          ),
                        )
                      : Icon(
                          Icons.send_rounded,
                          color: AppColors.kWhite,
                          size: 20.r,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleSend(CourseAiBotCubit cubit) {
    final text = _textController.text.trim();
    final image = _selectedImage;
    if ((text.isEmpty && image == null) || cubit.isSending) return;

    _textController.clear();
    setState(() {
      _selectedImage = null;
    });
    cubit.sendMessage(text: text, imageFile: image);
    _scrollToBottom();
  }
}

