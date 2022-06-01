import 'dart:async';
import 'dart:convert';

import 'package:pediatko/auth/secrets.dart' as secret;
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import './pages/recording_player.dart';

/// contains all necessary data needed to be displayed for a specific recording
class AudioData {
  final String imageUrl;
  final String title;
  final String titleDescription;
  final String showName;
  final String showDescription;
  final String url;
  final String? id;

  AudioData(
      {required this.imageUrl,
      required this.title,
      required this.titleDescription,
      required this.showName,
      required this.showDescription,
      required this.url,
      this.id});

  void playAudio(BuildContext context, Color color) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                RecordingPlayer(audioData: this, color: color)));
  }

  factory AudioData.fromJson(Map<String, dynamic> json, int i) {
    String imageUrl;

    if (json['response']['recordings'][i]['podcast_thumbnail'] != null) {
      imageUrl = json['response']['recordings'][i]['podcast_thumbnail']['md'];
    } else {
      imageUrl = json['response']['recordings'][i]['images']['wide1'];
    }

    return AudioData(
      imageUrl: imageUrl,
      title: json['response']['recordings'][i]['title'],
      titleDescription: json['response']['recordings'][i]['description'],
      showName: json['response']['recordings'][i]['showName'],
      showDescription: json['response']['recordings'][i]['showDescription'],
      url: json['response']['recordings'][i]['link'],
      id: json['response']['recordings'][i]['id'],
    );
  }
}

Future<List<AudioData>> getTrack(context, String showID) async {
  try {
    final response = await http
        .get(Uri.parse(
            'https://api.rtvslo.si/ava/getSearch2?client_id=${secret.storyClientId}&pageNumber=0&pageSize=12&sort=date&order=desc&showId=$showID'))
        .timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      final int recNumber = getNumberOfRecordings(jsonDecode(response.body));

      List<AudioData> audioData = [];

      for (int i = 0; i < recNumber; i++) {
        audioData.add(AudioData.fromJson(jsonDecode(response.body), i));
      }

      return audioData;
    } else {
      //noInternetConnectionDialog(context);
      throw Exception('Failed to load audio data (url not reachable)');
    }
  } on TimeoutException {
    //noInternetConnectionDialog(context);
    throw TimeoutException('Failed to load audio data');
  } catch (e) {
    //noInternetConnectionDialog(context);
    throw Exception('Failed to load audio data: $e');
  }
}

int getNumberOfRecordings(res) {
  return res['response']['recordings'].length;
}
