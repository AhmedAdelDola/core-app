import 'package:elhanbly/feature/modules/home/home_section/courses_section/cubit/course_ai_bot_cubit.dart';
import 'package:elhanbly/feature/modules/home/home_section/courses_section/cubit/course_ai_bot_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  Widget _buildChatList(
    CourseAiBotHistoryResponse? history,
    List<AiBotMessage> messages,
    bool isSending,
  ) {
    final welcomeText = history?.bot?.welcomeMessage ??
        'أهلاً بك يا بطل! أنا المساعد الذكي لكورس ${widget.courseTitle}. اسألني أي سؤال في المنهج وسأساعدك فوراً.';

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
    DateTime? time,
  }) {
    final timeStr = time != null ? DateFormat('hh:mm a', 'ar').format(time) : '';

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
                crossAxisAlignment:
                    isStudent ? CrossAxisAlignment.start : CrossAxisAlignment.start,
                children: [
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
      child: Row(
        children: [
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
                  hintText: 'اكتب سؤالك هنا عن محتوى الكورس...',
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
    );
  }

  void _handleSend(CourseAiBotCubit cubit) {
    final text = _textController.text.trim();
    if (text.isEmpty || cubit.isSending) return;

    _textController.clear();
    cubit.sendMessage(text);
    _scrollToBottom();
  }
}
