import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/constant/local_storage_key_constant.dart';
import 'package:tymesavingfrontend/services/utils/local_storage_service.dart';

class ThemeService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeService() {
    loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
      LocalStorageService.setString(LOCAL_THEME, _themeMode.toString());
    } else {
      _themeMode = ThemeMode.dark;
      LocalStorageService.setString(LOCAL_THEME, _themeMode.toString());
    }
    notifyListeners();
  }

  Future<void> loadThemeMode() async {
    final themeModeString = await LocalStorageService.getString(LOCAL_THEME);
    if (themeModeString != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (element) => element.toString() == themeModeString,
        orElse: () => ThemeMode.system,
      );
      debugPrint("Theme Mode loaded: $_themeMode");
      notifyListeners();
    }
  }
}
