part of 'wallet_cubit.dart';

class WalletState {}

class WalletInitialState extends WalletState {}

class ChargeWalletLoadingState extends WalletState {}

class ChargeWalletErrorState extends WalletState {
  final String error;

  ChargeWalletErrorState(this.error);
}

class ChargeWalletSuccessState extends WalletState {
  final String error;
  ChargeWalletSuccessState(this.error);
}


class GetWalletHistoryLoadingState extends WalletState {}

class GetWalletHistoryErrorState extends WalletState {
  final String error;

  GetWalletHistoryErrorState(this.error);
}

class GetWalletHistorySuccessState extends WalletState {}

class PurchaseProductLoadingState extends WalletState {}
class PurchaseProductErrorState extends WalletState {
  final String error;

  PurchaseProductErrorState(this.error);
}
class PurchaseProductSuccessState extends WalletState {  final String massage;
  PurchaseProductSuccessState(this.massage);
}

class GetStoreProductsLoadingState extends WalletState {}
class GetStoreProductsErrorState extends WalletState {
  final String error;
  GetStoreProductsErrorState(this.error);
}
class GetStoreProductsSuccessState extends WalletState {}

class VerifyStorePurchaseLoadingState extends WalletState {}
class VerifyStorePurchaseErrorState extends WalletState {
  final String error;
  VerifyStorePurchaseErrorState(this.error);
}
class VerifyStorePurchaseSuccessState extends WalletState {
  final String message;
  VerifyStorePurchaseSuccessState(this.message);
}
