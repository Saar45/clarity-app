import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'data/theme.dart';
import 'services/shared_preferences_service.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData theme = appThemeLight;
  @override
  void initState() {
    super.initState();
    updateThemeFromSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clarity Point',
      theme: theme,
      home: SplashScreen(theme: theme, onComplete: () {
        return LoginScreen(changeTheme: setTheme);
      }),
    );
  }

  setTheme(Brightness brightness) async {
    if (brightness == Brightness.dark) {
      setState(() {
        theme = appThemeDark;
      });
      await SharedPreferencesService.saveTheme('dark');
    } else {
      setState(() {
        theme = appThemeLight;
      });
      await SharedPreferencesService.saveTheme('light');
    }
  }

  void updateThemeFromSharedPref() async {
    String themeText = await SharedPreferencesService.getTheme();
    if (themeText == 'light') {
      setTheme(Brightness.light);
    } else {
      setTheme(Brightness.dark);
    }
  }
}
