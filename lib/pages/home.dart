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
    return Scaffold(
      body: ListView(
        children: [
          paddedText("Za pomiritev"),
          audioLoader(futureAudioData1),
          paddedText("Pred posegom"),
          audioLoader(futureAudioData2),
          paddedText("Za lahko noč"),
          audioLoader(futureAudioData3),
        ],
      ),
    );
  }

  Padding paddedText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10),
      child: Text(
        text,
        textScaleFactor: 2,
      ),
    );
  }

  Container loadingIndicator() {
    return Container(
        alignment: Alignment.center, child: const CircularProgressIndicator());
  }

  SizedBox audioLoader(Future<List<AudioData>> futureAudioData) {
    final height = MediaQuery.of(context).size.height;
    final iconSize = height / 6;

    return SizedBox(
      height: height / 4,
      child: FutureBuilder<List<AudioData>>(
        future: futureAudioData,
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: iconSize,
                  child: Column(
                    children: [
                      IconButton(
                        icon: Image.network(snapshot.data![index].imageUrl),
                        iconSize: iconSize,
                        onPressed: () {
                          playAudio(context, snapshot.data![index]);
                        },
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            snapshot.data![index].title,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        }),
      ),
    );
  }

  void playAudio(BuildContext context, AudioData audioData) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RadioPlayer(audioData: audioData)));
  }
}
