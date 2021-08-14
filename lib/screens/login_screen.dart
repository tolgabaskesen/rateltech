import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rateltech/constants/color.dart';
import 'package:rateltech/helpers/utils.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';
import 'package:rateltech/notifiers/login_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  // ignore: unused_field
  late String _phoneValue = "";
  String durum = "";
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
                        color: primaryRed,
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
                    height: size.height * 0.05,
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: Offset(0, 3))
                        ]),
                    width: size.width * 0.8,
                    height: size.height * 0.08,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: Row(
                            children: [
                              Container(
                                height: size.height * 0.05,
                                child: Image.asset(
                                  "assets/images/tr.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              AutoSizeText(" +90"),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          ////NUMARA GİRME BÖLÜMÜ
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Telefon Numaranızı Giriniz",
                              counterText: "",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            maxLength: 10,
                            cursorColor: Colors.red,
                            enableSuggestions: false,
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                _phoneValue = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
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
                        ////GİRİŞ BUTONU
                        style: ElevatedButton.styleFrom(
                          primary: primaryRed,
                          onPrimary: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        onPressed: () {
                          String validate = Utils.validate(_phoneValue);
                          if (validate.length > 0) {
                            setState(() {
                              durum = validate;
                            });
                          } else {
                            setState(() {
                              durum = validate;
                              prefs.setString("_phoneValue", _phoneValue);
                              state.setLoginUserFirst(_phoneValue);
                              Navigator.pushNamed(
                                  context, "/validation_screen");
                            });
                          }
                        },
                        child: AutoSizeText(
                          "GİRİŞ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.04),
                        ),
                      ),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        "Lütfen Devam Edebilmek İçin Giriş Yapınız..",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.034),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
