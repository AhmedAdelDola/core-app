// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../../../core/network/repository/repository_imports.dart';
// import '../../../../../../models/home_entities/files/get_attachment_response.dart';

// part 'files_section_state.dart';

// class FilesSectionCubit extends Cubit<FilesSectionState> {
//   final Repository repo;
//   FilesSectionCubit(this.repo) : super(FilesSectionInitial());
//   static FilesSectionCubit of(context) => BlocProvider.of(context);

//   GetAttachmentResponse? attachmentResponse;
//   void getAttachment(int id) async {
//     emit(GetAttachmentLoadingState());
//     final f = await repo.getAttachment(id);
//     f.fold(
//       (l) => emit(GetAttachmentErrorState(l.toString())),
//       (r) {
//         attachmentResponse = r;
//         emit(GetAttachmentSuccessState());
//       },
//     );
//   }
// }
