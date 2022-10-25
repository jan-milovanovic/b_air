import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pediatko/auth/client_id.dart' as secret;
import 'package:pediatko/dialog.dart';
import '../show.dart';
import 'radiodata.dart';

class Preslikave {
  final List tokens;
  final String infoPageUrl;
  final List<Show> showData;
  final RadioData radioData;

  Preslikave(
      {required this.tokens,
      required this.infoPageUrl,
      required this.showData,
      required this.radioData});

  factory Preslikave.fromJson(response) {
    List<Show> firstPage = [];

    for (var show in response['first_page']) {
      firstPage.add(Show(
          showId: show['showId'],
          title: show['title'],
          iconUrl: show['icon_url'],
          bgColor: show['bg_color'] ?? show['color']));
    }

    RadioData rData = RadioData(
      title: response['radio_live_page']['title'],
      subtitle: response['radio_live_page']['subtile'],
      iconUrl: response['radio_live_page']['icon_url'],
      stream: response['radio_live_page']['stream'],
    );

    return Preslikave(
      tokens: response['tokens'],
      infoPageUrl: response['settings']['info_page_url'],
      showData: firstPage,
      radioData: rData,
    );
  }
}

Future<Preslikave> getTransformation(context) async {
  try {
    final response = await http
        .get(Uri.parse(
            'https://api.rtvslo.si/preslikave/bair?client_id=${secret.clientId}&_=1654497862648'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Preslikave.fromJson(jsonDecode(response.body)['response']);
    }
    throw Exception(
        'failed to load transformation data. status code = ${response.statusCode}');
  } on TimeoutException {
    Future.delayed(
        const Duration(seconds: 0), noInternetConnectionDialog(context, 1));
    throw TimeoutException('transformation timed out');
  } catch (e) {
    Future.delayed(
        const Duration(seconds: 0), noInternetConnectionDialog(context, 1));
    throw Exception('failed to load transformation data: $e');
  }
}
