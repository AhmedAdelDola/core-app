import 'package:dartz/dartz.dart';
import 'package:elhanbly/feature/modules/profile/cubit/wallet_cubit/wallet_cubit.dart';
import 'package:elhanbly/models/general/general_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/wallet_fixtures.dart';
import '../../helpers/fake_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WalletCubit', () {
    test('getWalletHistory emits loading then success and stores wallet', () async {
      final repository = FakeRepository();
      repository.getWalletStub = () async => right(walletResponseFixture());
      final cubit = WalletCubit(repository);
      final states = <WalletState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.getWalletHistory();
      await Future<void>.delayed(Duration.zero);

      expect(states.any((s) => s is GetWalletHistoryLoadingState), isTrue);
      expect(states.any((s) => s is GetWalletHistorySuccessState), isTrue);
      expect(cubit.wallet?.wallet?.balance, '250.00');

      await subscription.cancel();
      await cubit.close();
    });

    test('chargeWallet emits success and refreshes wallet history', () async {
      final repository = FakeRepository();
      repository.chargeWalletStub = () async => right(
            GeneralResponse(status: 200, message: 'charged'),
          );
      repository.getWalletStub = () async => right(walletResponseFixture());
      final cubit = WalletCubit(repository);
      final states = <WalletState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.chargeWallet(Code: 'AB12-CD34-EF56');
      await Future<void>.delayed(Duration.zero);

      expect(states.any((s) => s is ChargeWalletLoadingState), isTrue);
      expect(states.any((s) => s is ChargeWalletSuccessState), isTrue);
      expect(repository.lastChargeWalletCode, 'AB12-CD34-EF56');

      await subscription.cancel();
      await cubit.close();
    });

    test('purchaseProduct emits error on repository failure', () async {
      final repository = FakeRepository();
      repository.purchaseProductStub = () async => left('purchase failed');
      final cubit = WalletCubit(repository);
      final states = <WalletState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.purchaseProduct(type: 'course', id: '1');
      await Future<void>.delayed(Duration.zero);

      expect(states.any((s) => s is PurchaseProductLoadingState), isTrue);
      expect(states.any((s) => s is PurchaseProductErrorState), isTrue);
      expect(repository.lastPurchaseProductRequest?.type, 'course');
      expect(repository.lastPurchaseProductRequest?.id, '1');

      await subscription.cancel();
      await cubit.close();
    });

    test('purchaseCourse with wallet succeeds and refreshes wallet', () async {
      final repository = FakeRepository();
      repository.purchaseCourseSubscriptionStub = () async => right(
            GeneralResponse(status: 200, message: 'تم الاشتراك بنجاح'),
          );
      repository.getWalletStub = () async => right(walletResponseFixture());
      final cubit = WalletCubit(repository);
      final states = <WalletState>[];
      final subscription = cubit.stream.listen(states.add);

      final result = await cubit.purchaseCourse(
        courseId: '42',
        paymentMethod: 'wallet',
      );
      await Future<void>.delayed(Duration.zero);

      expect(result, isTrue);
      expect(states[0], isA<PurchaseProductLoadingState>());
      expect(states[1], isA<PurchaseProductSuccessState>());
      expect(repository.lastPurchaseCourseId, '42');
      expect(repository.lastPurchaseCourseMethod, 'wallet');
      expect(repository.lastPurchaseCourseCode, isNull);

      await subscription.cancel();
      await cubit.close();
    });

    test('purchaseCourse with code succeeds without wallet deduction', () async {
      final repository = FakeRepository();
      repository.purchaseCourseSubscriptionStub = () async => right(
            GeneralResponse(status: 200, message: 'تم تفعيل الكود بنجاح'),
          );
      repository.getWalletStub = () async => right(walletResponseFixture());
      final cubit = WalletCubit(repository);
      final states = <WalletState>[];
      final subscription = cubit.stream.listen(states.add);

      final result = await cubit.purchaseCourse(
        courseId: '42',
        paymentMethod: 'code',
        code: 'COURSE-XYZ',
      );
      await Future<void>.delayed(Duration.zero);

      expect(result, isTrue);
      expect(states[0], isA<PurchaseProductLoadingState>());
      expect(states[1], isA<PurchaseProductSuccessState>());
      expect(repository.lastPurchaseCourseId, '42');
      expect(repository.lastPurchaseCourseMethod, 'code');
      expect(repository.lastPurchaseCourseCode, 'COURSE-XYZ');

      await subscription.cancel();
      await cubit.close();
    });

    test('purchaseSession with code succeeds', () async {
      final repository = FakeRepository();
      repository.purchaseSessionSubscriptionStub = () async => right(
            GeneralResponse(status: 200, message: 'تم تفعيل الحصة بنجاح'),
          );
      repository.getWalletStub = () async => right(walletResponseFixture());
      final cubit = WalletCubit(repository);
      final states = <WalletState>[];
      final subscription = cubit.stream.listen(states.add);

      final result = await cubit.purchaseSession(
        sessionId: '101',
        paymentMethod: 'code',
        code: 'SESSION-ABC',
      );
      await Future<void>.delayed(Duration.zero);

      expect(result, isTrue);
      expect(states[0], isA<PurchaseProductLoadingState>());
      expect(states[1], isA<PurchaseProductSuccessState>());
      expect(repository.lastPurchaseSessionId, '101');
      expect(repository.lastPurchaseSessionMethod, 'code');
      expect(repository.lastPurchaseSessionCode, 'SESSION-ABC');

      await subscription.cancel();
      await cubit.close();
    });
  });
}
