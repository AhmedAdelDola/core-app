import 'package:dio/dio.dart';
import 'package:elhanbly/core/local/cache_helper.dart';
import 'package:elhanbly/core/local/enum_init.dart';
import 'package:elhanbly/core/local/user_preferences/user_preferences_helper.dart';
import 'package:elhanbly/core/network/cubit/cubit.dart';
import 'package:elhanbly/core/network/cubit/state.dart';
import 'package:elhanbly/core/services/di.dart';
import 'package:elhanbly/core/util/text_input_formatter.dart';
import 'package:elhanbly/core/util/validator/validator.dart';
import 'package:elhanbly/feature/modules/profile/profile_imports.dart';
import 'package:elhanbly/models/user_response/user_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import 'helpers/mock_platform_channels.dart';
import 'helpers/test_bootstrap.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  mockFlutterToastChannel();

  group('Validator.walletCode', () {
    test('accepts the expected format', () {
      expect(Validator.walletCode('1TM2-N1JT-CLSD'), isNull);
    });

    test('rejects invalid formats', () {
      expect(Validator.walletCode('1234-5678'), isNotNull);
      expect(Validator.walletCode(''), isNotNull);
    });
  });

  group('WalletCodeTextInputFormatter', () {
    test('formats the code into 4-4-4 groups', () {
      final formatter = WalletCodeTextInputFormatter();
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '1TM2N1JTCLSD'),
      );

      expect(result.text, '1TM2-N1JT-CLSD');
    });
  });

  group('UpdateProfileParams', () {
    test('builds a map with only non-empty values', () {
      final params = UpdateProfileParams(
        name: 'Ali',
        email: '',
        gender: 'male',
      );
      final map = params.toMap();

      expect(map['name'], 'Ali');
      expect(map.containsKey('email'), isFalse);
      expect(map['gender'], 'male');
    });
  });

  group('UserPreferencesHelper', () {
    test(
      'keeps the existing token when saving refreshed profile data',
      () async {
        await configureTestDependencies();

        di<CacheHelper>().put(CachingKey.userData, {
          'token': 'test-token',
          'student': {'name': 'Old Name'},
        });

        UserPreferencesHelper().saveUserPreference(
          userData: UserModelResponse(student: Student(name: 'New Name')),
        );

        expect(UserPreferencesHelper().getUserTokenPreference(), 'test-token');
        expect(
          UserPreferencesHelper().getUserPreference()?.student?.name,
          'New Name',
        );
      },
    );
  });

  group('NetworkCubit', () {
    test(
      'keeps profile requests in error state instead of logout state',
      () async {
        final cubit = NetworkCubit();
        final requestOptions = RequestOptions(path: '/auth/profile');
        final error = DioException(
          requestOptions: requestOptions,
          response: Response(
            requestOptions: requestOptions,
            statusCode: 401,
            data: {'message': 'Unauthenticated'},
          ),
        );

        await cubit.onErrorCallback(error);

        expect(cubit.state, isA<ErrorState>());
        expect(cubit.state, isNot(isA<UnauthenticatedState>()));
      },
    );
  });
}
