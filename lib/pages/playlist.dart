import 'package:flutter/material.dart';
import 'package:pediatko/audio_data.dart';
import 'package:pediatko/pages/audioplay/playlist_manager.dart';
import 'package:pediatko/pages/audioplay/recording_player.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key, required this.audioDataList}) : super(key: key);

  final List<AudioData> audioDataList;

  @override
  State<StatefulWidget> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late Future<PlaylistManager> playlist;

  @override
  void initState() {
    super.initState();

    playlist = PlaylistManager().create(widget.audioDataList);
  }

  /// function removes the last index divider which would appear at the bottom
  /// of the screen and is not wanted in the UI
  divideBetween(int listLength, int index) {
    return listLength > (index + 1)
        ? const Divider(
            color: Color.fromARGB(30, 0, 0, 0),
            indent: 20,
            endIndent: 20,
            thickness: 3,
          )
        : const SizedBox(height: 5);
  }

  loadRecordings(PlaylistManager pm) {
    final Color defaultColor = Theme.of(context).colorScheme.primary;

    return ListView.builder(
        itemCount: widget.audioDataList.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RecordingPlayer(
                    playlist: pm.getPlaylist(),
                    audioDataList: widget.audioDataList,
                    index: index,
                  ),
                ),
              );
            },
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(height: 50, width: 20),
                    Icon(Icons.play_circle_fill_rounded,
                        size: 40, color: defaultColor),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(right: 20),
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.audioDataList[index].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                divideBetween(widget.audioDataList.length, index),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final Color color = widget.audioDataList[0].bgColor;

    return Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/pediatko-logo.png', height: 25),
          centerTitle: true,
          backgroundColor: color,
          elevation: 0,
        ),
        backgroundColor: color,
        body: Column(
          children: [
            //const SizedBox(height: 20),
            const Spacer(flex: 1),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Hero(
                tag: 'imageUrl',
                transitionOnUserGestures: true,
                child: Image.network(widget.audioDataList[0].imageUrl,
                    width: width / 3),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.audioDataList[0].showName,
              style: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            //const SizedBox(height: 20),
            const Spacer(flex: 1),
            SizedBox(
              height: 70,
              width: width - 50,
              child: SingleChildScrollView(
                child: Text(
                  widget.audioDataList[0].showDescription,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 247, 249, 255),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: SizedBox(
                  height: height / 2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: FutureBuilder<PlaylistManager>(
                        future: playlist,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return loadRecordings(snapshot.data!);
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
