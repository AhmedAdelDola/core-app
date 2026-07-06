part of 'files_section_cubit.dart';

class FilesSectionState {}

class FilesSectionInitial extends FilesSectionState {}

class GetAttachmentLoadingState extends FilesSectionState {}

class GetAttachmentErrorState extends FilesSectionState {
  final String error;
  GetAttachmentErrorState(this.error);
}

class GetAttachmentSuccessState extends FilesSectionState {}
