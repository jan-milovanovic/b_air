import 'dart:async';
import 'dart:convert';

import 'package:pediatko/auth/secrets.dart' as secret;
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import './pages/recording_player.dart';

/// contains all necessary data needed to be displayed for a specific recording
/// important: audiodata MUST INCLUDE either image OR imageUrl
///
/// imageUrl is being used for 'radio' and 'recording_player' because:
/// just_audio requires an 'uri' which usually takes urls
///
/// image for everything else
class AudioData {
  final Image? image;
  final String? imageUrl;
  final String title;
  final String titleDescription;
  final String showName;
  final String showDescription;
  final String url;
  final String? id;

  AudioData(
      {required this.title,
      required this.titleDescription,
      required this.showName,
      required this.showDescription,
      required this.url,
      this.id,
      this.image,
      this.imageUrl});

  void playAudio(BuildContext context, Color color) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                RecordingPlayer(audioData: this, color: color)));
  }

  factory AudioData.fromJson(Map<String, dynamic> json, int i, Image image) {
    //String imageUrl;

    /**
     * @Deprecated
     * This will get removed in the future
    if (json['response']['recordings'][i]['podcast_thumbnail'] != null) {
      imageUrl = json['response']['recordings'][i]['podcast_thumbnail']['md'];
    } else {
      imageUrl = json['response']['recordings'][i]['images']['wide1'];
    }
    */

    return AudioData(
      image: image,
      title: json['response']['recordings'][i]['title'],
      titleDescription: json['response']['recordings'][i]['description'],
      showName: json['response']['recordings'][i]['showName'],
      showDescription: json['response']['recordings'][i]['showDescription'],
      url: json['response']['recordings'][i]['link'],
      id: json['response']['recordings'][i]['id'],
    );
  }
}

Future<List<AudioData>> getTrack(context, String showID, Image image) async {
  try {
    final response = await http
        .get(Uri.parse(
            'https://api.rtvslo.si/ava/getSearch2?client_id=${secret.storyClientId}&pageNumber=0&pageSize=12&sort=date&order=desc&showId=$showID'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final int recNumber = getNumberOfRecordings(jsonDecode(response.body));

      List<AudioData> audioData = [];

      for (int i = 0; i < recNumber; i++) {
        audioData.add(AudioData.fromJson(jsonDecode(response.body), i, image));
      }

      return audioData;
    } else {
      throw Exception('Failed to load audio data (url not reachable)');
    }
  } on TimeoutException {
    throw TimeoutException('Failed to load audio data');
  } catch (e) {
    throw Exception('Failed to load audio data: $e');
  }
}

int getNumberOfRecordings(res) {
  return res['response']['recordings'].length;
}
