import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pediatko/api/audio_data.dart';
import 'package:pediatko/auth/client_id.dart' as secret;

class PlaylistManager {
  late ConcatenatingAudioSource playlist;

  ConcatenatingAudioSource getPlaylist() => playlist;

  Future<PlaylistManager> create(List<AudioData> audioDataList) async {
    List<AudioSource> sourcePlaylist = [];

    for (var audioData in audioDataList) {
      sourcePlaylist.add(await getAudioSource(audioData));
    }

    ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      children: sourcePlaylist,
    );

    PlaylistManager playlistManager = PlaylistManager();
    playlistManager.playlist = playlist;

    return playlistManager;
  }

  Future<AudioSource> getAudioSource(AudioData audioData) async {
    try {
      final AudioSource audio;

      // fetch jwt key
      final responseJWT = await http.get(Uri.parse(
          'https://api.rtvslo.si/ava/getRecordingDrm/${audioData.id}?client_id=${secret.clientId}'));

      if (responseJWT.statusCode != 200) {
        throw Exception(
            'Failed to load website for title: ${audioData.title}, link: ${audioData.url}');
      }

      final String jwt = json.decode(responseJWT.body)['response']['jwt'];

      // fetch mp3 file
      final responseMP3 = await http.get(Uri.parse(
          'https://api.rtvslo.si/ava/getMedia/${audioData.id}?client_id=${secret.clientId}&jwt=$jwt'));

      if (responseMP3.statusCode != 200) {
        throw Exception(
            'Failed to load website for title: ${audioData.title}, link: ${audioData.url}');
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
            album: audioData.showName,
            title: audioData.title,
            displayDescription: audioData.titleDescription,
            artUri: Uri.parse(audioData.imageUrl),
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
            album: audioData.showName,
            title: audioData.title,
            displayDescription: audioData.titleDescription,
            artUri: Uri.parse(audioData.imageUrl),
          ),
        );
      }

      return audio;
    } catch (e) {
      throw Exception('$e');
    }
  }
}
