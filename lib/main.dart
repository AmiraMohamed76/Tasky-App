import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/services/preferences_manager.dart';
import 'package:tasky_app/core/services/theme_controller.dart';
import 'package:tasky_app/core/theme/dark_theme.dart';
import 'package:tasky_app/core/theme/light_theme.dart';
import 'package:tasky_app/features/navigation/main_screen.dart';
import 'package:tasky_app/features/tasks/controller/tasks_controller.dart';
import 'package:tasky_app/features/welcome/welcome_screen.dart';

import 'core/constants/storage_key.dart';
import 'core/services/hive_storage_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  await PreferencesManager().init();
  await HiveStorageManager().init();

  ThemeController().init();

  String? username = PreferencesManager().getString(StorageKey.userName);

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
        return ChangeNotifierProvider<TasksController>(
          create: (_) => TasksController()..init(),
          child: ScreenUtilInit(
            designSize: Size(375, 809),
            minTextAdapt: true,
            builder: (ctx, _) {
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
          ),
        );
      },
    );
  }
}
