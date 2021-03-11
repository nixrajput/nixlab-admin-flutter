import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:nixlab_admin/constants/colors.dart';
import 'package:nixlab_admin/constants/strings.dart';
import 'package:nixlab_admin/providers/firebase_provider.dart';
import 'package:nixlab_admin/providers/theme_provider.dart';
import 'package:nixlab_admin/screens/welcome.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (SchedulerBinding.instance!.window.platformBrightness ==
        Brightness.light) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: lightBackgroundColor,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: lightBackgroundColor,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: darkColor,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: darkColor,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FirebaseProvider()),
      ],
      builder: (ctx, _) {
        final themeProvider = Provider.of<ThemeProvider>(ctx);
        return MaterialApp(
          title: APP_NAME,
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          home: WelcomeScreen(),
        );
      },
    );
  }
}
