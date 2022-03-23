import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<AudioData>> getZaLahkoNoc() async {
  final response = await http.get(Uri.parse(
      'https://api.rtvslo.si/ava/getSearch2?client_id=7c7f07d6258d2c66723451428bec4b78&pageNumber=0&pageSize=12&sort=date&order=desc&showId=54'));

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
  final String url;

  const AudioData(
      {required this.imageUrl, required this.title, required this.url});

  factory AudioData.fromJson(Map<String, dynamic> json, int i) {
    return AudioData(
      imageUrl: json['response']['recordings'][i]['podcast_thumbnail']['md'],
      title: json['response']['recordings'][i]['title'],
      url: json['response']['recordings'][i]['link'],
    );
  }
}
