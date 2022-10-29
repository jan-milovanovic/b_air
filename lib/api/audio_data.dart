import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:pediatko/auth/client_id.dart' as secret;
import 'package:http/http.dart' as http;
import '../show.dart';

/// contains all necessary data needed to be displayed for a specific recording
/// important: audiodata MUST INCLUDE either image OR imageUrl
///
/// imageUrl is being used for 'radio' and 'recording_player' because:
/// just_audio requires an 'uri' which usually takes urls
///
/// image for everything else
class AudioData {
  final String title;
  final String titleDescription;
  final String showName;
  final String showDescription;
  final String url;
  final String? id;

  AudioData({
    required this.title,
    required this.titleDescription,
    required this.showName,
    required this.showDescription,
    required this.url,
    this.id,
  });

  factory AudioData.fromJson(Map<String, dynamic> json, int i, Show showData) {
    return AudioData(
      title: json['entry'][i]['title'],
      titleDescription: json['entry'][i]['summary'],
      showName: json['title'],
      showDescription: 'TODO: get show description',
      url: json['entry'][i]['extensions']['signer_api'],
      id: json['entry'][i]['id'],
    );
  }
}

Future<List<AudioData>> getTrack(context, Show showData) async {
  try {
    final response = await http
        .get(Uri.parse(
            'https://api.rtvslo.si/pipes/show/?client_id=${secret.clientId}&id=${showData.showId}&group=show&clip=show&shuffle=0&showAds=0&_=1666948097204'))
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final int recNumber = getNumberOfRecordings(jsonDecode(response.body));

      List<AudioData> audioData = [];

      for (int i = 0; i < recNumber; i++) {
        audioData
            .add(AudioData.fromJson(jsonDecode(response.body), i, showData));
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
  return res['entry'].length;
}
