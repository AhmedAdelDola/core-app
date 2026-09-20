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
    if (isClosed) return;
    emit(GetWalletHistoryLoadingState());
    checkCodeAvailability();
    final f = await repo.getWallet();
    if (isClosed) return;
    f.fold(
      (l) {
        if (!isClosed) emit(GetWalletHistoryErrorState(l.toString()));
      },
      (r) {
        wallet = r;
        if (!isClosed) emit(GetWalletHistorySuccessState());
      },
    );
  }

  Future<void> chargeWallet({required String Code,}) async {
    if (isClosed) return;
    emit(ChargeWalletLoadingState());
    final f = await repo.chargeWallet(Code: Code);
    if (isClosed) return;
    f.fold(
      (l) {
        if (!isClosed) emit(ChargeWalletErrorState(l.toString()));
      },
      (r) {
        if (!isClosed) emit(ChargeWalletSuccessState(r.message ?? 'تم شحن المحفظة بنجاح'));
        getWalletHistory();
      },
    );
  }

  Future<void> purchaseProduct({required String type,required String id,}) async {
    if (isClosed) return;
    emit(PurchaseProductLoadingState());
    final f = await repo.purchaseProduct(type: type,id: id);
    if (isClosed) return;
    f.fold(
      (l) {
        if (!isClosed) emit(PurchaseProductErrorState(l.toString()));
      },
      (r) {
        if (!isClosed) emit(PurchaseProductSuccessState(r.message ?? 'تم شراء المنتج بنجاح'));
        getWalletHistory();
      },
    );
  }

  Future<bool> purchaseCourse({
    required String courseId,
    required String paymentMethod,
    String? code,
  }) async {
    if (isClosed) return false;
    emit(PurchaseProductLoadingState());
    final f = await repo.purchaseCourseSubscription(
      courseId: courseId,
      paymentMethod: paymentMethod,
      code: code,
    );
    if (isClosed) return false;
    return f.fold(
      (l) {
        if (!isClosed) emit(PurchaseProductErrorState(l.toString()));
        return false;
      },
      (r) {
        if (!isClosed) emit(PurchaseProductSuccessState(r.message ?? 'تم تفعيل الاشتراك بنجاح'));
        getWalletHistory();
        return true;
      },
    );
  }

  Future<bool> purchaseSession({
    required String sessionId,
    required String paymentMethod,
    String? code,
  }) async {
    if (isClosed) return false;
    emit(PurchaseProductLoadingState());
    final f = await repo.purchaseSessionSubscription(
      sessionId: sessionId,
      paymentMethod: paymentMethod,
      code: code,
    );
    if (isClosed) return false;
    return f.fold(
      (l) {
        if (!isClosed) emit(PurchaseProductErrorState(l.toString()));
        return false;
      },
      (r) {
        if (!isClosed) emit(PurchaseProductSuccessState(r.message ?? 'تم تفعيل الحصة بنجاح'));
        getWalletHistory();
        return true;
      },
    );
  }

  Future<void> checkCodeAvailability() async {
    if (isClosed) return;
    emit(CheckCodeAvailabilityLoadingState());
    int version = 1;
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      version = int.tryParse(packageInfo.buildNumber) ?? 1;
    } catch (e) {
      debugPrint('Error getting package build number: $e');
    }

    final f = await repo.checkCodeAvailability(version: version);
    if (isClosed) return;
    f.fold(
      (l) {
        if (!isClosed) emit(CheckCodeAvailabilityErrorState(l.toString()));
      },
      (r) {
        isCodeAvailable = r.isCodeAvailable ?? true;
        if (!isClosed) emit(CheckCodeAvailabilitySuccessState());
      },
    );
  }
}
