import 'package:dio/dio.dart';
import 'package:elhanbly/core/network/cubit/cubit.dart';
import 'package:elhanbly/core/network/cubit/state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_platform_channels.dart';

void main() {
  group('NetworkCubit', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      mockFlutterToastChannel();
    });

    tearDownAll(resetFlutterToastChannel);

    test('emits unauthenticated for non-profile 401 responses', () async {
      final cubit = NetworkCubit();
      final states = <NetworkStates>[];
      final subscription = cubit.stream.listen(states.add);
      final requestOptions = RequestOptions(path: '/api/protected');

      await cubit.onErrorCallback(
        DioException(
          requestOptions: requestOptions,
          response: Response(
            requestOptions: requestOptions,
            statusCode: 401,
            data: {'message': 'Unauthenticated'},
          ),
        ),
      );

      expect(states.single, isA<UnauthenticatedState>());

      await subscription.cancel();
      await cubit.close();
    });

    test('keeps profile 401 responses as error state', () async {
      final cubit = NetworkCubit();
      final states = <NetworkStates>[];
      final subscription = cubit.stream.listen(states.add);
      final requestOptions = RequestOptions(path: '/auth/profile');

      await cubit.onErrorCallback(
        DioException(
          requestOptions: requestOptions,
          response: Response(
            requestOptions: requestOptions,
            statusCode: 401,
            data: {'message': 'Unauthenticated'},
          ),
        ),
      );

      expect(states.single, isA<ErrorState>());

      await subscription.cancel();
      await cubit.close();
    });
  });
}
