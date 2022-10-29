import 'package:flutter/material.dart';

import '../api/audio_data.dart';
import 'playlist.dart';
import 'package:pediatko/dialog.dart';
import 'package:pediatko/show.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.showData}) : super(key: key);

  final List<Show> showData;

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Future<List<AudioData>>> futureAudioData = [];
  int audioDataNumber = 6;
  int errorCounter = 0;

  @override
  void initState() {
    super.initState();

    /*
    for (int i = 0; i < widget.showData.length; i++) {
      futureAudioData.add(getTrack(context, widget.showData[i]));
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.white),
        child: GridView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 0.0, mainAxisSpacing: 30.0),
          children: [for (var show in widget.showData) buttonAudioLoader(show)],
        ),
      ),
    );
  }

  SizedBox buttonAudioLoader(Show show) {
    // test dynamic (better UI for tablets)
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final hw = width * height;
    final iconSize = hw * 0.00033;

    GlobalKey globalKey = GlobalKey();

    return SizedBox(
      height: height * 0.5,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: show.bgColor,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: IconButton(
              key: globalKey,
              padding: const EdgeInsets.all(15),
              icon: Image.network(show.iconUrl),
              iconSize: iconSize,
              onPressed: () =>
                  pageRouteAnimation(context, show, globalKey, height, width),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: iconSize + 30, // icon + 2*padding border
            child: Text(
              show.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  pageRouteAnimation(BuildContext context, Show show, dynamic key,
      double height, double width) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    Offset? position = box?.localToGlobal(Offset.zero);
    double x = 0.0;
    double y = 0.0;

    /// half of icon size
    /// this will be used to center position alignment
    final double size = height * width * 0.00036 * 0.5;

    /// normalize min max from -1 to 1
    /// position starts at top left corner, add size to center
    if (position != null) {
      x = (((position.dx + size) / width) * 2) - 1;
      y = (((position.dy + size) / height) * 2) - 1;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return PlaylistPage(show: show);
        },
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation =
              CurvedAnimation(parent: animation, curve: Curves.easeOutExpo);
          return ScaleTransition(
            alignment: Alignment(x, y),
            scale: animation,
            child: child,
          );
        },
      ),
    );
  }

  Container notLoaded(double iconSize) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.black26,
      ),
      child: const Center(
        child: Text(
          'Load error',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @Deprecated("not in use anymore, deleted soon")
  Padding paddedText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10),
      child: Text(
        text,
        textScaleFactor: 2,
      ),
    );
  }
}
