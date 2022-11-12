import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:unipass_web_sdk/utils/interface.dart';
import 'package:unipass_web_sdk/utils/storage.dart' as storage;

class SendTransactionPage extends StatefulWidget {
  const SendTransactionPage({
    Key? key,
    required this.transactionFuture,
    required this.url,
    required this.transaction,
    required this.appSetting,
  }) : super(key: key);

  final Completer<String> transactionFuture;
  final String url;
  final TransactionMessage transaction;
  final AppSetting appSetting;

  @override
  State<SendTransactionPage> createState() => _SendTransactionPageState();
}

class _SendTransactionPageState extends State<SendTransactionPage> {
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
        title: const Text('send transaction', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
            widget.transactionFuture.completeError("user reject operate");
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
      handlerName: "onSendTransactionReady",
      callback: (args) {
        final connectValue = json.encode({
          "type": "UP_TRANSACTION",
          "appSetting": {
            "appName": widget.appSetting.appName,
            "appIcon": widget.appSetting.appIcon,
            "chain": widget.appSetting.chainType?.name,
            "theme": widget.appSetting.theme?.name,
          },
          "payload": {
            "from": widget.transaction.from,
            "to": widget.transaction.to,
            "value": widget.transaction.value,
            "data": widget.transaction.data,
          }
        });
        print("connectValue: $connectValue");
        controller.evaluateJavascript(source: "window.onSendTransactionReady($connectValue);");
      },
    );
    controller.addJavaScriptHandler(
      handlerName: "onUserInfoInvalid",
      callback: (args) {
        print("onUserInfoInvalid args $args");
        try {
          if (args[0] != null) {
            if (args[0]["type"] == "UP_RESPONSE") {
              final payload = json.decode(args[0]["payload"]);
              if (payload["data"] == "expired") {
                if (!widget.transactionFuture.isCompleted) {
                  Navigator.pop(context);
                  widget.transactionFuture.completeError("user info expired");
                  storage.Storage.removeUpAccount();
                }
                return;
              }
            }
          }
        } catch (error, s) {
          debugPrint("[onUserInfoInvalid error] $error $s");
        }
      },
    );
    controller.addJavaScriptHandler(
      handlerName: "onSendTransactionResponse",
      callback: (args) {
        print("onSendTransactionResponse args $args");
        try {
          if (args[0] != null) {
            if (args[0]["type"] == "UP_RESPONSE") {
              final payload = json.decode(args[0]["payload"]);
              if (payload["type"] == "DECLINE") {
                if (!widget.transactionFuture.isCompleted) {
                  Navigator.pop(context);
                  widget.transactionFuture.completeError("user reject send transaction");
                }
                return;
              }

              if (!widget.transactionFuture.isCompleted) {
                Navigator.pop(context);
                widget.transactionFuture.complete(payload["data"]);
              }
            }
          }
        } catch (error, s) {
          debugPrint("[unipass connect error] $error $s");
          if (!widget.transactionFuture.isCompleted) {
            Navigator.pop(context);
            widget.transactionFuture.completeError("send transaction failed");
          }
        }
      },
    );
  }
}
