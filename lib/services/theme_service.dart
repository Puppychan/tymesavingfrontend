import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tymesavingfrontend/common/constant/local_storage_key_constant.dart';
import 'package:tymesavingfrontend/common/enum/theme_mode_type_enum.dart';
import 'package:tymesavingfrontend/services/utils/local_storage_service.dart';

class ThemeService extends ChangeNotifier with WidgetsBindingObserver {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeModeType _themeModeType = ThemeModeType.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;
  ThemeModeType get themeModeType => _themeModeType;

  ThemeService() {
    WidgetsBinding.instance.addObserver(this);
    loadThemeMode();
  }

  ThemeMode get themeMode {
    switch (_themeModeType) {
      case ThemeModeType.time:
        return _evaluateThemeBasedOnTime();
      case ThemeModeType.system:
        return _evaluateSystemTheme();
      default:
        return _themeMode;
    }
  }

  void setTheme(ThemeModeType modeType, {ThemeMode? mode}) {
    switch (modeType) {
      case ThemeModeType.time:
        _themeMode = _evaluateThemeBasedOnTime();
        break;

      case ThemeModeType.system:
        _themeMode = _evaluateSystemTheme();
        break;
      default:
        _themeMode = mode ?? ThemeMode.light;
    }
    _themeModeType = modeType;

    LocalStorageService.setString(LOCAL_THEME, _themeMode.toString());
    LocalStorageService.setString(LOCAL_THEME_TYPE, _themeModeType.toString());
    notifyListeners();
  }

  // void toggleSystemThemeBasedOnTime() {
  //   _useSystemThemeBasedOnTime = !_useSystemThemeBasedOnTime;

  //   LocalStorageService.setBool(
  //       LOCAL_USING_SYSTEM_THEME_TIME, _useSystemThemeBasedOnTime);
  //   notifyListeners();
  // }

  Future<void> loadThemeMode() async {
    final themeModeString = await LocalStorageService.getString(LOCAL_THEME);
    _themeModeType = ThemeModeType.fromString(
        await LocalStorageService.getString(LOCAL_THEME_TYPE) ?? "");

    // _useSystemThemeBasedOnTime = await LocalStorageService.getBool(LOCAL_USING_SYSTEM_THEME_TIME) ?? false;

    switch (_themeModeType) {
      case ThemeModeType.time:
        _themeMode = _evaluateThemeBasedOnTime();
        break;
      case ThemeModeType.system:
        _themeMode = _evaluateSystemTheme();
        break;
      default:
        if (themeModeString != null) {
          _themeMode = ThemeMode.values.firstWhere(
            (element) => element.toString() == themeModeString,
            orElse: () => ThemeMode.system,
          );
        } else {
          _themeMode = ThemeMode.light;
        }
    }
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

  // Method to evaluate the theme based on system settings
  ThemeMode _evaluateSystemTheme() {
    Brightness deviceBrightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;

    print("Current device brightness $deviceBrightness");
    if (deviceBrightness == Brightness.dark) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  @override
  void didChangePlatformBrightness() {
    if (_themeModeType == ThemeModeType.system) {
      _themeMode = _evaluateSystemTheme();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
