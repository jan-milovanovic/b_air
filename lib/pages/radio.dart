import 'package:flutter/material.dart';

import 'musicPlayer.dart';

@Deprecated("radio does not need it's own class")
class RadioZ extends StatelessWidget {
  const RadioZ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const radioZurl = "http://mp3.rtvslo.si/raz";

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MusicPlayer(
                  url: radioZurl,
                )));

    return const Text("error displaying music player");
  }
}
