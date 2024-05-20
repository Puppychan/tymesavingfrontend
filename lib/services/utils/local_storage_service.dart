import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences_android/shared_preferences_android.dart';
// import 'package:shared_preferences_ios/shared_preferences_ios.dart';

class LocalStorageService {
  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    // if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
    // if (Platform.isIOS) SharedPreferencesIOS.registerWith();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // function to store list of strings with list of keys
  static Future<void> setStringList(Map<String, String> keyValuePairs) async {
    final prefs = await SharedPreferences.getInstance();

    for (var entry in keyValuePairs.entries) {
      await prefs.setString(entry.key, entry.value);
    }
  }

  // function to get list of strings with list of keys
  static Future<Map<String, String>> getStringList(List<String> keys) async {
    final prefs = await SharedPreferences.getInstance();
    final keyValuePairs = <String, String>{};

    for (var key in keys) {
      keyValuePairs[key] = prefs.getString(key) ?? '';
    }

    return keyValuePairs;
  }

  // function to remove list of strings with list of keys
  static Future<void> removeStringList(List<String> keys) async {
    final prefs = await SharedPreferences.getInstance();

    for (var key in keys) {
      await prefs.remove(key);
    }
  }
}
