import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:rateltech/constants/color.dart';
import 'package:rateltech/constants/password.dart';
import 'package:rateltech/notifiers/login_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ValidationScreen extends StatefulWidget {
  ValidationScreen({Key? key}) : super(key: key);

  @override
  _ValidationScreenState createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  String durum = "";

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late final SharedPreferences prefs;
  @override
  void initState() {
    loadPref();
    super.initState();
  }

  void loadPref() async {
    prefs = await _prefs;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ////ARKA PLAN
            Container(
              height: size.height,
              width: size.width,
              child: Column(
                children: [
                  Flexible(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[700],
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.elliptical(size.width, 100.0)),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: Container(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            ////ANA İÇERİK
            Container(
              width: size.width,
              height: size.height,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.5,
                    child: Image.asset("assets/images/ratel.png"),
                  ),
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      "Lütfen Devam Edebilmek İçin Doğrulama Kodunu Giriniz..",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.034),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  dogrulamaKodu(context),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  (durum.length > 1) //// HATA MESAJI VERİLECEK İSE YER OLUŞTUR
                      ? Padding(
                          padding: EdgeInsets.all(15),
                          child: AutoSizeText(
                            durum,
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(),
                        ),
                  Consumer<LoginNotifier>(builder: (context, state, widget) {
                    var state =
                        Provider.of<LoginNotifier>(context, listen: false);
                    return Container(
                      width: size.width * 0.8,
                      height: size.height * 0.08,
                      child: ElevatedButton(
                        ////DEVAM ET BUTONU
                        style: ElevatedButton.styleFrom(
                          primary: primaryRed,
                          onPrimary: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        onPressed: () {
                          if (_pinPutController.text ==
                              PasswordConstants.LOGIN_PASSWORD) {
                            state.login(state.LoginUser);
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/home_screen", (route) => false);
                          } else {
                            setState(() {
                              durum =
                                  "Lütfen verilen kodu doğru şekilde giriniz!";
                            });
                          }
                        },
                        child: AutoSizeText(
                          "DEVAM ET",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.04),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Color(0xFFD32F2F)),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  Widget dogrulamaKodu(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      height: size.height * 0.07,
      child: PinPut(
        fieldsCount: 6,
        onSubmit: (String pin) => print(_pinPutController.text),
        focusNode: _pinPutFocusNode,
        controller: _pinPutController,
        submittedFieldDecoration: _pinPutDecoration.copyWith(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.black)),
        selectedFieldDecoration: _pinPutDecoration,
        followingFieldDecoration: _pinPutDecoration.copyWith(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
