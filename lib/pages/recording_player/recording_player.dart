import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:pediatko/constants/custom_dialogs.dart';
import 'package:pediatko/modals/show.dart';
import 'package:pediatko/pages/recording_player/components/control_buttons.dart';
import 'package:pediatko/pages/recording_player/components/player_seekbar.dart';
import 'package:pediatko/pages/recording_player/components/position_data.dart';
import 'package:pediatko/services/recording.dart';
import 'package:rxdart/rxdart.dart';

class RecordingPlayer extends StatefulWidget {
  const RecordingPlayer({
    Key? key,
    required this.playlist,
    required this.audioDataList,
    required this.index,
    required this.show,
  }) : super(key: key);

  final ConcatenatingAudioSource playlist;
  final int index;
  final List<Recording> audioDataList;
  final Show show;

  @override
  State<StatefulWidget> createState() => _RecordingState();
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
      if (mounted) {
        CustomDialogs.noInternetConnectionDialog(context);
      }
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

    Recording audioData = widget.audioDataList[playerOffset ?? widget.index];

    return Scaffold(
      backgroundColor: widget.show.bgColor,
      appBar: AppBar(
        title: Image.asset('assets/pediatko-logo.png', height: 25),
        centerTitle: true,
        backgroundColor: widget.show.bgColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                            color: widget.show.bgColor,
                          ),
                          height: iconSize,
                          child: Hero(
                            tag: 'imageUrl',
                            transitionOnUserGestures: true,
                            child: Image.network(
                              widget.show.iconUrl,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          audioData.showName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: widget.show.bgColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          audioData.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        SizedBox(
                          //TODO: split between big, medium, and small displays
                          height: height * 0.3 > 250 ? height * 0.3 : 200,
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
                              padding: const EdgeInsets.only(
                                top: 14.0,
                                bottom: 32.0,
                              ),
                              child: Text(audioData.titleDescription),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: ControlButtons(
                player: _player,
                isLive: false,
                color: widget.show.bgColor,
                height: height * 0.15,
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
                  onChangeEnd: (newPosition) => _player.seek(newPosition),
                  color: widget.show.bgColor,
                );
              },
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}
