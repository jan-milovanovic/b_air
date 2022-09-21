import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:pediatko/auth/client_id.dart' as secret;
import 'package:http/http.dart' as http;
import 'show.dart';

/// contains all necessary data needed to be displayed for a specific recording
/// important: audiodata MUST INCLUDE either image OR imageUrl
///
/// imageUrl is being used for 'radio' and 'recording_player' because:
/// just_audio requires an 'uri' which usually takes urls
///
/// image for everything else
class AudioData {
  final String title;
  final String imageUrl;
  final String titleDescription;
  final String showName;
  final String showDescription;
  final String url;
  final Color bgColor;
  final String? id;

  AudioData({
    required this.title,
    required this.imageUrl,
    required this.titleDescription,
    required this.showName,
    required this.showDescription,
    required this.url,
    required this.bgColor,
    this.id,
  });

  factory AudioData.fromJson(
      Map<String, dynamic> json, int i, int recNumber, Show showData) {
    return AudioData(
        imageUrl: showData.iconUrl,
        title: json['response']['recordings'][i]['title'],
        titleDescription: json['response']['recordings'][i]['description'],
        showName: json['response']['recordings'][i]['showName'],
        showDescription: json['response']['recordings'][i]['showDescription'],
        url: json['response']['recordings'][i]['link'],
        id: json['response']['recordings'][i]['id'],
        bgColor: Color(
            int.parse(showData.bgColor.replaceFirst('#', 'ff'), radix: 16)));
  }
}

Future<List<AudioData>> getTrack(context, Show showData) async {
  try {
    final response = await http
        .get(Uri.parse(
            'https://api.rtvslo.si/ava/getSearch2?client_id=${secret.clientId}&pageNumber=0&pageSize=12&sort=date&order=desc&showId=${showData.showId}'))
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final int recNumber = getNumberOfRecordings(jsonDecode(response.body));

      List<AudioData> audioData = [];

      for (int i = 0; i < recNumber; i++) {
        audioData.add(AudioData.fromJson(
            jsonDecode(response.body), i, recNumber - 1, showData));
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
