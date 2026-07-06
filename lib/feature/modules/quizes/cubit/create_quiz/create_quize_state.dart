// part of 'create_quize_cubit.dart';

// class CreateQuizeState extends Equatable {
//   final List<GetAllSubjectsData> options;
//   final RequestStatus requestStatus;
//   final String? errorMessage;

//   const CreateQuizeState({
//     this.options = const [],
//     this.requestStatus = RequestStatus.initial,
//     this.errorMessage,
//   });

//   const CreateQuizeState.initial() : this();

//   CreateQuizeState copyWith({
//     List<GetAllSubjectsData>? options,
//     RequestStatus? requestStatus,
//     String? errorMessage,
//     List<GetAllSubjectsData>? notSubscribedSubjects,
//   }) {
//     return CreateQuizeState(
//       options: options ?? this.options,
//       requestStatus: requestStatus ?? this.requestStatus,
//       errorMessage: errorMessage ?? this.errorMessage,
//     );
//   }

//   bool isSelectAll() {
//     return options.isNotEmpty && options.every((option) => option.isSelected);
//   }

//   @override
//   List<Object?> get props => [
//         options,
//         requestStatus,
//         errorMessage,
//       ];
// }

// // Existing state classes can remain the same
// class GetAllSubjectsLoadingState extends CreateQuizeState {}

// class GetAllSubjectsErrorState extends CreateQuizeState {
//   final String error;

//   GetAllSubjectsErrorState(this.error);
// }

// class GetAllSubjectsSuccessState extends CreateQuizeState {
//   final GetAllSubjectsResponse response;

//   GetAllSubjectsSuccessState(this.response);
// }
