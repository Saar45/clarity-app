import 'package:shared_preferences/shared_preferences.dart';

Future<void> setThemeinSharedPref(String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('theme', value);
}

Future<String> getThemeFromSharedPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('theme') ?? 'light';
}
