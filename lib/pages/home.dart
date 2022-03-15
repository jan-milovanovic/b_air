import 'package:flutter/material.dart';

import 'musicPlayer.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Za pomiritev",
              textScaleFactor: 2,
            ),
            Expanded(
                child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // posnetki v prvi vrsti
                IconButton(
                  icon: Image.asset('assets/catTable.png'),
                  iconSize: 100,
                  onPressed: () {
                    playAudio(context);
                  },
                ),
                TextButton(
                  child: Image.asset('assets/catTable.png'),
                  onPressed: () {},
                ),
                const Image(image: AssetImage('assets/catTable.png')),
                const Image(image: AssetImage('assets/catTable.png')),
              ],
            )),
            const Text(
              "Pred posegom",
              textScaleFactor: 2,
            ),
            Expanded(
                child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                // posnetki v drugi vrsti
                Image(image: AssetImage('assets/catTable.png'))
              ],
            )),
            const Text(
              "Za lahko noč",
              textScaleFactor: 2,
            ),
            Expanded(
                child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                // posnetki v tretji vrsti
                Image(image: AssetImage('assets/catTable.png'))
              ],
            )),
          ],
        ),
      ));

  // row side scrollable

  // column ( container ( row )) x items

  // TODO: include audio data
  void playAudio(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MusicPlayer(
                  url:
                      "https://progressive.rtvslo.si/ava_archive11/2022/03/07/PravljicRA_SLO_5570251.mp3",
                )));
  }
}
