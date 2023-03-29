import 'package:flutter/material.dart';
import 'package:pediatko/modals/show.dart';
import 'package:pediatko/services/preslikava.dart';
import 'package:pediatko/services/radiodata.dart';

class DataProvider extends ChangeNotifier {
  DataProvider(Preslikava preslikava) {
    _preslikava = preslikava;
  }

  late Preslikava _preslikava;

  List get tokens => _preslikava.tokens;
  List<Show> get showList => _preslikava.showList;
  RadioData get radioData => _preslikava.radioData;
  String get infoPageUrl => _preslikava.infoPageUrl;

  set preslikava(Preslikava preslikava) => _preslikava = preslikava;

  static Future<DataProvider> create() async {
    Preslikava preslikava = await Preslikava.getTransformation();
    return DataProvider(preslikava);
  }
}
