import 'package:dartz/dartz.dart';
import 'package:elhanbly/feature/auth/login/cubit/login_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/auth_fixtures.dart';
import '../../helpers/fake_repository.dart';
import '../../helpers/test_bootstrap.dart';

void main() {
  group('LoginCubit', () {
    test('emits loading then success and stores request data', () async {
      final repository = FakeRepository()
        ..loginStub = () async => right(loginResponseFixture());
      await configureTestDependencies(repository: repository);
      final cubit = LoginCubit(repository);
      final states = <LoginState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.login(phone: '1000000000', password: 'password');

      expect(states[0], isA<LoginLoadingState>());
      expect(states[1], isA<SuccessLoginState>());
      expect(repository.lastLoginRequest?.phone, '+201000000000');
      expect(repository.lastLoginRequest?.password, 'password');
      expect(cubit.loginResponse?.token, 'test-token');

      await subscription.cancel();
      await cubit.close();
    });

    test('emits loading then error on repository failure', () async {
      final repository = FakeRepository()
        ..loginStub = () async => left('invalid credentials');
      await configureTestDependencies(repository: repository);
      final cubit = LoginCubit(repository);
      final states = <LoginState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.login(phone: '1000000000', password: 'bad-password');

      expect(states[0], isA<LoginLoadingState>());
      expect(states[1], isA<LoginErrorState>());
      expect((states[1] as LoginErrorState).message, 'invalid credentials');

      await subscription.cancel();
      await cubit.close();
    });

    test('updates selected country and number codes', () async {
      final repository = FakeRepository();
      final cubit = LoginCubit(repository);
      final states = <LoginState>[];
      final subscription = cubit.stream.listen(states.add);

      cubit.setCountryCode('SA');
      cubit.setNumberCode('+966');

      expect(cubit.countryCode, 'SA');
      expect(cubit.numberCode, '+966');
      expect(states[0], isA<ChangeCountryCodeState>());
      expect(states[1], isA<ChangeNumberCodeState>());

      await subscription.cancel();
      await cubit.close();
    });
  });
}
