import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pediatko/audio_data.dart';
import 'package:pediatko/pages/recording_player.dart';

class ControlButtons extends StatefulWidget {
  final AudioPlayer player;
  final List<AudioData>? audioDataList;
  final int? index;

  const ControlButtons(this.player, {Key? key, this.audioDataList, this.index})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int? audioPrevious;
    int? audioNext;

    if (widget.index != null) {
      audioPrevious = widget.audioDataList![widget.index!].previous;
      audioNext = widget.audioDataList![widget.index!].next;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.index != null)
          StreamBuilder<SequenceState?>(
            stream: widget.player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: const Icon(Icons.skip_previous),
              color: audioPrevious != null
                  ? Theme.of(context).colorScheme.primary
                  : Colors.black38,
              iconSize: 64.0,
              onPressed: () {
                if (audioPrevious != null) {
                  widget.player.dispose();
                  widget.audioDataList![widget.index! - 1]
                      .playAudio(context, widget.audioDataList);
                }
              },
            ),
          ),
        StreamBuilder<PlayerState>(
          stream: widget.player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_circle_fill_rounded),
                color: Theme.of(context).colorScheme.primary,
                iconSize: 128.0,
                onPressed: widget.player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause_circle_filled_rounded),
                color: Theme.of(context).colorScheme.primary,
                iconSize: 128.0,
                onPressed: widget.player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay_circle_filled_rounded),
                color: Theme.of(context).colorScheme.primary,
                iconSize: 128.0,
                onPressed: () => widget.player.seek(Duration.zero,
                    index: widget.player.effectiveIndices!.first),
              );
            }
          },
        ),
        if (widget.index != null)
          StreamBuilder<SequenceState?>(
            stream: widget.player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: const Icon(Icons.skip_next),
              color: audioNext != null
                  ? Theme.of(context).colorScheme.primary
                  : Colors.black38,
              iconSize: 64.0,
              onPressed: () {
                if (widget.audioDataList![widget.index!].next != null) {
                  widget.player.dispose();
                  widget.audioDataList![widget.index! + 1]
                      .playAudio(context, widget.audioDataList);
                }
              },
            ),
          ),
      ],
    );
  }
}
