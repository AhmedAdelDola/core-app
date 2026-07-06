import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../core/network/repository/repository_imports.dart';
import '../../../../../core/util/utils.dart';
import '../../../../../models/profile/wallet/wallet_history.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final Repository repo;
  WalletCubit(this.repo) : super(WalletInitialState());

  static WalletCubit of(context) => BlocProvider.of(context);
  WalletResponse? wallet;
  Future<void> getWalletHistory() async {
    emit(GetWalletHistoryLoadingState());
    final f = await repo.getWallet();
    f.fold(
      (l) => emit(GetWalletHistoryErrorState(l.toString())),
      (r) {
        wallet = r;
        emit(GetWalletHistorySuccessState());
      },
    );
  }

  Future<void> chargeWallet({required String Code,}) async {
    emit(ChargeWalletLoadingState());
    final f = await repo.chargeWallet(Code: Code);
    f.fold(
      (l) => emit(ChargeWalletErrorState(l.toString())),
      (r) {
        emit(ChargeWalletSuccessState(r.message ?? 'تم شحن المحفظة بنجاح'));
        getWalletHistory();
      },
    );
  }

  Future<void> purchaseProduct({required String type,required String id,}) async {
    emit(PurchaseProductLoadingState());
    final f = await repo.purchaseProduct(type: type,id: id);
    f.fold(
          (l) => emit(PurchaseProductErrorState(l.toString())),
          (r) {
        emit(PurchaseProductSuccessState(r.message ?? 'تم شراء المنتج بنجاح'));
        getWalletHistory();
      },
    );
  }
}
