import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// [isLive] represents a live recording.
/// If the recording is live, do not to display skip to previous / next buttons
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;
  final bool isLive;

  const ControlButtons(this.player, {required this.isLive, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isLive)
          StreamBuilder<SequenceState?>(
            stream: player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: const Icon(Icons.skip_previous),
              color: Theme.of(context).colorScheme.primary,
              iconSize: 64.0,
              onPressed: player.hasPrevious ? player.seekToPrevious : null,
            ),
          ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
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
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause_circle_filled_rounded),
                color: Theme.of(context).colorScheme.primary,
                iconSize: 128.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay_circle_filled_rounded),
                color: Theme.of(context).colorScheme.primary,
                iconSize: 128.0,
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices!.first),
              );
            }
          },
        ),
        if (!isLive)
          StreamBuilder<SequenceState?>(
            stream: player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: const Icon(Icons.skip_next),
              color: Theme.of(context).colorScheme.primary,
              iconSize: 64.0,
              onPressed: player.hasNext ? player.seekToNext : null,
            ),
          ),
      ],
    );
  }
}
