import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pediatko/modals/show.dart';
import 'package:pediatko/pages/recording_player/services/playlist_manager.dart';
import 'package:pediatko/pages/recording_player/recording_player.dart';
import 'package:pediatko/services/recording.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key, required this.show}) : super(key: key);

  final Show show;

  @override
  State<StatefulWidget> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late Future<PlaylistManager> playlist;
  late Future<List<Recording>> audioDataList;

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
    return FutureBuilder<PlaylistManager>(
        future: playlist,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.playlist.length == 0) {
              return const Center(
                child: Text('Ta seznam še nima dodanih pravljic :('),
              );
            }

            return ListView.builder(
                itemCount: snapshot.data!.playlist.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  List<Recording> audioDataList =
                      playlistManager.getAudioDataList();

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
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
                            Icon(
                              Icons.play_circle_fill_rounded,
                              size: 40,
                              color: widget.show.bgColor,
                            ),
                            Expanded(
                              child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    stops: const [0.0, 0.05, 0.9, 1.0],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.transparent,
                                      Colors.white.withOpacity(1.0),
                                      Colors.white.withOpacity(1.0),
                                      Colors.transparent
                                    ],
                                  ).createShader(bounds);
                                },
                                blendMode: BlendMode.dstIn,
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.only(
                                    left: 14.0,
                                    right: 20.0,
                                  ),
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    audioDataList[index].title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20.0)
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
          const Spacer(flex: 2),
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
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          //const SizedBox(height: 20),
          const Spacer(flex: 2),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: height * 0.1 < 100 ? 80 : height * 0.1,
              maxWidth: width - 50,
            ),
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  stops: const [0.0, 0.1, 0.8, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(1.0),
                    Colors.white.withOpacity(1.0),
                    Colors.transparent
                  ],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 10.0, bottom: 14.0),
                child: Text(
                  widget.show.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
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
