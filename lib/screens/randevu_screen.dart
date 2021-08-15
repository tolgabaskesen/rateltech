import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rateltech/notifiers/login_notifier.dart';
import 'package:rateltech/notifiers/test_notifier.dart';

class RandevuScreen extends StatefulWidget {
  const RandevuScreen({Key? key}) : super(key: key);

  @override
  _RandevuScreenState createState() => _RandevuScreenState();
}

class _RandevuScreenState extends State<RandevuScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer2<LoginNotifier, TestNotifier>(
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
                          padding: EdgeInsets.only(left: size.width * 0.1),
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
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
