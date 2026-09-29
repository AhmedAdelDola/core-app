import 'package:dartz/dartz.dart';
import 'package:elhanbly/feature/modules/home/cubit/home_cubit/home_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/home_fixtures.dart';
import '../../helpers/fake_repository.dart';

void main() {
  group('HomeCubit', () {
    test('getHome emits loading then success and stores response', () async {
      final repository = FakeRepository()
        ..getHomeStub = () async => right(homeResponseFixture());
      final cubit = HomeCubit(repository);
      final states = <HomeStates>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.getHome();
      await Future.delayed(Duration.zero);

      expect(states, contains(isA<GetHomeLoadingState>()));
      expect(states, contains(isA<GetHomeSuccessState>()));
      expect(cubit.home?.recommendedCourses?.first.title, 'Algebra Basics');

      await subscription.cancel();
      await cubit.close();
    });

    test('getHome emits loading then error on repository failure', () async {
      final repository = FakeRepository()
        ..getHomeStub = () async => left('home failed');
      final cubit = HomeCubit(repository);
      final states = <HomeStates>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.getHome();
      await Future.delayed(Duration.zero);

      expect(states, contains(isA<GetHomeLoadingState>()));
      expect(states, contains(isA<GetHomeErrorState>()));
      final errorState = states.whereType<GetHomeErrorState>().first;
      expect(errorState.error, 'home failed');

      await subscription.cancel();
      await cubit.close();
    });
  });
}
