import 'package:dartz/dartz.dart';
import 'package:elhanbly/feature/modules/home/home_section/courses_section/cubit/course_comments_cubit.dart';
import 'package:elhanbly/feature/modules/home/home_section/courses_section/cubit/course_comments_state.dart';
import 'package:elhanbly/models/home_entities/courses/course_comments_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_repository.dart';

CourseCommentsResponse makeDummyResponse() => CourseCommentsResponse(
      comments: CourseCommentsData(
        currentPage: 1,
        lastPage: 2,
        total: 2,
        data: [
          CourseCommentItem(
            id: 1,
            courseId: 10,
            body: 'تعليق مثبت',
            isPinned: true,
            isMine: false,
          ),
          CourseCommentItem(
            id: 2,
            courseId: 10,
            body: 'تعليقي الأول',
            isPinned: false,
            isMine: true,
          ),
        ],
      ),
    );

void main() {
  group('CourseCommentsCubit', () {
    late FakeRepository repository;

    setUp(() {
      repository = FakeRepository();
    });

    test('getComments fetches comments and sets total', () async {
      repository.getCourseCommentsStub = () async => right(makeDummyResponse());

      final cubit = CourseCommentsCubit(repo: repository, courseId: 10);
      await cubit.getComments();

      expect(cubit.comments.length, 2);
      expect(cubit.total, 2);
      expect(cubit.state, isA<CourseCommentsLoadedState>());

      await cubit.close();
    });

    test('addComment inserts comment and increments total', () async {
      repository.getCourseCommentsStub = () async => right(makeDummyResponse());
      final newComment = CourseCommentItem(
        id: 3,
        courseId: 10,
        body: 'تعليق جديد رائع',
        isPinned: false,
        isMine: true,
      );
      repository.addCourseCommentStub = () async => right(newComment);

      final cubit = CourseCommentsCubit(repo: repository, courseId: 10);
      await cubit.getComments();

      final success = await cubit.addComment('تعليق جديد رائع');
      expect(success, isTrue);
      expect(cubit.comments.length, 3);
      expect(cubit.total, 3);
      // Pinned comment stays first
      expect(cubit.comments[0].isPinned, isTrue);
      expect(cubit.comments[1].id, 3);

      await cubit.close();
    });

    test('addComment handles 403 Forbidden when not subscribed', () async {
      repository.getCourseCommentsStub = () async => right(makeDummyResponse());
      repository.addCourseCommentStub =
          () async => left('يجب أن تكون مشتركاً في الكورس لإضافة تعليق.');

      final cubit = CourseCommentsCubit(repo: repository, courseId: 10);
      await cubit.getComments();

      final success = await cubit.addComment('سؤال عن الدرس');
      expect(success, isFalse);

      expect(cubit.state, isA<AddCommentErrorState>());
      final errorState = cubit.state as AddCommentErrorState;
      expect(errorState.isForbidden, isTrue);
      expect(errorState.message, contains('مشتركاً'));

      await cubit.close();
    });

    test('editComment updates comment body', () async {
      repository.getCourseCommentsStub = () async => right(makeDummyResponse());
      final updatedComment = CourseCommentItem(
        id: 2,
        courseId: 10,
        body: 'نص معدل',
        isPinned: false,
        isMine: true,
        editedAt: DateTime.now(),
      );
      repository.editCourseCommentStub = () async => right(updatedComment);

      final cubit = CourseCommentsCubit(repo: repository, courseId: 10);
      await cubit.getComments();

      final success = await cubit.editComment(2, 'نص معدل');
      expect(success, isTrue);
      expect(cubit.comments.firstWhere((c) => c.id == 2).body, 'نص معدل');

      await cubit.close();
    });

    test('deleteComment removes comment and decrements total', () async {
      repository.getCourseCommentsStub = () async => right(makeDummyResponse());
      repository.deleteCourseCommentStub = () async => right(true);

      final cubit = CourseCommentsCubit(repo: repository, courseId: 10);
      await cubit.getComments();

      final success = await cubit.deleteComment(2);
      expect(success, isTrue);
      expect(cubit.comments.length, 1);
      expect(cubit.total, 1);
      expect(cubit.comments.any((c) => c.id == 2), isFalse);

      await cubit.close();
    });
  });
}
