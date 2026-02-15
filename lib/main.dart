import 'package:flutter/material.dart';
import 'package:tasky_app/core/services/preferences_manager.dart';
import 'package:tasky_app/core/services/theme_controller.dart';
import 'package:tasky_app/core/theme/dark_theme.dart';
import 'package:tasky_app/core/theme/light_theme.dart';
import 'package:tasky_app/screens/main_screen.dart';
import 'package:tasky_app/screens/welcome_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PreferencesManager().init();
  ThemeController().init();

  String? username = PreferencesManager().getString("username");

  runApp(MyApp(username: username));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.username});

  final String? username;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeNotifier,
      builder: (BuildContext context, ThemeMode value, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tasky',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: value,
          // updated value after change theme
          home: username == null ? WelcomeScreen() : MainScreen(),
        );
      },
    );
  }
}
