import 'package:flutter/material.dart';
import 'package:pediatko/api/audio_data.dart';
import 'package:pediatko/pages/audioplay/playlist_manager.dart';
import 'package:pediatko/pages/audioplay/recording_player.dart';
import 'package:pediatko/show.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key, required this.show}) : super(key: key);

  final Show show;

  @override
  State<StatefulWidget> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late Future<PlaylistManager> playlist;
  late Future<List<AudioData>> audioDataList;

  @override
  void initState() {
    super.initState();
    playlist = PlaylistManager().create(context, widget.show);
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

  loadRecordings(PlaylistManager playlistManager) {
    final Color defaultColor = Theme.of(context).colorScheme.primary;

    return FutureBuilder<PlaylistManager>(
        future: playlist,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.playlist.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  List<AudioData> audioDataList =
                      playlistManager.getAudioDataList();

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RecordingPlayer(
                            playlist: playlistManager.getPlaylist(),
                            audioDataList: audioDataList,
                            show: widget.show,
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
                                  audioDataList[index].title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                        divideBetween(audioDataList.length, index),
                      ],
                    ),
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final Color color = widget.show.bgColor;

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
              child: Image.network(
                widget.show.iconUrl,
                width: width / 3,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.show.title,
            style: const TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          //const SizedBox(height: 20),
          const Spacer(flex: 1),
          SizedBox(
            height: 70,
            width: width - 50,
            child: SingleChildScrollView(
              child: Text(
                widget.show.description,
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
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: SizedBox(
                height: height / 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: FutureBuilder<PlaylistManager>(
                    future: playlist,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Prišlo je do napake pri nalaganju'));
                      } else if (snapshot.hasData) {
                        return loadRecordings(snapshot.data!);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
