// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dartz/dartz.dart';

// import '../../../../../core/network/repository/repository_imports.dart';
// import '../../../../../core/util/enums.dart';
// import '../../../../../models/quizes/create_quiz_response.dart';
// import '../../../../../models/quizes/library/get_all_subjects_response.dart';

// part 'create_quize_state.dart';

// class CreateQuizeCubit extends Cubit<CreateQuizeState> {
//   final Repository repo;
//   CreateQuizeCubit(this.repo) : super(const CreateQuizeState.initial());

//   static CreateQuizeCubit get(context) => BlocProvider.of(context);

//   // Modified to handle both quiz options and subjects
//   Future<void> getAllQuizeOptionsAndSubjects() async {
//     emit(state.copyWith(requestStatus: RequestStatus.loading));

//     // Fetch subjects first
//     final subjectsResult = await repo.getAllSubjects();

//     // Fetch quiz options
//     final optionsResult = await getCreateQuizeOption();

//     subjectsResult.fold(
//       (l) => emit(GetAllSubjectsErrorState(l.toString())),
//       (subjectsResponse) {
//         // Filter out unsubscribed subjects
//         notSubscribedSubjects = subjectsResponse.data?.data
//                 ?.where((subject) =>
//                     subject.subscriptionStatus == 0 &&
//                     subject.availability == 1)
//                 .toList() ??
//             [];

//         optionsResult.fold(
//           (l) => emit(state.copyWith(
//               requestStatus: RequestStatus.error,
//               errorMessage: l.toString(),
//               notSubscribedSubjects: notSubscribedSubjects)),
//           (r) => emit(state.copyWith(
//             options: notSubscribedSubjects,
//             requestStatus: RequestStatus.success,
//           )),
//         );
//       },
//     );
//   }

//   void toggleOption(GetAllSubjectsData option) {
//     final int optionIndex = state.options.indexWhere((e) => e.id == option.id);
//     if (optionIndex == -1) {
//       return;
//     }
//     List<GetAllSubjectsData> options = List.from(state.options);
//     options[optionIndex] =
//         options[optionIndex].copyWith(isSelected: !option.isSelected);
//     emit(state.copyWith(options: options));
//   }

//   void toggleSelectAll() {
//     if (state.isSelectAll()) {
//       List<GetAllSubjectsData> options = List.from(state.options);
//       options = options.map((e) => e.copyWith(isSelected: false)).toList();
//       emit(state.copyWith(options: options));
//     } else {
//       List<GetAllSubjectsData> options = List.from(state.options);
//       options = options.map((e) => e.copyWith(isSelected: true)).toList();
//       emit(state.copyWith(options: options));
//     }
//   }

//   /// getAllSubjects
//   List<GetAllSubjectsData> notSubscribedSubjects = [];
//   GetAllSubjectsResponse? subjects;
//   void getAllSubjects() async {
//     emit(GetAllSubjectsLoadingState());
//     final f = await repo.getAllSubjects();
//     f.fold(
//       (l) => emit(GetAllSubjectsErrorState(l.toString())),
//       (r) {
//         notSubscribedSubjects = [];
//         subjects = r;
//         print(r.data?.data);

//         r.data?.data?.forEach(
//           (element) {
//             if (element.subscriptionStatus == 0 && element.availability == 1) {
//               notSubscribedSubjects.add(element);
//             }
//           },
//         );
//         emit(GetAllSubjectsSuccessState(r));
//       },
//     );
//   }

//   Future<Either<dynamic, QuizOptionsResponse>> getCreateQuizeOption() async {
//     try {
//       return right(QuizOptionsResponse(
//           status: 200, message: 'Success', data: notSubscribedSubjects));
//     } catch (e) {
//       return left('Error generating quiz options: $e');
//     }
//   }
// }
