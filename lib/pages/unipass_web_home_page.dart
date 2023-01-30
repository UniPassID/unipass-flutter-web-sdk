import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:unipass_web_sdk/utils/interface.dart';

class UnipassWebHomePage extends StatefulWidget {
  const UnipassWebHomePage({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  State<UnipassWebHomePage> createState() => _UnipassWebHomePage();
}

class _UnipassWebHomePage extends State<UnipassWebHomePage> {
  final GlobalKey webViewKey = GlobalKey();
  double progress = 0;
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      applicationNameForUserAgent: "unipass_wallet_for_flutter",
      userAgent: 'random',
      javaScriptEnabled: true,
      useOnLoadResource: true,
      cacheEnabled: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('UniPass Wallet', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
              initialOptions: options,
              gestureRecognizers: Set()..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer())),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onReceivedServerTrustAuthRequest: (controller, challenge) async {
                return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
              },
              onConsoleMessage: (controller, consoleMessage) {
                print(consoleMessage);
              },
              onProgressChanged: (controller, progress) {
                print('WebView is loading (progress : $progress%)');
                setState(() {
                  this.progress = progress / 100;
                });
              },
              onLoadStart: (controller, url) {
                print('Page started loading: $url');
              },
              onLoadStop: (controller, url) async {
                print('Page finished loading: $url');
              },
            ),
            progress < 1.0 ? LinearProgressIndicator(value: progress) : const SizedBox(),
          ],
        ));
  }
}
