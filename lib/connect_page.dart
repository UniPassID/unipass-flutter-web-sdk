import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:unipass_web_sdk/utils/interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String kTransparentBackgroundPage = '''
<!DOCTYPE html>
<html>

<head>
    <title>Transparent background test</title>
</head>
<style type="text/css">
    #container {
      width: 100%;
      padding-top: 200px;
    }
    
    button {
      height: 120px;
      width: 100%;
      font-size: 32px;
      margin-bottom: 20px;
    }
</style>

<body>
<div id="container">
    <button id="connect">connect</button>
    <button id="transaction">send transaction</button>
    <button id="message">sign message</button>
    <div id="receive" style="color: red"></div>
</div>
</body>
<script>
    window.onload = () => {
        var connect = document.getElementById("connect");
        var transaction = document.getElementById("transaction");
        var message = document.getElementById("message");
        var account = {
            address: "123454050505",
            email: "lx1234@gmail.com",
            newborn: false,
        };
        connect.addEventListener('click', () => {
            window.UnipassPoster.postMessage(JSON.stringify(account));
        });
        transaction.addEventListener('click', () => {
            window.UnipassPoster.postMessage("transaction result");
        });
        message.addEventListener('click', () => {
            window.UnipassPoster.postMessage("message result");
        });
    };
    
    function receiveMessage(data) {
      var receive = document.getElementById("receive");
      receive.innerHTML = data;
    }
    
    window.receiveMessage = receiveMessage;
</script>

</html>
''';

class ConnectPage extends StatefulWidget {
  const ConnectPage({Key? key, this.connectFuture}) : super(key: key);

  final Completer<UpAccount>? connectFuture;

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
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
        actions: const <Widget>[
          // NavigationControls(_controller.future),
        ],
      ),
      body: WebView(
        initialUrl: 'https://demo-test.wallet.unipass.vip/',
        // initialUrl: 'https://flutter.dev',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) async {
          _controller.complete(webViewController);
          // final c = await _controller.future;
          // await c.loadHtmlString(kTransparentBackgroundPage);
        },
        onWebResourceError: (WebResourceError error) {
          print(error.description);
        },
        onProgress: (int progress) {
          print('WebView is loading (progress : $progress%)');
        },
        javascriptChannels: <JavascriptChannel>{
          _toasterJavascriptChannel(context),
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) async {
          print('Page finished loading: $url');
          (await _controller.future).runJavascript("window.receiveMessage('2312312')");
        },
        gestureNavigationEnabled: false,
        backgroundColor: Colors.white,
        // userAgent: "unipass - ua",
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'UnipassPoster',
      onMessageReceived: (JavascriptMessage javascriptMessage) {
        try {
          final account = json.decode(javascriptMessage.message);
          UpAccount upAccount = UpAccount(address: account["address"], email: account["email"]);
          Navigator.pop(context);
          widget.connectFuture?.complete(upAccount);
        } catch (error) {
          debugPrint("[unipass connect error] $error");
          Navigator.pop(context);
          widget.connectFuture?.completeError("connect failed");
        }
      },
    );
  }
}
