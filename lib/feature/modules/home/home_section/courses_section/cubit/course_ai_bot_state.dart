import 'package:elhanbly/models/ai_bot/course_ai_bot_model.dart';

abstract class CourseAiBotState {}

class CourseAiBotInitialState extends CourseAiBotState {}

class CourseAiBotLoadingState extends CourseAiBotState {}

class CourseAiBotLoadedState extends CourseAiBotState {
  final CourseAiBotHistoryResponse history;
  final List<AiBotMessage> messages;
  final bool isSending;
  final bool isResetting;

  CourseAiBotLoadedState({
    required this.history,
    required this.messages,
    this.isSending = false,
    this.isResetting = false,
  });

  CourseAiBotLoadedState copyWith({
    CourseAiBotHistoryResponse? history,
    List<AiBotMessage>? messages,
    bool? isSending,
    bool? isResetting,
  }) {
    return CourseAiBotLoadedState(
      history: history ?? this.history,
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      isResetting: isResetting ?? this.isResetting,
    );
  }
}

class CourseAiBotErrorState extends CourseAiBotState {
  final String error;
  final bool isForbidden;

  CourseAiBotErrorState(this.error, {this.isForbidden = false});
}

class SendAiBotMessageSuccessState extends CourseAiBotState {
  final AiBotMessage reply;

  SendAiBotMessageSuccessState(this.reply);
}

class SendAiBotMessageErrorState extends CourseAiBotState {
  final String error;

  SendAiBotMessageErrorState(this.error);
}

class ResetAiBotHistorySuccessState extends CourseAiBotState {}
