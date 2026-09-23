import 'package:elhanbly/models/home_entities/courses/course_comments_model.dart';

abstract class CourseCommentsState {}

class CourseCommentsInitialState extends CourseCommentsState {}

class CourseCommentsLoadingState extends CourseCommentsState {}

class CourseCommentsLoadedState extends CourseCommentsState {
  final List<CourseCommentItem> comments;
  final int currentPage;
  final int lastPage;
  final int total;
  final bool isLoadingMore;

  CourseCommentsLoadedState({
    required this.comments,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    this.isLoadingMore = false,
  });

  CourseCommentsLoadedState copyWith({
    List<CourseCommentItem>? comments,
    int? currentPage,
    int? lastPage,
    int? total,
    bool? isLoadingMore,
  }) {
    return CourseCommentsLoadedState(
      comments: comments ?? this.comments,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class CourseCommentsErrorState extends CourseCommentsState {
  final String message;
  CourseCommentsErrorState(this.message);
}

/// Add comment states
class AddCommentLoadingState extends CourseCommentsState {}

class AddCommentSuccessState extends CourseCommentsState {
  final CourseCommentItem comment;
  AddCommentSuccessState(this.comment);
}

class AddCommentErrorState extends CourseCommentsState {
  final String message;
  final bool isForbidden;
  AddCommentErrorState(this.message, {this.isForbidden = false});
}

/// Edit comment states
class EditCommentLoadingState extends CourseCommentsState {
  final int commentId;
  EditCommentLoadingState(this.commentId);
}

class EditCommentSuccessState extends CourseCommentsState {
  final CourseCommentItem comment;
  EditCommentSuccessState(this.comment);
}

class EditCommentErrorState extends CourseCommentsState {
  final String message;
  EditCommentErrorState(this.message);
}

/// Delete comment states
class DeleteCommentLoadingState extends CourseCommentsState {
  final int commentId;
  DeleteCommentLoadingState(this.commentId);
}

class DeleteCommentSuccessState extends CourseCommentsState {
  final int commentId;
  DeleteCommentSuccessState(this.commentId);
}

class DeleteCommentErrorState extends CourseCommentsState {
  final String message;
  DeleteCommentErrorState(this.message);
}
