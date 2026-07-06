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
