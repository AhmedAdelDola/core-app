import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/network/repository/repository_imports.dart';
import '../../../../../../models/ai_bot/course_ai_bot_model.dart';
import 'course_ai_bot_state.dart';

class CourseAiBotCubit extends Cubit<CourseAiBotState> {
  final Repository repo;
  final dynamic courseId;

  CourseAiBotCubit({
    required this.repo,
    required this.courseId,
  }) : super(CourseAiBotInitialState());

  static CourseAiBotCubit of(context) => BlocProvider.of<CourseAiBotCubit>(context);

  void _safeEmit(CourseAiBotState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  CourseAiBotHistoryResponse? history;
  List<AiBotMessage> messages = [];
  bool isSending = false;
  bool isResetting = false;

  void emitLoaded() {
    if (history == null) return;
    _safeEmit(CourseAiBotLoadedState(
      history: history!,
      messages: List.from(messages),
      isSending: isSending,
      isResetting: isResetting,
    ));
  }

  Future<void> fetchHistory() async {
    _safeEmit(CourseAiBotLoadingState());

    final result = await repo.getCourseAiBotHistory(courseId);

    result.fold(
      (l) {
        final errorMsg = l.toString();
        final isForbidden = errorMsg.contains('مشترك') || errorMsg.contains('403');
        _safeEmit(CourseAiBotErrorState(errorMsg, isForbidden: isForbidden));
      },
      (r) {
        history = r;
        messages = List<AiBotMessage>.from(r.messages);
        emitLoaded();
      },
    );
  }

  Future<bool> sendMessage({String? text, File? imageFile}) async {
    final trimmed = text?.trim() ?? '';
    if (trimmed.isEmpty && imageFile == null) return false;

    // Optimistically add the student message to the list
    final optimisticMessage = AiBotMessage(
      role: 'student',
      content: trimmed.isNotEmpty ? trimmed : 'سؤال مرفق بصورة',
      localImagePath: imageFile?.path,
      createdAt: DateTime.now(),
    );

    messages.add(optimisticMessage);
    isSending = true;
    emitLoaded();

    final result = await repo.sendCourseAiBotMessage(
      courseId: courseId,
      message: trimmed.isNotEmpty ? trimmed : null,
      imageFile: imageFile,
    );

    return result.fold(
      (l) {
        isSending = false;
        final errorMsg = l.toString();
        _safeEmit(SendAiBotMessageErrorState(errorMsg));
        emitLoaded();
        return false;
      },
      (r) {
        isSending = false;
        if (r.userMessage != null && messages.isNotEmpty) {
          final lastStudentIdx = messages.lastIndexWhere((m) => m.role == 'student');
          if (lastStudentIdx != -1) {
            messages[lastStudentIdx] = r.userMessage!;
          }
        }
        if (r.reply != null) {
          messages.add(r.reply!);
          _safeEmit(SendAiBotMessageSuccessState(r.reply!));
        }
        emitLoaded();
        return true;
      },
    );
  }

  Future<bool> resetChat() async {
    isResetting = true;
    emitLoaded();

    final result = await repo.resetCourseAiBotHistory(courseId);

    return result.fold(
      (l) {
        isResetting = false;
        emitLoaded();
        return false;
      },
      (r) {
        isResetting = false;
        messages.clear();
        _safeEmit(ResetAiBotHistorySuccessState());
        emitLoaded();
        return true;
      },
    );
  }
}
