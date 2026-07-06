import 'package:dartz/dartz.dart';
import 'package:elhanbly/core/network/remote/api_endpoints.dart';
import 'package:elhanbly/core/network/repository/repository_imports.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/auth_fixtures.dart';
import '../fixtures/home_fixtures.dart';
import '../fixtures/register_fixtures.dart';
import '../fixtures/wallet_fixtures.dart';
import '../helpers/fake_dio_helper.dart';

void main() {
  group('RepoImpl', () {
    test('login posts password credentials and parses LoginResponse', () async {
      final dio = FakeDioHelper()
        ..stubResponse('POST', EndPoints.login, loginResponseJson());
      final repo = RepoImpl(dio);

      final result = await repo.login(phone: '+201000000000', password: 'password');
      final response = unwrapRight(result);

      expect(result.isRight(), isTrue);
      expect(response.token, 'test-token');
      expect(dio.requests.single.method, 'POST');
      expect(dio.requests.single.url, EndPoints.login);
      expect(dio.requests.single.data, {
        'phone': '+201000000000',
        'password': 'password',
      });
    });

    test('login posts otp credentials when password is omitted', () async {
      final dio = FakeDioHelper()
        ..stubResponse('POST', EndPoints.login, loginResponseJson());
      final repo = RepoImpl(dio);

      final result = await repo.login(phone: '+201000000000', otp: '2030');

      expect(result.isRight(), isTrue);
      expect(dio.requests.single.data, {
        'phone': '+201000000000',
        'otp': '2030',
      });
    });

    test('fetchRegistrationStages accepts stages key', () async {
      final dio = FakeDioHelper()
        ..stubResponse('GET', EndPoints.stagesEndPoint, {
          'stages': [registerStageJson()],
        });
      final repo = RepoImpl(dio);

      final result = await repo.fetchRegistrationStages();
      final stages = unwrapRight(result);

      expect(result.isRight(), isTrue);
      expect(stages.first.name, 'Stage 1');
    });

    test('getHome parses home response', () async {
      final dio = FakeDioHelper()
        ..stubResponse('GET', EndPoints.gethome, homeResponseJson());
      final repo = RepoImpl(dio);

      final result = await repo.getHome();
      final response = unwrapRight(result);

      expect(result.isRight(), isTrue);
      expect(response.recommendedCourses?.first.title, 'Algebra Basics');
    });

    test('chargeWallet posts code and parses message', () async {
      final dio = FakeDioHelper()
        ..stubResponse('POST', EndPoints.ChargeWithCode, {
          'status': 200,
          'message': 'charged',
        });
      final repo = RepoImpl(dio);

      final result = await repo.chargeWallet(Code: 'AB12-CD34-EF56');
      final response = unwrapRight(result);

      expect(result.isRight(), isTrue);
      expect(response.message, 'charged');
      expect(dio.requests.single.data, {'code': 'AB12-CD34-EF56'});
    });

    test('getWallet parses wallet response', () async {
      final dio = FakeDioHelper()
        ..stubResponse('GET', EndPoints.getWallet, walletResponseJson());
      final repo = RepoImpl(dio);

      final result = await repo.getWallet();
      final response = unwrapRight(result);

      expect(result.isRight(), isTrue);
      expect(response.wallet?.balance, '250.00');
    });

    test('returns Left when DioHelper throws', () async {
      final dio = FakeDioHelper()
        ..stubError('GET', EndPoints.gethome, Exception('network failed'));
      final repo = RepoImpl(dio);

      final result = await repo.getHome();
      final error = unwrapLeft(result);

      expect(result.isLeft(), isTrue);
      expect(error, contains('network failed'));
    });
  });
}

T unwrapRight<T>(Either<dynamic, T> either) {
  return either.fold(
    (error) => throw TestFailure('Expected Right but got Left($error)'),
    (value) => value,
  );
}

dynamic unwrapLeft<T>(Either<dynamic, T> either) {
  return either.fold(
    (error) => error,
    (value) => throw TestFailure('Expected Left but got Right($value)'),
  );
}
