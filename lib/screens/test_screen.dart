import 'dart:async';
import 'dart:convert';
// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rateltech/constants/color.dart';
import 'package:rateltech/models/soru_cevap.dart';
import 'package:rateltech/notifiers/login_notifier.dart';
import 'package:rateltech/notifiers/test_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  var _soruCevap;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      String data = await DefaultAssetBundle.of(context)
          .loadString("assets/json/test.json");
      setState(() {
        _soruCevap = soruCevapFromJson(data);
        istatistik();
      });
    });
    super.initState();
  }

  void istatistik() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    var loginState = Provider.of<LoginNotifier>(context, listen: false);
    var testState = Provider.of<TestNotifier>(context, listen: false);
    testState.setCorrectPoint(user.getInt(loginState.LoginUser + "correct")!);
    testState.setFalsePoint(user.getInt(loginState.LoginUser + "false")!);
  }

  Color? renk1 = Colors.white;
  Color? renk2 = Colors.white;
  Color? renk3 = Colors.white;
  Color? renk4 = Colors.white;
  int _start = 2;
  Timer? timer;
  bool isAnswered = false;
  int soruNo = 0;

  void startTimer(int cevapNo) {
    if (isAnswered == false) {
      ////Cevap işaretlendiğinde bir süre beklenip devam edilecek
      cevapIsaretle(cevapNo);
      _start = 2;
      const oneSec = const Duration(seconds: 1);
      timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
          if (_start < 1) {
            timer.cancel();
            dogruCevapBelirle(cevapNo);
          } else {
            _start = _start - 1;
          }
        }),
      );
    }
  }

  void yeniSoruTimer() {
    ////Yeni soruya geçilmesi için zamanlayıcı
    _start = 2;
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(() {
        if (_start < 1) {
          timer.cancel();
          setState(() {
            if (soruNo < 2) {
              soruNo++;
            } else {
              soruNo = 0;
            }
            renk1 = Colors.white;
            renk2 = Colors.white;
            renk3 = Colors.white;
            renk4 = Colors.white;
            isAnswered = false;
          });
        } else {
          _start = _start - 1;
        }
      }),
    );
  }

  void dogruCevapBelirle(int cevapNo) {
    var testState = Provider.of<TestNotifier>(context, listen: false);
    var loginState = Provider.of<LoginNotifier>(context, listen: false);
    setState(() {
      if (_soruCevap[soruNo].dogrucevap == cevapNo.toString()) {
        testState.correctAnswer(loginState.LoginUser);
        yeniSoruTimer();
        switch (cevapNo) {
          case 0:
            renk1 = Colors.green[700];
            return null;
          case 1:
            renk2 = Colors.green[700];
            return null;
          case 2:
            renk3 = Colors.green[700];
            return null;
          case 3:
            renk4 = Colors.green[700];
            return null;
        }
      } else {
        testState.falseAnswer(loginState.LoginUser);
        dogruCevapIsaretle();
        yeniSoruTimer();
        switch (cevapNo) {
          case 0:
            renk1 = Colors.red[700];
            break;
          case 1:
            renk2 = Colors.red[700];
            break;
          case 2:
            renk3 = Colors.red[700];
            break;
          case 3:
            renk4 = Colors.red[700];
            break;
        }
      }
    });
  }

  void dogruCevapIsaretle() {
    setState(() {
      switch (int.parse(_soruCevap[soruNo].dogrucevap)) {
        case 0:
          renk1 = Colors.green[700];
          return null;
        case 1:
          renk2 = Colors.green[700];
          return null;
        case 2:
          renk3 = Colors.green[700];
          return null;
        case 3:
          renk4 = Colors.green[700];
          return null;
      }
    });
  }

  void cevapIsaretle(int cevapNo) {
    setState(() {
      isAnswered = true;
      switch (cevapNo) {
        case 0:
          renk1 = Colors.yellow[700];
          return null;
        case 1:
          renk2 = Colors.yellow[700];
          return null;
        case 2:
          renk3 = Colors.yellow[700];
          return null;
        case 3:
          renk4 = Colors.yellow[700];
          return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (_soruCevap == null)
        ? Container(
            height: size.height,
            width: size.width,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
        : Consumer2<LoginNotifier, TestNotifier>(
            builder: (context, state, lang, widget) {
            var loginState = Provider.of<LoginNotifier>(context, listen: false);
            var testState = Provider.of<TestNotifier>(context, listen: false);
            return Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  height: size.height,
                  width: size.width,
                  padding: EdgeInsets.fromLTRB(
                      10, size.height * 0.08, 10, size.height * 0.08),
                  child: Column(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Container(
                          height: size.height * 0.2,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: size.height * 0.2,
                                width: size.width,
                                alignment: Alignment.centerLeft,
                                padding:
                                    EdgeInsets.only(left: size.width * 0.1),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.home,
                                      color: Colors.black,
                                      size: size.height * 0.065,
                                    )),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: size.width * 0.3,
                                child: Image.asset("assets/images/ratel.png"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.01,
                            ),
                            child: Container(
                              width: size.width * 0.5,
                              height: size.height * 0.05,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryRed),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: AutoSizeText(
                                loginState.LoginUser,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                      ),
                      Flexible(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width * 0.15,
                              height: size.height * 0.05,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryRed),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: Colors.green,
                                  ),
                                  AutoSizeText(
                                    testState.userCorrectPoint.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: size.width * 0.15,
                              height: size.height * 0.05,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryRed),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: Colors.red,
                                  ),
                                  AutoSizeText(
                                    testState.userFalsePoint.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 7,
                        child: SingleChildScrollView(
                          child: Container(
                            height: size.height * 0.4,
                            child: Column(
                              children: [
                                soruModel(_soruCevap[soruNo].soru),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        cevapModel(_soruCevap[soruNo].cevap1,
                                            renk1, 0),
                                        cevapModel(_soruCevap[soruNo].cevap2,
                                            renk2, 1),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        cevapModel(_soruCevap[soruNo].cevap3,
                                            renk3, 2),
                                        cevapModel(_soruCevap[soruNo].cevap4,
                                            renk4, 3),
                                      ],
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          print(testState.userFalsePoint);
                                        },
                                        child: Text("bas"))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
  }

  Widget soruModel(String soruText) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.05,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: primaryRed),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: AutoSizeText(
          soruText,
          maxLines: 2,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget cevapModel(String cevapText, Color? renk, int cevapNo) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: () {
          startTimer(cevapNo);
        },
        style: ElevatedButton.styleFrom(
          side: BorderSide(
            width: 1.0,
            color: Colors.black,
          ),
          primary: renk,
          onPrimary: Colors.black,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        child: Container(
          width: size.width * 0.3,
          height: size.height * 0.05,
          alignment: Alignment.center,
          child: AutoSizeText(
            cevapText,
            maxLines: 2,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
