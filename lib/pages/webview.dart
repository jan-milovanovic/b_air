import 'package:flutter/material.dart';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

class Webview extends StatefulWidget {
  const Webview({Key? key, required this.url}) : super(key: key);

  final String url;

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
    return Expanded(
      child: Container(
        color: Colors.white,
        child: WebView(
          initialUrl: widget.url,
          //backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
