import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rateltech/constants/color.dart';
import 'package:rateltech/models/notification_model.dart';
import 'package:rateltech/models/randevu_model.dart';
import 'package:rateltech/notifiers/login_notifier.dart';
import 'package:rateltech/notifiers/test_notifier.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rateltech/screens/home_screen.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class RandevuScreen extends StatefulWidget {
  const RandevuScreen({Key? key}) : super(key: key);

  @override
  _RandevuScreenState createState() => _RandevuScreenState();
}

class _RandevuScreenState extends State<RandevuScreen> {
  var _randevular;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // ignore: close_sinks
  final BehaviorSubject<String?> selectNotificationSubject =
      BehaviorSubject<String?>();
  // ignore: close_sinks
  final BehaviorSubject<ReceivedNotification>
      // ignore: close_sinks
      didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

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
      _requestPermissions(); //// APPLE CİHAZLAR İÇİN YETKİ İSTEĞİ
      _configureSelectNotificationSubject();
      _configureDidReceiveLocalNotificationSubject();
      var androidInitilize = new AndroidInitializationSettings('app_icon');
      var iOSinitilize = new IOSInitializationSettings();
      var initilizationsSettings = new InitializationSettings(
          android: androidInitilize, iOS: iOSinitilize);
      fltrNotification.initialize(initilizationsSettings,
          onSelectNotification: notificationSelected);
    });
    super.initState();
  }

  Future notificationSelected(String? payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }

  Future<void> _zonedScheduleNotification() async {
    final scheduledDate = tz.TZDateTime.from(DateTime.now(), tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledDate.add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails('your channel id',
                'your channel name', 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Desi programmer", "This is my channel",
        importance: Importance.max);
    var iOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await fltrNotification.show(
        0, "Task", "You created a Task", generalNotificationDetails,
        payload: "Task");
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => HomeScreen(),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String? payload) async {
      await Navigator.pushNamed(context, '/home_screen');
    });
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /* void bildirim () async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'scheduled title',
    'scheduled body',
    tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
    const NotificationDetails(
        android: AndroidNotificationDetails('your channel id',
            'your channel name', 'your channel description')),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  } */

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
                                      _showNotification();
                                      //_zonedScheduleNotification();
                                      //Navigator.pop(context);
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
