import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerScreen extends StatefulWidget {
  final String id;
  const PlayerScreen({Key? key, required this.id}) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late YoutubePlayerController _controller;
  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.landscape) {
          return Scaffold(
            body: youtubeHierarchy(),
          );
        } else {
          return Scaffold(
            body: youtubeHierarchy(),
          );
        }
      }),
    );
  }

  youtubeHierarchy() {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.fill,
          child: YoutubePlayer(
            controller: _controller,
          ),
        ),
      ),
    );
  }
}
