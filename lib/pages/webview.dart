import 'package:flutter/material.dart';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

class Webview extends StatefulWidget {
  const Webview({Key? key}) : super(key: key);

  @override
  WebviewState createState() => WebviewState();
}

class WebviewState extends State<Webview> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return const WebView(
      initialUrl: 'https://ars.rtvslo.si/b-air/',
    );
  }
}
