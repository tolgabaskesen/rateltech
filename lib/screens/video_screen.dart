// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateltech/constants/color.dart';
import 'package:rateltech/screens/player_screen.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final List<String> _ids = [
    'Z0Y3jHuVQ_8',
    'WM5nqjY0b6k',
    '4fAZzJRvnrI',
    'fq4N0hgOWzU',
    '7jxuiDKBxg4',
  ];

  final List<String> _titles = [
    'RATELTECH YAZILIM A.Ş. TV8int ŞEHRİN NABZI Ropörtajı',
    'Emrecan Durmaz - Açılış Konuşması',
    'Dünyanın En Korkusuz Hayvanı: Bal Porsuğu Belgeseli',
    'Introducing Flutter',
    'Haluk Levent - İzmir Marşı',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          alignment: Alignment.center,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                Container(
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
                Container(
                  height: size.height * 0.7,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        videoButton(_ids[0], _titles[0]),
                        videoButton(_ids[1], _titles[1]),
                        videoButton(_ids[2], _titles[2]),
                        videoButton(_ids[3], _titles[3]),
                        videoButton(_ids[4], _titles[4]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget videoButton(String id, String title) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: GestureDetector(
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
                Container(
                  width: size.width * 0.5,
                  child: AutoSizeText(
                    title,
                    style: GoogleFonts.merriweather(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * 0.05,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new PlayerScreen(id: id)));
        },
      ),
    );
  }
}
