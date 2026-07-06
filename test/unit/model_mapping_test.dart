import 'package:flutter_test/flutter_test.dart';

import '../fixtures/auth_fixtures.dart';
import '../fixtures/home_fixtures.dart';
import '../fixtures/register_fixtures.dart';
import '../fixtures/wallet_fixtures.dart';

void main() {
  group('model mapping', () {
    test('LoginResponse maps nested student and wallet data', () {
      final response = loginResponseFixture();

      expect(response.token, 'test-token');
      expect(response.student?.name, 'Test Student');
      expect(response.wallet?.currencyCode, 'EGP');
      expect(response.toJson()['student']['phone'], '+201000000000');
    });

    test('RegisterStage maps levels', () {
      final stages = registerStagesFixture();

      expect(stages, hasLength(1));
      expect(stages.first.levels, hasLength(2));
      expect(stages.first.levels.last.name, 'Level 2');
    });

    test('HomeResponse maps course sections', () {
      final response = homeResponseFixture();

      expect(response.recommendedCourses, hasLength(1));
      expect(response.recommendedCourses?.first.teacher?.name, 'Teacher Name');
      expect(response.topTeacher?.activeCoursesCount, 3);
    });

    test('WalletResponse maps transactions', () {
      final response = walletResponseFixture();

      expect(response.wallet?.balance, '250.00');
      expect(response.transactions, hasLength(1));
      expect(response.transactions?.first.type, 'charge');
    });
  });
}
