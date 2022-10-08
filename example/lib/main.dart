import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:unipass_web_sdk/unipass_web_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('native_webview example app'),
        ),
        body: const TestPage(),
      ),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPage();
}

class _TestPage extends State<TestPage> {
  String accountString = "";
  UniPassWeb uniPassWeb = UniPassWeb(UniPassOption());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text("Login"),
          subtitle: Text(accountString),
          onTap: () async {
            UpAccount upAccount = await uniPassWeb.login(context, "");
            setState(() {
              accountString = "address: ${upAccount.address} email: ${upAccount.email} newborn: ${upAccount.newborn}";
            });
          },
        ),
      ],
    );
  }
}
