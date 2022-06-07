import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pediatko/auth/secrets.dart' as secret;
import 'show.dart';

class Preslikave {
  final List tokens;
  final String infoPageUrl;
  final List<Show> showData;

  Preslikave(
      {required this.tokens,
      required this.infoPageUrl,
      required this.showData});

  factory Preslikave.fromJson(response) {
    List<Show> firstPage = [];

    for (var show in response['first_page']) {
      firstPage.add(Show(
          showId: show['showId'],
          title: show['title'],
          iconUrl: show['icon_url'],
          bgColor: show['bg_color'] ?? show['color']));
    }

    return Preslikave(
      tokens: response['tokens'],
      infoPageUrl: response['settings']['info_page_url'],
      showData: firstPage,
    );
  }
}

Future<Preslikave> getTransformation() async {
  try {
    final response = await http
        .get(Uri.parse(
            'https://api.rtvslo.si/preslikave/bair?client_id=${secret.storyClientId}&_=1654497862648'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Preslikave.fromJson(jsonDecode(response.body)['response']);
    }
    throw Exception(
        'failed to load transformation data. status code = ${response.statusCode}');
  } catch (e) {
    throw Exception('failed to load transformation data: $e');
  }
}
