import 'package:dartz/dartz.dart';
import 'package:elhanbly/feature/auth/complete_profile/cubit/register_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/register_fixtures.dart';
import '../../helpers/fake_repository.dart';

void main() {
  group('RegisterCubit', () {
    test('fetchStages loads stages and auto-selects the only stage', () async {
      final repository = FakeRepository()
        ..fetchRegistrationStagesStub = () async => right(registerStagesFixture());
      final cubit = RegisterCubit(repository);
      final states = <RegisterState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.fetchStages();

      expect(states[0], isA<RegisterStagesLoadingState>());
      expect(states[1], isA<RegisterStagesLoadedState>());
      expect(cubit.isSingleStage, isTrue);
      expect(cubit.selectedStage?.name, 'Stage 1');
      expect(cubit.selectedLevel, isNull);

      await subscription.cancel();
      await cubit.close();
    });

    test('fetchStages emits error when repository fails', () async {
      final repository = FakeRepository()
        ..fetchRegistrationStagesStub = () async => left('failed');
      final cubit = RegisterCubit(repository);
      final states = <RegisterState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.fetchStages();

      expect(states[0], isA<RegisterStagesLoadingState>());
      expect(states[1], isA<RegisterStagesErrorState>());
      expect((states[1] as RegisterStagesErrorState).message, 'failed');

      await subscription.cancel();
      await cubit.close();
    });

    test('register emits validation error when no level is selected', () async {
      final repository = FakeRepository();
      final cubit = RegisterCubit(repository);
      final states = <RegisterState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.register(
        name: 'Student',
        phone: '+201000000000',
        email: 'student@example.com',
        password: 'password',
      );

      expect(states.single, isA<RegisterErrorState>());
      expect(repository.lastRegisterStudentRequest, isNull);

      await subscription.cancel();
      await cubit.close();
    });

    test('register submits selected level and emits success', () async {
      final repository = FakeRepository()
        ..registerStudentStub = () async => right(true);
      final cubit = RegisterCubit(repository)
        ..stages = registerStagesFixture()
        ..selectedStage = registerStagesFixture().first;
      cubit.selectLevel(10);
      final states = <RegisterState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.register(
        name: 'Student',
        phone: '+201000000000',
        email: 'student@example.com',
        password: 'password',
      );

      expect(states[0], isA<RegisterSubmittingState>());
      expect(states[1], isA<RegisterSuccessState>());
      expect(repository.lastRegisterStudentRequest?.levelId, 10);
      expect(repository.lastRegisterStudentRequest?.email, 'student@example.com');

      await subscription.cancel();
      await cubit.close();
    });
  });
}
