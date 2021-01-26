import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  _MyWebviewPage createState() => _MyWebviewPage();
}

class _MyWebviewPage extends State<WebviewPage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  _MyWebviewPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '',
          ),
        ),
        body: WebView(
          initialUrl: "https://www.handong.edu",
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
    );
  }
}