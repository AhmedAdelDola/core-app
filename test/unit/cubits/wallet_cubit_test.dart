import 'package:dartz/dartz.dart';
import 'package:elhanbly/feature/modules/profile/cubit/wallet_cubit/wallet_cubit.dart';
import 'package:elhanbly/models/general/general_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/wallet_fixtures.dart';
import '../../helpers/fake_repository.dart';

void main() {
  group('WalletCubit', () {
    test('getWalletHistory emits loading then success and stores wallet', () async {
      final repository = FakeRepository()
        ..getWalletStub = () async => right(walletResponseFixture());
      final cubit = WalletCubit(repository);
      final states = <WalletState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.getWalletHistory();

      expect(states[0], isA<GetWalletHistoryLoadingState>());
      expect(states[1], isA<GetWalletHistorySuccessState>());
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

      expect(states[0], isA<ChargeWalletLoadingState>());
      expect(states[1], isA<ChargeWalletSuccessState>());
      expect(states[2], isA<GetWalletHistoryLoadingState>());
      expect(states[3], isA<GetWalletHistorySuccessState>());
      expect(repository.lastChargeWalletCode, 'AB12-CD34-EF56');

      await subscription.cancel();
      await cubit.close();
    });

    test('purchaseProduct emits error on repository failure', () async {
      final repository = FakeRepository()
        ..purchaseProductStub = () async => left('purchase failed');
      final cubit = WalletCubit(repository);
      final states = <WalletState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.purchaseProduct(type: 'course', id: '1');

      expect(states[0], isA<PurchaseProductLoadingState>());
      expect(states[1], isA<PurchaseProductErrorState>());
      expect((states[1] as PurchaseProductErrorState).error, 'purchase failed');
      expect(repository.lastPurchaseProductRequest?.type, 'course');
      expect(repository.lastPurchaseProductRequest?.id, '1');

      await subscription.cancel();
      await cubit.close();
    });
  });
}
