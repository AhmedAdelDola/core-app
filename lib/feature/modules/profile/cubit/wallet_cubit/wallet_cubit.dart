import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../core/network/repository/repository_imports.dart';
import '../../../../../core/util/utils.dart';
import '../../../../../models/profile/wallet/wallet_history.dart';
import '../../../../../models/profile/wallet/store_products.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final Repository repo;
  WalletCubit(this.repo) : super(WalletInitialState());

  static WalletCubit of(context) => BlocProvider.of(context);
  WalletResponse? wallet;
  StoreProductsResponse? storeProducts;
  bool isCodeAvailable = true;

  Future<void> getStoreProducts() async {
    emit(GetStoreProductsLoadingState());
    final f = await repo.getStoreProducts();
    f.fold(
      (l) => emit(GetStoreProductsErrorState(l.toString())),
      (r) {
        storeProducts = r;
        emit(GetStoreProductsSuccessState());
      },
    );
  }

  Future<void> verifyStorePurchase({
    required Map<String, dynamic> data,
    required Function() onSuccess,
  }) async {
    emit(VerifyStorePurchaseLoadingState());
    final f = await repo.verifyStorePurchase(data: data);
    f.fold(
      (l) => emit(VerifyStorePurchaseErrorState(l.toString())),
      (r) {
        emit(VerifyStorePurchaseSuccessState(r.message ?? 'تم الشحن بنجاح'));
        onSuccess();
        getWalletHistory();
      },
    );
  }
  Future<void> getWalletHistory() async {
    emit(GetWalletHistoryLoadingState());
    checkCodeAvailability();
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

  Future<void> checkCodeAvailability() async {
    emit(CheckCodeAvailabilityLoadingState());
    int version = 1;
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      version = int.tryParse(packageInfo.buildNumber) ?? 1;
    } catch (e) {
      debugPrint('Error getting package build number: $e');
    }

    final f = await repo.checkCodeAvailability(version: version);
    f.fold(
      (l) {
        emit(CheckCodeAvailabilityErrorState(l.toString()));
      },
      (r) {
        isCodeAvailable = r.isCodeAvailable ?? true;
        emit(CheckCodeAvailabilitySuccessState());
      },
    );
  }
}
