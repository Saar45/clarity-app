import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String THEME_KEY = 'app_theme';

  static Future<void> saveTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(THEME_KEY, theme);
  }

  static Future<String> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(THEME_KEY) ?? 'light';
  }
}
