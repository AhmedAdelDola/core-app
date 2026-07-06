import '../../../models/general/settings_response.dart';
import '../../../models/user_response/user_data.dart';
import '../../services/di.dart';
import '../cache_helper.dart';
import '../enum_init.dart';
import 'user_preferences.dart';

class UserPreferencesHelper implements IUserPreferences {
  @override
  void saveUserPreference({required UserModelResponse? userData}) {
    final cached = di<CacheHelper>().get(CachingKey.userData);
    final token = cached is Map ? cached['token'] : null;
    final data = userData?.toJson();

    if (data != null && token != null) {
      data['token'] = token;
    }

    di<CacheHelper>().put(CachingKey.userData, data);
  }

   @override
  void updateUserPreference({required UserModelResponse? userData}) {
    final cached = di<CacheHelper>().get(CachingKey.userData);
    final token = cached is Map ? cached['token'] : null;
    final data = userData?.toJson();

    if (data != null && token != null) {
      print(token);
      data['token'] = token;
    }

    di<CacheHelper>().put(CachingKey.userData, data);
  }

  @override
  UserModelResponse? getUserPreference() {
    if (di<CacheHelper>().get(CachingKey.userData) != null) {
      return UserModelResponse.fromJson(
        di<CacheHelper>().get(CachingKey.userData),
      );
    } else {
      return null;
    }
  }

  @override
  String? getUserTokenPreference() {
    String? accessToken;
    if (di<CacheHelper>().has(CachingKey.userData)) {
      final cached = di<CacheHelper>().get(CachingKey.userData);
      // cached userData may be either LoginResponse.toJson() or UserModelResponse.toJson()
      try {
        if (cached is Map && cached.containsKey('token')) {
          accessToken = cached['token'] as String?;
        } else if (cached is Map && cached.containsKey('student')) {
          // some flows store UserModelResponse-like json without token
          accessToken = null;
        }
      } catch (_) {
        accessToken = null;
      }
    }
    return accessToken;
  }

  @override
  void clearUserPreference() {
    di<CacheHelper>().clear(CachingKey.userData);
    di<CacheHelper>().clear(CachingKey.isLogged);
  }

  @override
  bool getSeenOnBoarding() => di<CacheHelper>().getBool(CachingKey.onBoarding);

  @override
  void saveSeenOnBoarding(bool status) {
    di<CacheHelper>().put(CachingKey.onBoarding, status);
  }

  @override
  SettingsResponse? getAppSettings() {
    if (di<CacheHelper>().get(CachingKey.settings) != null) {
      return SettingsResponse.fromJson(
        di<CacheHelper>().get(CachingKey.settings),
      );
    } else {
      return null;
    }
  }

  @override
  void saveAppSettings({required SettingsResponse data}) {
    di<CacheHelper>().put(CachingKey.settings, data);
  }

  @override
  String? getPrimaryColor() {
    return getAppSettings()?.branding?.primaryColor ?? null;
  }

  @override
  void setPrimaryColor(String hex) {
    final SettingsResponse? current = getAppSettings();
    if (current != null) {
      current.branding ??= Branding();
      current.branding!.primaryColor = hex;
      saveAppSettings(data: current);
    } else {
      final SettingsResponse s = SettingsResponse(
        branding: Branding(primaryColor: hex),
      );
      saveAppSettings(data: s);
    }
  }
}
