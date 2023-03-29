import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pediatko/modals/show.dart';
import 'package:pediatko/services/recording.dart';

class PlaylistManager {
  late ConcatenatingAudioSource playlist;
  late List<Recording> audioDataList;
  late Show show;

  ConcatenatingAudioSource getPlaylist() => playlist;
  List<Recording> getAudioDataList() => audioDataList;

  Future<PlaylistManager> create(BuildContext context, Show show) async {
    List<AudioSource> sourcePlaylist = [];

    audioDataList = await getTrack(context, show);

    for (var audioData in audioDataList) {
      sourcePlaylist.add(await getAudioSource(audioData, show));
    }

    ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      children: sourcePlaylist,
    );

    PlaylistManager playlistManager = PlaylistManager();
    playlistManager.playlist = playlist;
    playlistManager.audioDataList = audioDataList;
    playlistManager.show = show;

    return playlistManager;
  }

  Future<AudioSource> getAudioSource(Recording audioData, Show show) async {
    try {
      final AudioSource audio;

      // fetch mp3 file
      final responseMP3 = await http.get(Uri.parse(audioData.url));

      if (responseMP3.statusCode != 200) {
        throw Exception('Failed to load website: ${audioData.url}');
      }

      var stream = json.decode(responseMP3.body);
      stream = stream['data']['attributes']['stream_src'];

      audio = ProgressiveAudioSource(
        Uri.parse(stream),
        tag: MediaItem(
          id: '0',
          album: audioData.showName,
          title: audioData.title,
          displayDescription: audioData.titleDescription,
          artUri: Uri.parse(show.iconUrl),
        ),
      );

      return audio;
    } catch (e) {
      throw Exception('$e');
    }
  }
}
