// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rateltech/constants/color.dart';
import 'package:rateltech/notifiers/login_notifier.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          padding: EdgeInsets.fromLTRB(
              10, size.height * 0.08, 10, size.height * 0.08),
          child: Column(
            children: [
              Consumer<LoginNotifier>(builder: (context, state, widget) {
                var state = Provider.of<LoginNotifier>(context, listen: false);
                return Flexible(
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
                          padding: EdgeInsets.only(left: size.width * 0.1),
                          child: IconButton(
                              onPressed: () {
                                state.logOut();
                                Navigator.pushNamedAndRemoveUntil(context,
                                    "/splash_screen", (route) => false);
                              },
                              icon: Icon(
                                Icons.exit_to_app,
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
                );
              }),
              Flexible(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: size.height * 0.05, bottom: size.height * 0.05),
                    child: Container(
                      width: size.width * 0.5,
                      height: size.height * 0.05,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryRed),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Consumer<LoginNotifier>(
                          builder: (context, state, widget) {
                        var state =
                            Provider.of<LoginNotifier>(context, listen: false);
                        return AutoSizeText(state.LoginUser,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ));
                      }),
                    ),
                  )),
              Flexible(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      ////VİDEOLARIM BUTONU
                      child: Container(
                        height: size.height * 0.15,
                        width: size.width * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryRed),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [0.1, 0.9],
                            colors: [
                              Colors.white,
                              primaryRed,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: size.width * 0.2,
                                child: Image.asset("assets/images/youtube.png"),
                              ),
                              AutoSizeText(
                                "VİDEOLARIM",
                                style: GoogleFonts.merriweather(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * 0.05,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "/video_screen");
                      },
                    ),
                    GestureDetector(
                      ////TEST VAKTİ BUTONU
                      child: Container(
                        height: size.height * 0.15,
                        width: size.width * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryRed),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [0.1, 0.9],
                            colors: [
                              Colors.white,
                              primaryRed,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: size.width * 0.2,
                                child: Image.asset("assets/images/quiz.png"),
                              ),
                              AutoSizeText(
                                "TEST VAKTİ",
                                style: GoogleFonts.merriweather(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * 0.05,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      ////RANDEVULARIM  BUTONU
                      child: Container(
                        height: size.height * 0.15,
                        width: size.width * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryRed),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [0.1, 0.9],
                            colors: [
                              Colors.white,
                              primaryRed,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: size.width * 0.2,
                                child:
                                    Image.asset("assets/images/reminder.png"),
                              ),
                              AutoSizeText(
                                "RANDEVULARIM",
                                style: GoogleFonts.merriweather(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * 0.05,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
