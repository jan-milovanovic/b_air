import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pediatko/constants/constants.dart';
import 'package:pediatko/constants/custom_dialogs.dart';

class RadioData {
  final String? title;
  final String? subtitle;
  final String? iconUrl;
  final String? stream;

  RadioData({
    this.title,
    this.subtitle,
    this.iconUrl,
    this.stream,
  });

  factory RadioData.fromJson(response) {
    return RadioData(
      title: response['title'],
      subtitle: response['subtile'],
      iconUrl: response['icon_url'],
      stream: response['stream'],
    );
  }

  Future<String> fetchStreamData(context) async {
    try {
      final response = await http
          .get(Uri.parse(
              'https://api.rtvslo.si/ava/getLiveStream/ra.raz?client_id=$clientId'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch radio data: ${response.statusCode}');
      }

      // if we'll ever need an entire radiodata again from this link
      //return RadioData.fromJson(jsonDecode(response.body)['response']);
      final mediaData = jsonDecode(response.body)['response']['mediaFiles'][0];
      final streamUrl = mediaData['streamer'] + mediaData['file'];
      return streamUrl;
    } on TimeoutException {
      Future.delayed(const Duration(seconds: 0),
          CustomDialogs.noInternetConnectionDialog(context));
      throw Exception('Fetch radio data transformation timed out');
    } catch (e) {
      throw Exception('Failed to fetch radio data: $e');
    }
  }
}
