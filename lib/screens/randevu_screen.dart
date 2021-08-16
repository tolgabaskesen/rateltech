// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rateltech/constants/color.dart';
import 'package:rateltech/models/randevu_model.dart';
import 'package:rateltech/notifiers/login_notifier.dart';
import 'package:rateltech/notifiers/test_notifier.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class RandevuScreen extends StatefulWidget {
  const RandevuScreen({Key? key}) : super(key: key);

  @override
  _RandevuScreenState createState() => _RandevuScreenState();
}

class _RandevuScreenState extends State<RandevuScreen> {
  var _randevular;

  FlutterLocalNotificationsPlugin fltrNotification =
      new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      String data = await DefaultAssetBundle.of(context)
          .loadString("assets/json/randevu.json");
      setState(() {
        _randevular = randevuFromJson(data);
      });

      var androidInitilize = new AndroidInitializationSettings('app_icon');
      var iOSinitilize = new IOSInitializationSettings();
      var initilizationsSettings = new InitializationSettings(
          android: androidInitilize, iOS: iOSinitilize);
      fltrNotification.initialize(initilizationsSettings,
          onSelectNotification: notificationSelected);
    });
    randevuTarihKontrol();
    super.initState();
  }

  Future notificationSelected(String? payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          "Randevunuz var!!",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void randevuTarihKontrol() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/json/randevu.json");
    setState(() {
      _randevular = randevuFromJson(data);
    });
    ////RANDEVU GÜNÜ KONTROL ALGORİTMASI
    if (_randevular != null) {
      setState(() {
        var now = DateTime.now();
        var dateYear = now.year;
        var dateMonth = now.month;
        var dateDay = now.day;
        int diffYear = 0;
        int diffMonth = 0;
        int diffDay = 0;
        for (int i = 0; i < 3; i++) {
          var ranYear = int.parse(_randevular[i].tarih.substring(6, 10));
          var ranMonth = int.parse(_randevular[i].tarih.substring(3, 5));
          var ranDay = int.parse(_randevular[i].tarih.substring(0, 2));
          if (ranYear >= dateYear) {
            if (ranMonth >= dateMonth) {
              if (ranDay > dateDay) {
                diffYear = ranYear - dateYear;
                diffMonth = ranMonth - dateMonth;
                diffDay = ranDay - dateDay;
                String newMonth = "";
                if ((dateMonth + diffMonth) < 10) {
                  newMonth = "0" + (dateMonth + diffMonth).toString();
                }
                String newDate = (dateYear + diffYear).toString() +
                    "-" +
                    newMonth +
                    "-" +
                    (dateDay + diffDay).toString();

                DateTime tarih = DateTime.parse("$newDate 09:00:00.000000");
                _bildirimGonder(tarih);
                print(tarih);
                return null;
              }
            }
          }
        }
      });
    } else {
      randevuTarihKontrol();
    }
  }

  Future _bildirimGonder(DateTime tarih) async {
    ////Bildirim Fonksiyonu
    var androidDetails = new AndroidNotificationDetails(
        "RatelTech", "Randevu", "Bildirim",
        importance: Importance.max);
    var iOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iOSDetails);
    var scheduledTime = tarih.add(Duration(seconds: 5));
    print("Tarih ::: " + scheduledTime.toString());
    // ignore: deprecated_member_use
    fltrNotification.schedule(
        1,
        "Randevunuz var!!",
        "Yaklaşan randevunuzu görüntülemek için lütfen dokunun",
        scheduledTime,
        generalNotificationDetails);
  }

  Future _denemeBildirim() async {
    ////Bildirim deneyebilmek için deneme fonksiyonu
    var androidDetails = new AndroidNotificationDetails(
        "RatelTech", "Randevu", "Bildirim Denemesi",
        importance: Importance.max);
    var iOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iOSDetails);

    var scheduledTime = DateTime.now().add(Duration(seconds: 5));
    // ignore: deprecated_member_use

    fltrNotification.schedule(
        1,
        "Randevunuz var!!",
        "Randevunuzu görüntülemek için lütfen dokunun",
        scheduledTime,
        generalNotificationDetails);
  }

  String ayBelirle(String no) {
    switch (no) {
      case "01":
        return "Ocak";
      case "02":
        return "Şubat";
      case "03":
        return "Mart";
      case "04":
        return "Nisan";
      case "05":
        return "Mayıs";
      case "06":
        return "Haziran";
      case "07":
        return "Temmuz";
      case "08":
        return "Ağustos";
      case "09":
        return "Eylül";
      case "10":
        return "Ekim";
      case "11":
        return "Kasım";
      case "12":
        return "Aralık";
      default:
        return "Ocak";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (_randevular == null)
        ? Container(
            height: size.height,
            width: size.width,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
        : Consumer2<LoginNotifier, TestNotifier>(
            builder: (context, state, lang, widget) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.3, 0.9],
                      colors: [
                        Colors.white,
                        primaryRed,
                      ],
                    ),
                  ),
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
                        flex: 8,
                        child: Container(
                          height: size.height * 0.8,
                          width: size.width,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              randevuWidget(_randevular[0]),
                              randevuWidget(_randevular[1]),
                              randevuWidget(_randevular[2]),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: primaryRed,
                            elevation: 10,
                          ),
                          onPressed: () {
                            _denemeBildirim();
                          },
                          child: AutoSizeText("5 Saniyelik Deneme Bildirimi"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
  }

  Widget randevuWidget(var randevu) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.17,
      width: size.width * 0.9,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: size.height * 0.07,
              width: size.width * 0.8,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          AutoSizeText(
                            randevu.tarih.substring(0, 2),
                            style: GoogleFonts.merriweather(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            maxFontSize: double.infinity,
                            minFontSize: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: AutoSizeText(
                              ayBelirle(randevu.tarih.substring(3, 5)) +
                                  " " +
                                  randevu.tarih.substring(6, 10),
                              style: GoogleFonts.merriweather(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              maxFontSize: double.infinity,
                              minFontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.clock,
                            color: Colors.white,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: AutoSizeText(
                              randevu.saat,
                              style: GoogleFonts.merriweather(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              maxFontSize: double.infinity,
                              minFontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  randevu.hastane,
                  style: GoogleFonts.merriweather(
                    textStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  maxFontSize: double.infinity,
                  minFontSize: 12,
                ),
                AutoSizeText(
                  randevu.poliklinik,
                  style: GoogleFonts.merriweather(
                    textStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  maxFontSize: double.infinity,
                  minFontSize: 12,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    FaIcon(FontAwesomeIcons.userMd),
                    SizedBox(
                      width: 8,
                    ),
                    AutoSizeText(
                      randevu.doktoradi,
                      style: GoogleFonts.merriweather(
                        textStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      maxFontSize: double.infinity,
                      minFontSize: 12,
                    ),
                  ],
                ),
                AutoSizeText(
                  randevu.blok,
                  style: GoogleFonts.merriweather(
                    textStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  maxFontSize: double.infinity,
                  minFontSize: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
