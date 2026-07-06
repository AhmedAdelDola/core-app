import '../../../models/general/settings_response.dart';
import '../../../models/user_response/user_data.dart';

abstract class IUserPreferences {
  void saveUserPreference({required UserModelResponse userData});
  void updateUserPreference({required UserModelResponse userData});

  UserModelResponse ? getUserPreference();

  String? getUserTokenPreference();

  void clearUserPreference();

  void saveSeenOnBoarding(bool status);

  bool getSeenOnBoarding();

  void saveAppSettings({required SettingsResponse data});

  SettingsResponse? getAppSettings();
  
  /// Get branding primary color hex string (e.g. "#RRGGBB" or "#AARRGGBB").
  String? getPrimaryColor();

  /// Set branding primary color and persist settings.
  void setPrimaryColor(String hex);
}
