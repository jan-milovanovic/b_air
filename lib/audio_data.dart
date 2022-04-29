import 'dart:convert';

import 'package:pediatko/auth/secrets.dart' as secret;
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import './pages/radio.dart';

Future<List<AudioData>> getTrack(String showID) async {
  final response = await http.get(Uri.parse(
      'https://api.rtvslo.si/ava/getSearch2?client_id=${secret.storyClientId}&pageNumber=0&pageSize=12&sort=date&order=desc&showId=$showID'));

  if (response.statusCode == 200) {
    final int recNumber = getNumberOfRecordings(jsonDecode(response.body));

    /// can't add if audioData is potentially null..?
    List<AudioData> audioData = [
      AudioData.fromJson(jsonDecode(response.body), 0)
    ];

    for (int i = 1; i < recNumber; i++) {
      audioData.add(AudioData.fromJson(jsonDecode(response.body), i));
    }

    return audioData;
  } else {
    throw Exception('Failed to load \'lahko noc\' audio data');
  }
}

int getNumberOfRecordings(res) {
  return res['response']['recordings'].length;
}

class AudioData {
  final String imageUrl;
  final String title;
  final String showName;
  final String showDescription;
  final String url;
  final String? id;

  const AudioData(
      {required this.imageUrl,
      required this.title,
      required this.showName,
      required this.showDescription,
      required this.url,
      this.id});

  void playAudio(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => RadioPlayer(audioData: this)));
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
      showName: json['response']['recordings'][i]['showName'],
      showDescription: json['response']['recordings'][i]['showDescription'],
      url: json['response']['recordings'][i]['link'],
      id: json['response']['recordings'][i]['id'],
    );
  }
}
