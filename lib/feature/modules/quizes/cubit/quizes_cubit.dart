// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../../core/error/failures.dart';
// import '../../../../../core/usecases/usecases.dart';
// import '../../../../../core/util/logger.dart';
// import '../../../domain/entity/quizes_response.dart';
// import '../../../domain/usecase/quizes_use_case.dart';
//
// part 'quizes_state.dart';
//
// class QuizesCubit extends Cubit<QuizesState> {
//   QuizesCubit({required this.useCase}) : super(QuizesInitialState());
//   static QuizesCubit get(context) => BlocProvider.of(context);
//   final QuizesUsecase useCase;
//
//   Future<void> fQuizes() async {
//     emit(QuizesLoadingState());
//     final Either<Failure, QuizesResponse> f =
//         await useCase(NoParams());
//     f.fold((Failure fail) {
//       String message = 'please try again later';
//       if (fail is ServerFailure) {
//         PrintLog.e(fail.message);
//         message = fail.message;
//       }
//
//       emit(QuizesErrorState(message: message));
//     }, (QuizesResponse response) {
//       emit(QuizesSuccessState(res: response));
//     });
//   }
// }
