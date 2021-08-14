// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rateltech/notifiers/login_notifier.dart';
import 'package:rateltech/screens/home_screen.dart';
import 'package:rateltech/screens/login_screen.dart';
import 'package:rateltech/screens/randevu_screen.dart';
import 'package:rateltech/screens/splash_screen.dart';
import 'package:rateltech/screens/test_screen.dart';
import 'package:rateltech/screens/validation_screen.dart';
import 'package:rateltech/screens/video_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => LoginNotifier(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        "/splash_screen": (context) => SplashScreen(),
        "/login_screen": (context) => LoginScreen(),
        "/validation_screen": (context) => ValidationScreen(),
        "/home_screen": (context) => HomeScreen(),
        "/video_screen": (context) => VideoScreen(),
        "/test_screen": (context) => TestScreen(),
        "/randevu_screen": (context) => RandevuScreen(),
      },
    );
  }
}
