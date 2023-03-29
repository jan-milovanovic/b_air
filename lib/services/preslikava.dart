import 'dart:async';
import 'dart:convert';

import 'package:flutter/animation.dart';
import 'package:http/http.dart' as http;
import 'package:pediatko/constants/constants.dart';
import '../modals/show.dart';
import 'radiodata.dart';

class Preslikava {
  final List tokens;
  final String infoPageUrl;
  final List<Show> showList;
  final RadioData radioData;

  Preslikava({
    required this.tokens,
    required this.infoPageUrl,
    required this.showList,
    required this.radioData,
  });

  factory Preslikava.fromJson(response) {
    List<Show> firstPage = [];

    for (var show in response['first_page']) {
      firstPage.add(
        Show(
          showId: show['showId'],
          title: show['title'],
          description: show['description'],
          iconUrl: show['icon_url'],
          bgColor: Color(
            int.parse(
                (show['bg_color'] ?? show['color']).replaceFirst('#', 'ff'),
                radix: 16),
          ),
        ),
      );
    }

    RadioData rData = RadioData(
      title: response['radio_live_page']['title'],
      subtitle: response['radio_live_page']['subtile'],
      iconUrl: response['radio_live_page']['icon_url'],
      stream: response['radio_live_page']['stream'],
    );

    return Preslikava(
      tokens: response['tokens'],
      infoPageUrl: response['settings']['info_page_url'],
      showList: firstPage,
      radioData: rData,
    );
  }

  static Future<Preslikava> getTransformation() async {
    try {
      final response = await http
          .get(Uri.parse(
              'https://api.rtvslo.si/preslikave/bair?client_id=$clientId'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Preslikava.fromJson(jsonDecode(response.body)['response']);
      }
      throw Exception('failed to load transformation data. '
          'status code = ${response.statusCode}');
    } on TimeoutException {
      throw TimeoutException('transformation timed out');
    } catch (e) {
      throw Exception('failed to load transformation data: $e');
    }
  }
}


/*
Future<Preslikave> getTransformation(context) async {
  try {
    final response = await http
        .get(Uri.parse(
            'https://api.dev.rtvslo.si/preslikave/bair?client_id=${secret.clientId}&_=1654497862648'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Preslikave.fromJson(jsonDecode(response.body)['response']);
    }
    throw Exception(
        'failed to load transformation data. status code = ${response.statusCode}');
  } on TimeoutException {
    Future.delayed(const Duration(seconds: 0),
        CustomDialogs.noInternetConnectionDialog(context, 1));
    throw TimeoutException('transformation timed out');
  } catch (e) {
    Future.delayed(const Duration(seconds: 0),
        CustomDialogs.noInternetConnectionDialog(context, 1));
    throw Exception('failed to load transformation data: $e');
  }
}
*/
