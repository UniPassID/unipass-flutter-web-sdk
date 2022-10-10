import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:unipass_web_sdk/utils/interface.dart';

class SignMessagePage extends StatefulWidget {
  const SignMessagePage({
    Key? key,
    required this.signFuture,
    required this.url,
    required this.from,
    required this.message,
    required this.appSetting,
  }) : super(key: key);

  final Completer<String> signFuture;
  final String url;
  final String from;
  final String message;
  final AppSetting appSetting;

  @override
  State<SignMessagePage> createState() => _SignMessagePageState();
}

class _SignMessagePageState extends State<SignMessagePage> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      applicationNameForUserAgent: "unipass_wallet_for_flutter",
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
        title: const Text('Flutter WebView example'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
            widget.signFuture.completeError("user reject operate");
          },
        ),
      ),
      body: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
        initialOptions: options,
        gestureRecognizers: Set()..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer())),
        onWebViewCreated: (controller) {
          webViewController = controller;
          _addJavaScriptHandlers(controller);
        },
        onReceivedServerTrustAuthRequest: (controller, challenge) async {
          return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
        },
        onConsoleMessage: (controller, consoleMessage) {
          print(consoleMessage);
        },
        onProgressChanged: (controller, progress) {
          print('WebView is loading (progress : $progress%)');
        },
        onLoadStart: (controller, url) {
          print('Page started loading: $url');
        },
        onLoadStop: (controller, url) async {
          print('Page finished loading: $url');
        },
      ),
    );
  }

  void _addJavaScriptHandlers(InAppWebViewController controller) {
    controller.addJavaScriptHandler(
      handlerName: "onSignMessageReady",
      callback: (args) {
        final connectValue = json.encode({
          "type": "UP_SIGN_MESSAGE",
          "appSetting": {
            "appName": widget.appSetting.appName,
            "appIcon": widget.appSetting.appIcon,
            "chain": widget.appSetting.chainType.name,
            "theme": widget.appSetting.theme.name,
          },
          "payload": {
            "from": widget.from,
            "msg": Uint8List.fromList(widget.message.codeUnits),
          }
        });
        controller.evaluateJavascript(source: "window.onSignMessageReady($connectValue);");
      },
    );
    controller.addJavaScriptHandler(
      handlerName: "onSingMessageResponse",
      callback: (args) {
        print("onSingMessageResponse args $args");
        try {
          if (args[0] != null) {
            if (args[0]["type"] == "UP_RESPONSE") {
              final payload = json.decode(args[0]["payload"]);

              /// user reject
              if (payload["type"] == "DECLINE") {
                if (!widget.signFuture.isCompleted) {
                  Navigator.pop(context);
                  widget.signFuture.completeError("user reject sign message");
                }
                return;
              }

              /// font end user info not valid

              if (!widget.signFuture.isCompleted) {
                Navigator.pop(context);
                widget.signFuture.complete(payload["data"]);
              }
            }
          }
        } catch (error, s) {
          debugPrint("[unipass connect error] $error $s");
          if (!widget.signFuture.isCompleted) {
            Navigator.pop(context);
            widget.signFuture.completeError("sign message failed");
          }
        }
      },
    );
  }
}
