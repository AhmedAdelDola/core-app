import 'package:elhanbly/models/user_response/login_response.dart' as login;
import 'package:elhanbly/models/user_response/user_data.dart' as profile;

Map<String, dynamic> loginResponseJson() => {
      'token': 'test-token',
      'student': studentJson(),
      'state': {'status': 'active'},
      'wallet': walletJson(),
    };

Map<String, dynamic> userProfileJson() => {
      'student': studentJson(),
      'state': {'status': 'active'},
      'wallet': walletJson(),
    };

Map<String, dynamic> studentJson() => {
      'id': 1,
      'tenant_id': 10,
      'level_id': 100,
      'name': 'Test Student',
      'phone': '+201000000000',
      'email': 'student@example.com',
      'status': 'active',
    };

Map<String, dynamic> walletJson() => {
      'id': 5,
      'tenant_id': 10,
      'student_id': 1,
      'balance': '100.00',
      'currency_code': 'EGP',
    };

login.LoginResponse loginResponseFixture() {
  return login.LoginResponse.fromJson(loginResponseJson());
}

profile.UserModelResponse userProfileFixture() {
  return profile.UserModelResponse.fromJson(userProfileJson());
}
