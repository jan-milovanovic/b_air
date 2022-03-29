import 'package:flutter/material.dart';

import 'radio.dart';
import '../audio_data.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<AudioData>> futureAudioData;

  @override
  void initState() {
    super.initState();
    futureAudioData = getZaLahkoNoc();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final iconSize = height / 7;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        children: [
          const Text(
            "Za pomiritev",
            textScaleFactor: 2,
          ),
          SizedBox(
              height: height / 3,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // posnetki v prvi vrsti
                  IconButton(
                    icon: Image.asset('assets/catTable.png'),
                    iconSize: 100,
                    onPressed: () {
                      null;
                      //playAudio(context);
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
          SizedBox(
              height: height / 3,
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
          SizedBox(
            height: height / 3,
            child: FutureBuilder<List<AudioData>>(
                future: futureAudioData,
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    //return Text(snapshot.data!.title);
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                              width: iconSize,
                              child: Column(children: [
                                IconButton(
                                    icon: Image.network(
                                        snapshot.data![index].imageUrl),
                                    iconSize: iconSize,
                                    onPressed: () {
                                      playAudio(context, snapshot.data![index]);
                                    }),
                                Text(
                                  snapshot.data![index].title,
                                  textAlign: TextAlign.center,
                                ),
                              ]));
                        });
                  }
                })),
          ),
        ],
      ),
    );
  }

// TODO: include audio data
  void playAudio(BuildContext context, AudioData audioData) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RadioPlayer(audioData: audioData)));
  }
}
