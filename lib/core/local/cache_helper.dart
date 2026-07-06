import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class CacheHelper {
  T? get<T>(String key);

  bool getBool(String key);

  bool has(String key);

  void clear(String key);

  void put(String key, dynamic value);

  void logOut();
}

class CacheImpl extends CacheHelper {
  final SharedPreferences _sharedPreferences;

  CacheImpl(this._sharedPreferences);

  @override
  bool has(String key) {
    return (_sharedPreferences.containsKey(key) &&
        _sharedPreferences.get(key) != null);
  }

  @override
  void clear(String key) {
    _sharedPreferences.remove(key);
  }

  @override
  T? get<T>(String key) {
    if (has(key)) {
      return jsonDecode(_sharedPreferences.getString(key)!);
    } else {
      return null;
    }
  }

  @override
  bool getBool(String key) {
    if (has(key)) {
      return jsonDecode(_sharedPreferences.getString(key)!)
              .toString()
              .toLowerCase() ==
          'true';
    } else {
      return false;
    }
  }

  @override
  void put(String key, dynamic value) {
    _sharedPreferences.setString(key, jsonEncode(value));
  }

  @override
  void logOut() => _sharedPreferences.clear();
}
