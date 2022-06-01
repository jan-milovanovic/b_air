import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'audioplay/player_seekbar.dart';
import 'audioplay/control_buttons.dart';
import '../audio_data.dart';
import '../auth/secrets.dart' as secret;

class RecordingPlayer extends StatefulWidget {
  const RecordingPlayer(
      {Key? key, required this.audioData, required this.color})
      : super(key: key);

  final AudioData audioData;
  final Color color;

  @override
  _RecordingState createState() => _RecordingState();
}

class _RecordingState extends State<RecordingPlayer> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      //print('A stream error occurred: $e');
    });
    try {
      final AudioSource audio;

      // fetch jwt key
      final responseJWT = await http.get(Uri.parse(
          'https://api.rtvslo.si/ava/getRecordingDrm/${widget.audioData.id}?client_id=${secret.clientId}'));

      if (responseJWT.statusCode != 200) {
        throw Exception(
            'Failed to load website for title: ${widget.audioData.title}, link: ${widget.audioData.url}');
      }

      final String jwt = json.decode(responseJWT.body)['response']['jwt'];

      // fetch mp3 file
      final responseMP3 = await http.get(Uri.parse(
          'https://api.rtvslo.si/ava/getMedia/${widget.audioData.id}?client_id=${secret.clientId}&jwt=$jwt'));

      if (responseMP3.statusCode != 200) {
        throw Exception(
            'Failed to load website for title: ${widget.audioData.title}, link: ${widget.audioData.url}');
      }

      var mp3 = json.decode(responseMP3.body);
      mp3 = mp3['response']['mediaFiles'][0]['streams'];

      // some recordings are in saved in hls, do not remove this!
      if (mp3['hls_sec'] != null) {
        mp3 = mp3['hls_sec'];

        audio = HlsAudioSource(
          Uri.parse(mp3),
          tag: MediaItem(
            id: '0',
            album: widget.audioData.showName,
            title: widget.audioData.title,
            displayDescription: widget.audioData.titleDescription,
            artUri: Uri.parse(widget.audioData.imageUrl),
          ),
        );
      } else {
        if (mp3['https'] != null) {
          mp3 = mp3['https'];
        } else if (mp3['http'] != null) {
          mp3 = mp3['http'];
        } else {
          mp3 = mp3['mpeg-dash'];
        }

        audio = ProgressiveAudioSource(
          Uri.parse(mp3),
          tag: MediaItem(
            id: '0',
            album: widget.audioData.showName,
            title: widget.audioData.title,
            displayDescription: widget.audioData.titleDescription,
            artUri: Uri.parse(widget.audioData.imageUrl),
          ),
        );
      }

      await _player.setAudioSource(audio);
      _player.play();
    } catch (e, stackTrace) {
      // TODO: Catch load errors: 404, invalid url ...
      //print("Error loading playlist: $e");
      //print(stackTrace);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: widget.color,
        appBar: AppBar(
          title: const Text('Pediatko'),
          centerTitle: true,
          backgroundColor: widget.color,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_downward),
            onPressed: () => Navigator.pop(context),
            color: Colors.white,
            iconSize: 30,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              color: Colors.white),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: StreamBuilder<SequenceState?>(
                    stream: _player.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      if (state?.sequence.isEmpty ?? true) {
                        return const SizedBox();
                      }
                      final metadata = state!.currentSource!.tag as MediaItem;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image(
                                    image: NetworkImage(
                                        metadata.artUri.toString()),
                                    //width: width / 3,
                                    height: height * 0.169,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  metadata.album!,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: widget.color),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  metadata.title,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: height * 0.25,
                                  child: SingleChildScrollView(
                                    child: Text(metadata.displayDescription!),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Center(
                  child: SizedBox(
                    height: height * 0.18,
                    child: ControlButtons(_player),
                  ),
                ),

                StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: (newPosition) {
                        _player.seek(newPosition);
                      },
                    );
                  },
                ),
                const SizedBox(height: 30.0),
                //const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
