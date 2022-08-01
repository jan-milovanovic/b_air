import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';

import 'audioplay/control_buttons.dart';
import 'package:pediatko/radiodata.dart';
import 'package:pediatko/dialog.dart';

/// radio player contains a single continuous live HLS audio stream
/// all data for the radio is hand given in the 'home_page.dart' file
class RadioPlayer extends StatefulWidget {
  const RadioPlayer({Key? key, required this.radioData}) : super(key: key);

  final RadioData radioData;

  @override
  _RadioState createState() => _RadioState();
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
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      //print('A stream error occurred: $e');
    });
    try {
      final AudioSource audio;

      /// HLS stream
      audio = HlsAudioSource(
        Uri.parse(widget.radioData.stream),
        tag: MediaItem(
          id: '0',
          title: widget.radioData.title,
          displaySubtitle: widget.radioData.subtitle,
          artUri: Uri.parse(widget.radioData.iconUrl),
        ),
      );

      await _player.setAudioSource(audio);
      _player.play();
    } catch (e) {
      noInternetConnectionDialog(context, 2);
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
                child: ControlButtons(_player, isLive: true),
                height: height * 0.2,
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
