import 'package:flutter/material.dart';

class MusicPlayer extends StatelessWidget {
  const MusicPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomPaint(
        painter: Background(),
        child: Container(
          margin: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              songName(),
              SizedBox(height: height * 0.2),
              songImage(),
              SizedBox(height: height * 0.2),
              audioController(),
            ],
          ),
        ),
      ),
    );
  }
}

class Background extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path bottomColor = Path();
    bottomColor.addRect(Rect.fromLTRB(0, height * 0.8, width, height));
    //Rect.fromLTRB(left, top, right, bottom)
    paint.color = Colors.grey.shade400;
    canvas.drawPath(bottomColor, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// TODO: get songname
Text songName() {
  return const Text("Song name");
}

// TODO: get song image
Image songImage() {
  return const Image(image: AssetImage('assets/catTable.png'));
}

/// pause icon: pause, pause_circle, pause_circle_outline
/// play icon: play_arrow, play_arrow_outlined, play_arrow_rounded, play_circle, play_circle_outlined
/// skip next: skip_next, skip_next_outlined
/// skip prev: skip_previous, skip_previous_outlined
/// stop icon: stop, stop_circle, stop_circle_outlined
Container audioController() {
  return Container(
    child: Column(
      children: [
        // get playtimebar
        // get media plays
        Row(
          children: [
            IconButton(icon: const Icon(Icons.playlist_play), onPressed: () {}),
            IconButton(
                icon: const Icon(Icons.playlist_remove), onPressed: () {}),
          ],
        )
      ],
    ),
  );
}
