import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pediatko/auth/secrets.dart' as secret;

Future<Preslikave> preslikava = getTransformation();

class Preslikave {
  final List tokens;
  final String infoPageUrl;

  Preslikave({required this.tokens, required this.infoPageUrl});

  factory Preslikave.fromJson(response) {
    return Preslikave(
        tokens: response['tokens'],
        infoPageUrl: response['settings']['info_page_url']);
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
