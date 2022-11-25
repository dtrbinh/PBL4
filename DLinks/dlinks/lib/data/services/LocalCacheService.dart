import 'package:shared_preferences/shared_preferences.dart';

class LocalCacheService {
  static Future<bool> setString(String key, String value) async {
    var pref = await SharedPreferences.getInstance();
    return pref.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    var pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  // Future<void> setInt(String key, int value) async {
  //   await _storage.write(key: key, value: value.toString());
  // }
  //
  // Future<int> getInt(String key) async {
  //   return int.parse(await _storage.read(key: key));
  // }
  //
  // Future<void> setDouble(String key, double value) async {
  //   await _storage.write(key: key, value: value.toString());
  // }
  //
  // Future<double> getDouble(String key) async {
  //   return double.parse(await _storage.read(key: key));
  // }

  static Future<bool> setBool(String key, bool value) async {
    var pref = await SharedPreferences.getInstance();
    return pref.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    var pref = await SharedPreferences.getInstance();
    return pref.getBool(key);
  }

  static Future<bool> remove(String key) async {
    var pref = await SharedPreferences.getInstance();
    return pref.remove(key);
  }

  static Future<bool> clear() async {
    var pref = await SharedPreferences.getInstance();
    return pref.clear();
  }
}
