import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/network/repository/repository_imports.dart';
import '../../../../../../models/home_entities/courses/course_comments_model.dart';
import 'course_comments_state.dart';

typedef SessionCommentsCubit = CourseCommentsCubit;

class CourseCommentsCubit extends Cubit<CourseCommentsState> {
  final Repository repo;
  final dynamic sessionId;
  dynamic get courseId => sessionId;

  CourseCommentsCubit({
    required this.repo,
    dynamic sessionId,
    dynamic courseId,
  })  : sessionId = sessionId ?? courseId,
        super(CourseCommentsInitialState());

  static CourseCommentsCubit of(context) => BlocProvider.of<CourseCommentsCubit>(context);

  void _safeEmit(CourseCommentsState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  List<CourseCommentItem> comments = [];
  int currentPage = 1;
  int lastPage = 1;
  int total = 0;
  bool isLoadingMore = false;

  void emitLoaded({bool loadingMore = false}) {
    isLoadingMore = loadingMore;
    _safeEmit(CourseCommentsLoadedState(
      comments: List.from(comments),
      currentPage: currentPage,
      lastPage: lastPage,
      total: total,
      isLoadingMore: isLoadingMore,
    ));
  }

  Future<void> getComments({bool isRefresh = false}) async {
    if (!isRefresh && comments.isEmpty) {
      _safeEmit(CourseCommentsLoadingState());
    }
    currentPage = 1;

    final result = await repo.getSessionComments(
      sessionId: sessionId,
      page: 1,
      perPage: 20,
    );

    result.fold(
      (l) => _safeEmit(CourseCommentsErrorState(l.toString())),
      (r) {
        comments = List<CourseCommentItem>.from(r.comments.data);
        currentPage = r.comments.currentPage;
        lastPage = r.comments.lastPage;
        total = r.comments.total;
        emitLoaded();
      },
    );
  }

  Future<void> loadMoreComments() async {
    if (isLoadingMore || currentPage >= lastPage) return;

    emitLoaded(loadingMore: true);

    final nextPage = currentPage + 1;
    final result = await repo.getSessionComments(
      sessionId: sessionId,
      page: nextPage,
      perPage: 20,
    );

    result.fold(
      (l) {
        emitLoaded(loadingMore: false);
      },
      (r) {
        currentPage = r.comments.currentPage;
        lastPage = r.comments.lastPage;
        total = r.comments.total;

        // Deduplicate comments by id
        final existingIds = comments.map((e) => e.id).toSet();
        for (final item in r.comments.data) {
          if (!existingIds.contains(item.id)) {
            comments.add(item);
          }
        }
        emitLoaded(loadingMore: false);
      },
    );
  }

  Future<bool> addComment(String body) async {
    final trimmed = body.trim();
    if (trimmed.length < 2) {
      _safeEmit(AddCommentErrorState('يجب أن يحتوي التعليق على حرفين على الأقل'));
      return false;
    }
    if (trimmed.length > 2000) {
      _safeEmit(AddCommentErrorState('الحد الأقصى للتعليق هو 2000 حرف'));
      return false;
    }

    _safeEmit(AddCommentLoadingState());

    final result = await repo.addSessionComment(
      sessionId: sessionId,
      body: trimmed,
    );

    return result.fold(
      (l) {
        final errorMsg = l.toString();
        final isForbidden = errorMsg.contains('مشترك') || errorMsg.contains('403');
        _safeEmit(AddCommentErrorState(errorMsg, isForbidden: isForbidden));
        return false;
      },
      (newComment) {
        // Find insert position: after pinned comments, or at the start
        int insertIndex = 0;
        while (insertIndex < comments.length && comments[insertIndex].isPinned) {
          insertIndex++;
        }
        comments.insert(insertIndex, newComment);
        total += 1;
        _safeEmit(AddCommentSuccessState(newComment));
        emitLoaded();
        return true;
      },
    );
  }

  Future<bool> editComment(int commentId, String newBody) async {
    final trimmed = newBody.trim();
    if (trimmed.length < 2) {
      _safeEmit(EditCommentErrorState('يجب أن يحتوي التعليق على حرفين على الأقل'));
      return false;
    }

    _safeEmit(EditCommentLoadingState(commentId));

    final result = await repo.editSessionComment(
      sessionId: sessionId,
      commentId: commentId,
      body: trimmed,
    );

    return result.fold(
      (l) {
        _safeEmit(EditCommentErrorState(l.toString()));
        return false;
      },
      (updatedComment) {
        final index = comments.indexWhere((e) => e.id == commentId);
        if (index != -1) {
          comments[index].body = trimmed;
          comments[index].editedAt = updatedComment.editedAt ?? DateTime.now();
        }
        _safeEmit(EditCommentSuccessState(updatedComment));
        emitLoaded();
        return true;
      },
    );
  }

  Future<bool> deleteComment(int commentId) async {
    _safeEmit(DeleteCommentLoadingState(commentId));

    final result = await repo.deleteSessionComment(
      sessionId: sessionId,
      commentId: commentId,
    );

    return result.fold(
      (l) {
        _safeEmit(DeleteCommentErrorState(l.toString()));
        return false;
      },
      (success) {
        comments.removeWhere((e) => e.id == commentId);
        if (total > 0) total -= 1;
        _safeEmit(DeleteCommentSuccessState(commentId));
        emitLoaded();
        return true;
      },
    );
  }
}
