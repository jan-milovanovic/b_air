import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:pediatko/dialog.dart';
import 'package:rxdart/rxdart.dart';
import 'player_seekbar.dart';
import 'control_buttons.dart';
import '../../audio_data.dart';

class RecordingPlayer extends StatefulWidget {
  const RecordingPlayer({
    Key? key,
    required this.playlist,
    required this.audioDataList,
    required this.index,
  }) : super(key: key);

  final ConcatenatingAudioSource playlist;
  final int index;
  final List<AudioData> audioDataList;

  @override
  _RecordingState createState() => _RecordingState();
}

class _RecordingState extends State<RecordingPlayer> {
  late AudioPlayer _player;
  int? playerOffset;

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

    _player.currentIndexStream.listen((event) {
      setState(() => playerOffset = event ?? widget.index);
    });

    try {
      await _player.setAudioSource(widget.playlist, initialIndex: widget.index);
      _player.play();
    } catch (e) {
      // Catch load errors: 404, invalid url ...
      noInternetConnectionDialog(context, 1);
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
    final double width = MediaQuery.of(context).size.height;
    final hw = height * width;
    final iconSize = hw * 0.00020;
    //final iconSize = height * 0.169;

    AudioData audioData = widget.audioDataList[playerOffset ?? widget.index];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: audioData.bgColor,
        appBar: AppBar(
          title: Image.asset('assets/pediatko-logo.png', height: 25),
          centerTitle: true,
          backgroundColor: audioData.bgColor,
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: audioData.bgColor,
                              ),
                              child: Hero(
                                tag: 'imageUrl',
                                child: Image.network(
                                  audioData.imageUrl,
                                ),
                                transitionOnUserGestures: true,
                              ),
                              height: iconSize,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              audioData.showName,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: audioData.bgColor),
                            ),
                            const SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                audioData.title,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: height * 0.25,
                              child: SingleChildScrollView(
                                child: Text(audioData.titleDescription),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: SizedBox(
                    height: height * 0.18,
                    child: ControlButtons(_player, isLive: false),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
