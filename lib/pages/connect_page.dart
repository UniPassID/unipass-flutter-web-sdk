import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:unipass_web_sdk/utils/interface.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({
    Key? key,
    required this.connectFuture,
    required this.url,
    required this.appSetting,
    required this.returnEmail,
    required this.authorize,
  }) : super(key: key);

  final Completer<UpAccount> connectFuture;
  final String url;
  final AppSetting appSetting;
  final bool returnEmail;
  final bool authorize;

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
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
        title: const Text('connect', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
            widget.connectFuture.completeError("user reject operate");
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
              _addJavaScriptHandlers(controller);
            },
            onReceivedServerTrustAuthRequest: (controller, challenge) async {
              return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
            },
            onLoadError: (InAppWebViewController controller, Uri? url, int code, String message) {
              print("[load error] $message");
              print("[load error] $code");
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
      ),
    );
  }

  void _addJavaScriptHandlers(InAppWebViewController controller) {
    controller.addJavaScriptHandler(
      handlerName: "onConnectReady",
      callback: (args) {
        final connectValue = json.encode({
          "type": "UP_LOGIN",
          "appSetting": {
            "appName": widget.appSetting.appName,
            "appIcon": widget.appSetting.appIcon,
            "chain": widget.appSetting.chainType?.name,
            "theme": widget.appSetting.theme?.name,
          },
          "payload": {
            "returnEmail": widget.returnEmail,
            "authorize": widget.authorize,
          }
        });
        controller.evaluateJavascript(source: """
                window.onConnectPageReady($connectValue);
              """);
      },
    );
    controller.addJavaScriptHandler(
      handlerName: "onConnectResponse",
      callback: (args) {
        print("args $args");
        try {
          if (args[0] != null) {
            if (args[0]["type"] == "UP_RESPONSE") {
              final payload = json.decode(args[0]["payload"]);
              print(payload);
              if (payload["type"] == "DECLINE") {
                if (!widget.connectFuture.isCompleted) {
                  Navigator.pop(context);
                  widget.connectFuture.completeError("user reject connect");
                }
                return;
              }
              UpAccount upAccount = UpAccount(
                address: payload["data"]["address"],
                email: payload["data"]["email"] ?? "",
                newborn: payload["data"]["newborn"],
                message: payload["data"]["message"] ?? "",
                signature: payload["data"]["signature"] ?? "",
              );
              if (!widget.connectFuture.isCompleted) {
                Navigator.pop(context);
                widget.connectFuture.complete(upAccount);
              }
            }
          }
        } catch (error, s) {
          debugPrint("[unipass connect error] $error $s");
          if (!widget.connectFuture.isCompleted) {
            Navigator.pop(context);
            widget.connectFuture.completeError("connect failed");
          }
        }
      },
    );
  }
}
