import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';

import 'audioplay/control_buttons.dart';
import '../audio_data.dart';

class RadioPlayer extends StatefulWidget {
  const RadioPlayer({Key? key, required this.audioData}) : super(key: key);

  final AudioData audioData;

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
        Uri.parse(widget.audioData.url),
        tag: MediaItem(
          id: '0',
          title: widget.audioData.title,
          artUri: Uri.parse(widget.audioData.imageUrl),
        ),
      );

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

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    Color defaultColor = Theme.of(context).colorScheme.primary;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //backgroundColor: defaultColor,
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
                    final metadata = state!.currentSource!.tag as MediaItem;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image(
                              image: NetworkImage(metadata.artUri.toString()),
                              width: width / 1.5,
                            ),
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
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
              ControlButtons(_player),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}
