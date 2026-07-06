import 'package:elhanbly/models/profile/wallet/wallet_history.dart';

Map<String, dynamic> walletResponseJson() => {
      'wallet': {
        'id': 1,
        'tenant_id': 10,
        'student_id': 20,
        'balance': '250.00',
        'currency_code': 'EGP',
      },
      'transactions': [
        {
          'id': 100,
          'tenant_id': 10,
          'wallet_id': 1,
          'student_id': 20,
          'type': 'charge',
          'amount': '50.00',
          'balance_before': '200.00',
          'balance_after': '250.00',
          'reference_type': 'code',
          'reference_id': 7,
          'description': 'Wallet charge',
          'created_at': '2026-01-01T00:00:00.000Z',
          'updated_at': '2026-01-01T00:00:00.000Z',
        },
      ],
    };

WalletResponse walletResponseFixture() {
  return WalletResponse.fromJson(walletResponseJson());
}
