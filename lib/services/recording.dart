import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pediatko/constants/constants.dart';
import '../modals/show.dart';

/// contains all necessary data needed to be displayed for a specific recording
/// important: audiodata MUST INCLUDE either image OR imageUrl
///
/// imageUrl is being used for 'radio' and 'recording_player' because:
/// just_audio requires an 'uri' which usually takes urls
///
/// image for everything else
class Recording {
  final String title;
  final String titleDescription;
  final String showName;
  final String showDescription;
  final String url;
  final String? id;

  Recording({
    required this.title,
    required this.titleDescription,
    required this.showName,
    required this.showDescription,
    required this.url,
    this.id,
  });

  factory Recording.fromJson(Map<String, dynamic> json) {
    return Recording(
      title: json['title'],
      titleDescription: json['summary'],
      showName: json['media_meta']['showName'],
      showDescription: 'TODO: get show description',
      url: json['extensions']['signer_api'],
      id: json['id'],
    );
  }
}

Future<List<Recording>> getTrack(context, Show showData) async {
  try {
    final response = await http
        .get(Uri.parse('https://api.rtvslo.si/pipes/show/?client_id=$clientId'
            '&id=${showData.showId}'
            '&group=show'
            '&clip=show'
            '&shuffle=0'
            '&showAds=0'))
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final List recordingList = jsonDecode(response.body)['response']['entry'];

      List<Recording> audioData = [];

      for (var recording in recordingList) {
        Recording rec = Recording.fromJson(recording);
        audioData.add(rec);
      }

      return audioData;
    }
    throw Exception('Failed to load audio data (url not reachable)');
  } on TimeoutException {
    throw TimeoutException('Failed to load audio data');
  } catch (e) {
    throw Exception('Failed to load audio data: $e');
  }
}
