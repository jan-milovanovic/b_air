import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<AudioData> getZaLahkoNoc() async {
  final response = await http.get(Uri.parse(
      'https://api.rtvslo.si/ava/getSearch2?client_id=7c7f07d6258d2c66723451428bec4b78&pageNumber=0&pageSize=12&sort=date&order=desc&showId=54'));

  if (response.statusCode == 200) {
    return AudioData.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load \'lahko noc\' audio data');
  }
}

class AudioData {
  final String imageUrl;
  final String title;
  final String url;

  const AudioData(
      {required this.imageUrl, required this.title, required this.url});

  factory AudioData.fromJson(Map<String, dynamic> json) {
    return AudioData(
      imageUrl: json['response']['recordings'][0]['podcast_thumbnail']['md'],
      title: json['response']['recordings'][0]['title'],
      url: json['response']['recordings'][0]['link'],
    );
  }
}
