import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class Webview extends StatefulWidget {
  const Webview({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  WebviewState createState() => WebviewState();
}

class WebviewState extends State<Webview> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    const PlatformWebViewControllerCreationParams params =
        PlatformWebViewControllerCreationParams();

    _controller = WebViewController.fromPlatformCreationParams(params);

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
