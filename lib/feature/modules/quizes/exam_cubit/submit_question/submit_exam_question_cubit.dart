// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../../core/network/repository/repository_imports.dart';

// part 'submit_exam_question_state.dart';

// class SubmitExamQuestionCubit extends Cubit<SubmitExamQuestionState> {
//   final Repository repository;
//   SubmitExamQuestionCubit({required this.repository})
//       : super(SubmitQuestionInitial());
//   Future<void> submitQuestionAnswerEvent({
//     required int questionId,
//     required int questionAnswerId,
//     required int examId,
//   }) async {
//     emit(SubmitQuestionLoading());
//     final response = await repository.submitExamQuestionAnswer(
//         questionId: questionId, answerId: questionAnswerId, examId: examId);
//     response.fold((l) => emit(SubmitQuestionError(message: l.toString())),
//         (r) => emit(SubmitQuestionSuccess()));
//   }

//   void emitQuestionIsAnswered() {
//     emit(SubmitQuestionSuccess());
//   }
// }
