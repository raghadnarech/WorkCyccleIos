// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:motion/motion.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/AuthProvider.dart';
import 'package:qr_app/Controllers/EmployeeProvider.dart';
import 'package:qr_app/Controllers/MoneyProvider.dart';
import 'package:qr_app/Controllers/PermissionsProvider.dart';
import 'package:qr_app/Controllers/TaskProvider.dart';
import 'package:qr_app/Controllers/WorkTimeProvider.dart';
import 'package:qr_app/Views/Auth/auth_page.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Motion.instance.initialize();
  Motion.instance.isPermissionRequired;
  final prefs = await SharedPreferences.getInstance();
  final isloging = prefs.getBool('isLogged') ?? false;
  print(isloging);
  runApp(MyApp(
    isLogging: isloging,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLogging;
  MyApp({required this.isLogging});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EmployeeProvider>(
          create: (context) => EmployeeProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider<TaskProvider>(
          create: (context) => TaskProvider(),
        ),
        ChangeNotifierProvider<MoneyProvider>(
          create: (context) => MoneyProvider(),
        ),
        ChangeNotifierProvider<WorkTimeProvider>(
          create: (context) => WorkTimeProvider(),
        ),
        ChangeNotifierProvider<PermissionsProvider>(
          create: (context) => PermissionsProvider(),
        ),
      ],
      child: CupertinoApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: L10n.all,
        locale: Locale('ar'),
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(
          scaffoldBackgroundColor: Color(0xffffffff),
          textTheme: CupertinoTextThemeData(
              textStyle: TextStyle(
            color: CupertinoColors.black,
            fontFamily: "Cairo",
          )),
          primaryColor: Color(0xff339ff4),
        ),
        home: Splash(isLogging: isLogging),
      ),
    );
  }
}
