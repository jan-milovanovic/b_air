import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:pediatko/api/radiodata.dart';

import 'audioplay/custom widgets/control_buttons.dart';
import 'package:pediatko/dialog.dart';

class RadioPlayer extends StatefulWidget {
  const RadioPlayer({Key? key, required this.radioData}) : super(key: key);

  final RadioData radioData;

  @override
  State<StatefulWidget> createState() => _RadioState();
}

class _RadioState extends State<RadioPlayer> {
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
    final radioStreamUrl = await RadioData().fetchStreamData(context);

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    try {
      final AudioSource audio;

      /// HLS stream
      audio = HlsAudioSource(
        Uri.parse(radioStreamUrl),
        tag: MediaItem(
          id: '0',
          title: widget.radioData.title!,
          displaySubtitle: widget.radioData.subtitle!,
          artUri: Uri.parse(widget.radioData.iconUrl!),
        ),
      );

      await _player.setAudioSource(audio);
      _player.play();
    } catch (e) {
      if (mounted) {
        noInternetConnectionDialog(context, 2);
      }
      throw Exception('Could not load audio source');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double hw = height * width;
    final iconSize = hw * 0.0008;

    Color defaultColor = Theme.of(context).colorScheme.primary;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<SequenceState?>(
                    stream: _player.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      if (state?.sequence.isEmpty ?? true) {
                        return const SizedBox();
                      }
                      if (!snapshot.hasData) {
                        return loadingIndicator();
                      } else if (snapshot.hasError) {
                        throw Exception('Radio data did not load');
                      } else {
                        final metadata = state!.currentSource!.tag as MediaItem;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: loadImageOrFiller(
                                    metadata.artUri, iconSize),
                              ),
                            ),
                            Text(
                              "V ŽIVO",
                              style: TextStyle(
                                color: defaultColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              metadata.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              metadata.displaySubtitle!,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      }
                    }),
              ),
              SizedBox(
                height: height * 0.2,
                child: ControlButtons(_player, isLive: true),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  loadImageOrFiller(Uri? artUri, double iconSize) {
    return artUri!.path == ""
        ? Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.black26),
            height: iconSize,
            width: iconSize,
            child: const Center(child: Text('Load error')),
          )
        : Image(
            image: NetworkImage(artUri.toString()),
            height: iconSize,
          );
  }
}
