import 'package:flutter/material.dart';

import '../audio_data.dart';
import 'playlist.dart';
import 'package:pediatko/dialog.dart';

/// Home class contains a grid of all 6 given recordings
/// grid may be vertically scrollable if device is on smaller side
/// each track contains specific color data, which is sent to next windows
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
  late Future<List<AudioData>> futureAudioData4;
  late Future<List<AudioData>> futureAudioData5;
  late Future<List<AudioData>> futureAudioData6;
  int audioDataNumber = 6;
  int errorCounter = 0;

  @override
  void initState() {
    super.initState();
    futureAudioData1 = getTrack(context, '173250372',
        Image.asset('assets/images/Sobane-za-velikane.png'));
    futureAudioData2 = getTrack(
        context, '161851955', Image.asset('assets/images/Ustvarjam.png'));
    futureAudioData3 = getTrack(context, '54',
        Image.asset('assets/images/Najbolj-carobna-potovanja.png'));
    futureAudioData4 = getTrack(
        context, '97041869', Image.asset('assets/images/Igrajmo-se.png'));
    futureAudioData5 = getTrack(context, '47861243',
        Image.asset('assets/images/In-da-cas-hitreje-mine.png'));
    futureAudioData6 =
        getTrack(context, '88', Image.asset('assets/images/Za-miren-sen.png'));
  }

  /// grid renders from top left to bottom right
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: GridView(
          padding: const EdgeInsets.all(20.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 30.0),
          children: [
            buttonAudioLoader(futureAudioData1, const Color(0xffed724c)),
            buttonAudioLoader(futureAudioData2, const Color(0xffffa54b)),
            buttonAudioLoader(futureAudioData3, const Color(0xffed5875)),
            buttonAudioLoader(futureAudioData4, const Color(0xff39b070)),
            buttonAudioLoader(futureAudioData5, const Color(0xffe05251)),
            buttonAudioLoader(futureAudioData6, const Color(0xff7566ac)),
          ],
        ));
  }

  /// builds grid widgets based on future audio data
  ///
  /// a specific widget can fail to load, will display error message instead of
  /// the recording that is supposed to load
  /// Example: if track does not exist, widget will display center text: 'null'
  ///
  /// upon all widgets failing to load -> alert dialog is opened notifying user
  /// to check their connection. Leads user back to login screen (pop x2)
  SizedBox buttonAudioLoader(
      Future<List<AudioData>> futureAudioData, Color buttonColor) {
    final height = MediaQuery.of(context).size.height;
    final iconSize = height * 0.14;

    return SizedBox(
      height: height * 0.5,
      child: FutureBuilder<List<AudioData>>(
        future: futureAudioData,
        builder: ((context, snapshot) {
          if (snapshot.hasError ||
              (snapshot.hasData && snapshot.data!.isEmpty)) {
            if (++errorCounter == audioDataNumber) {
              Future.delayed(
                  Duration.zero, () => noInternetConnectionDialog(context, 2));
              return Center(child: Text('${snapshot.error}'));
            } else {
              return Center(child: Text('${snapshot.error}'));
            }
          } else if (!snapshot.hasData) {
            return loadingIndicator();
          } else {
            return Column(children: [
              Container(
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: IconButton(
                  padding: const EdgeInsets.all(15),
                  icon: snapshot.data![0].image!,
                  iconSize: iconSize,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaylistPage(
                            audioDataList: snapshot.data!, color: buttonColor),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: iconSize + 30, // icon + 2*padding border
                child: Text(
                  snapshot.data![0].showName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ]);
          }
        }),
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

  @Deprecated("""function is replaced in favor of [buttonAudioLoader], due to
  changes in design and will be removed in the future""")
  SizedBox audioLoader(Future<List<AudioData>> futureAudioData, Color color) {
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
                        icon: snapshot.data![index].image!,
                        iconSize: iconSize,
                        onPressed: () {
                          snapshot.data![index].playAudio(context, color);
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
}
