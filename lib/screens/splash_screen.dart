import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rateltech/notifiers/login_notifier.dart';
import 'package:rateltech/notifiers/test_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late int _start;
  late Timer timer;
  String route = "/login_screen";

  void startTimer() {
    ////Splash Screen için zamanlayıcı
    _start = 3;
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(() {
        if (_start < 1) {
          timer.cancel();
          Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
        } else {
          _start = _start - 1;
        }
      }),
    );
  }

  @override
  void initState() {
    ////Sisteme daha önceden giriş yapılıp, yapılmadığı kontrol ediliyor
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var state = Provider.of<LoginNotifier>(context, listen: false);
      var state2 = Provider.of<TestNotifier>(context, listen: false);
      SharedPreferences user = await SharedPreferences.getInstance();
      if (user.getString("user") == "" || user.getString("user") == null) {
        setState(() {
          route = "/login_screen";
        });
      } else {
        setState(() {
          state.setLoginUserFirst(user.getString("user")!);
          state.login(user.getString("user")!);
          route = "/home_screen";
        });
      }
    });
    ////Uygulama yüklendiği anda timer başlatılarak splash screen geçişi yapılıyor
    startTimer();
    super.initState();
  }

  Future<bool> isLogin() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    if (user.getString("user") != "" || user.getString("user") != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/ratel.png"),
            SizedBox(
              height: size.height * 0.1,
            ),
            CircularProgressIndicator(
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
