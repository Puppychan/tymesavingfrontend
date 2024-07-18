import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/constant/local_storage_key_constant.dart';
import 'package:tymesavingfrontend/services/utils/local_storage_service.dart';

class ThemeService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _useSystemThemeBasedOnTime = false;

  ThemeService() {
    loadThemeMode();
  }

  ThemeMode get themeMode {
    if (_useSystemThemeBasedOnTime) {
      return _evaluateThemeBasedOnTime();
    } else {
      return _themeMode;
    }
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;
  bool get useSystemThemeBasedOnTime => _useSystemThemeBasedOnTime;

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    _useSystemThemeBasedOnTime = false;

    LocalStorageService.setString(LOCAL_THEME, _themeMode.toString());
    LocalStorageService.setBool(LOCAL_USING_SYSTEM_THEME_TIME, _useSystemThemeBasedOnTime);
    notifyListeners();
  }

  void toggleSystemThemeBasedOnTime() {
    _useSystemThemeBasedOnTime = !_useSystemThemeBasedOnTime;

    LocalStorageService.setBool(LOCAL_USING_SYSTEM_THEME_TIME, _useSystemThemeBasedOnTime);
    notifyListeners();
  }

  Future<void> loadThemeMode() async {
    final themeModeString = await LocalStorageService.getString(LOCAL_THEME);
    _useSystemThemeBasedOnTime = await LocalStorageService.getBool(LOCAL_USING_SYSTEM_THEME_TIME) ?? false;

    if (themeModeString != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (element) => element.toString() == themeModeString,
        orElse: () => ThemeMode.system,
      );
    }
    debugPrint("Theme Mode loaded: $_themeMode, Use System Theme Based on Time: $_useSystemThemeBasedOnTime");
    notifyListeners();
  }

  ThemeMode _evaluateThemeBasedOnTime() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 18) {
      return ThemeMode.light;
    } else {
      return ThemeMode.dark;
    }
  }
}
