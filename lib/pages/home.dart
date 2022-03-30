import 'package:flutter/material.dart';

import 'radio.dart';
import '../audio_data.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /// variables are numbered by row number
  late Future<List<AudioData>> futureAudioData1;
  late Future<List<AudioData>> futureAudioData2;
  late Future<List<AudioData>> futureAudioData3;

  @override
  void initState() {
    super.initState();
    futureAudioData1 = getTrack('173250372'); // radijske igre
    futureAudioData2 = getTrack('161851955'); // zgodbe iz skoljke
    futureAudioData3 = getTrack('54'); // za lahko noc
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
            child: FutureBuilder<List<AudioData>>(
              future: futureAudioData1,
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
              }),
            ),
          ),
          const Text(
            "Pred posegom",
            textScaleFactor: 2,
          ),
          SizedBox(
            height: height / 3,
            child: FutureBuilder<List<AudioData>>(
              future: futureAudioData2,
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
              }),
            ),
          ),
          const Text(
            "Za lahko noč",
            textScaleFactor: 2,
          ),
          SizedBox(
            height: height / 3,
            child: FutureBuilder<List<AudioData>>(
                future: futureAudioData3,
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
