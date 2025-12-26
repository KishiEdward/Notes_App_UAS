import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _darkModeKey = 'dark_mode';
  static const String _fontSizeKey = 'font_size';
  static const String _defaultCategoryKey = 'default_category';

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  Future<String> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fontSizeKey) ?? 'medium';
  }

  Future<void> setFontSize(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontSizeKey, value);
  }

  Future<String> getDefaultCategory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_defaultCategoryKey) ?? 'Pribadi';
  }

  Future<void> setDefaultCategory(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_defaultCategoryKey, value);
  }

  double getFontSizeValue(String size) {
    switch (size) {
      case 'small':
        return 0.9;
      case 'large':
        return 1.1;
      default:
        return 1.0;
    }
  }
}
