// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../../core/network/repository/repository_imports.dart';

// part 'submit_question_state.dart';

// class SubmitQuestionCubit extends Cubit<SubmitQuestionState> {
//   final Repository repository;
//   SubmitQuestionCubit({required this.repository}) : super(SubmitQuestionInitial());
//   Future<void> submitQuestionAnswerEvent({
//     required int questionId,
//     required int questionAnswerId,
//     required int quizeId,
//   }) async {
//     emit(SubmitQuestionLoading());
//     final response =
//         await repository.submitQuestionAnswer(questionId: questionId, answerId: questionAnswerId, quizId: quizeId);
//     response.fold((l) => emit(SubmitQuestionError(message: l.toString())), (r) => emit(SubmitQuestionSuccess()));
//   }

//   void emitQuestionIsAnswered() {
//     emit(SubmitQuestionSuccess());
//   }
// }
