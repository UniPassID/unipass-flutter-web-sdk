import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: const Text('unipass webview sdk demo'),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: child,
        ),
      ),
      home: const TestPage(),
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
  String signedMessage = "";
  String transactionHash = "";
  String isValidSignature = "";

  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _sigController = TextEditingController();
  final TextEditingController _verifyMessageController = TextEditingController();
  final TextEditingController _transactionController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  UniPassWeb uniPassWeb = UniPassWeb(
    UniPassOption(
      domain: "192.168.2.12:1900",
      protocol: "https",
      appSetting: AppSetting(
        appName: "demo dapp",
        theme: UnipassTheme.dark,
        chainType: ChainType.polygon,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    _toController.text = "0x2B6c74b4e8631854051B1A821029005476C3AF06";
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Divider(color: Colors.blueAccent, thickness: 3.0),
        const SizedBox(height: 10),
        Column(
          children: [
            OutlinedButton(
              onPressed: () async {
                try {
                  UpAccount upAccount = await uniPassWeb.connect(context, "");
                  setState(() {
                    accountString = "address: ${upAccount.address} \n email: ${upAccount.email} \n newborn: ${upAccount.newborn}";
                  });
                } catch (err) {
                  setState(() {
                    accountString = "user reject connect";
                  });
                }
              },
              child: const Text("connect"),
            ),
            Text(
              accountString,
              textAlign: TextAlign.center,
            )
          ],
        ),
        const Divider(color: Colors.blueAccent, thickness: 3.0),
        const SizedBox(height: 30),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'message',
                  border: OutlineInputBorder(),
                ),
                autofocus: false,
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () async {
                try {
                  if (_messageController.text.isEmpty) return;
                  String signedMessage_ = await uniPassWeb.signMessage(context, _messageController.text);
                  setState(() {
                    signedMessage = signedMessage_;
                  });
                } catch (err) {
                  setState(() {
                    signedMessage = err.toString();
                  });
                }
              },
              child: const Text("sign message"),
            ),
            Text(
              "sig: $signedMessage",
              textAlign: TextAlign.center,
            ),
            OutlinedButton(
              onPressed: () async {
                try {
                  await Clipboard.setData(ClipboardData(text: signedMessage));
                } catch (err) {}
              },
              child: const Text("copy sig"),
            ),
          ],
        ),
        const Divider(color: Colors.blueAccent, thickness: 3.0),
        const SizedBox(height: 30),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: TextFormField(
                controller: _sigController,
                decoration: const InputDecoration(
                  labelText: 'sig',
                  border: OutlineInputBorder(),
                ),
                autofocus: false,
                minLines: 4,
                maxLines: 10,
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: TextFormField(
                controller: _verifyMessageController,
                decoration: const InputDecoration(
                  labelText: 'message',
                  border: OutlineInputBorder(),
                ),
                autofocus: false,
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () async {
                try {
                  if (_sigController.text.isEmpty || _verifyMessageController.text.isEmpty) return;
                  bool isValid = await uniPassWeb.isValidSignature(_verifyMessageController.text, _sigController.text);
                  setState(() {
                    isValidSignature = isValid.toString();
                  });
                } catch (err) {
                  setState(() {
                    isValidSignature = err.toString();
                  });
                }
              },
              child: const Text("sign message"),
            ),
            Text(
              "isValidSignature: $isValidSignature",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const Divider(color: Colors.blueAccent, thickness: 3.0),
        const SizedBox(height: 30),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: TextFormField(
                controller: _transactionController,
                decoration: const InputDecoration(
                  labelText: 'value',
                  border: OutlineInputBorder(),
                ),
                autofocus: false,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: _toController,
                decoration: const InputDecoration(
                  labelText: 'to',
                  border: OutlineInputBorder(),
                ),
                autofocus: false,
                keyboardType: TextInputType.text,
              ),
            ),
            OutlinedButton(
              onPressed: () async {
                if (_transactionController.text.isEmpty || _toController.text.isEmpty) return;
                try {
                  String txHash = await uniPassWeb.sendTransaction(
                    context,
                    TransactionMessage(
                      from: uniPassWeb.getAddress(),
                      to: _toController.text,
                      value: etherToWei(_transactionController.text, decimal: 18),
                      data: "0x00",
                    ),
                  );
                  setState(() {
                    transactionHash = txHash;
                  });
                } catch (err) {
                  setState(() {
                    transactionHash = err.toString();
                  });
                }
              },
              child: const Text("send transaction"),
            ),
            Text(
              "txHash: $transactionHash",
              textAlign: TextAlign.center,
            ),
            OutlinedButton(
              onPressed: () async {
                try {
                  await Clipboard.setData(ClipboardData(text: transactionHash));
                } catch (err) {}
              },
              child: const Text("copy hash"),
            ),
          ],
        ),
        const Divider(color: Colors.blueAccent, thickness: 3.0),
        const SizedBox(height: 30),
        Align(
          child: ElevatedButton.icon(
            label: const Text("Logout"),
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await uniPassWeb.logout();
              setState(() {
                accountString = "";
                signedMessage = "";
                transactionHash = "";
                isValidSignature = "";
                _messageController.text = "";
                _sigController.text = "";
                _verifyMessageController.text = "";
                _transactionController.text = "";
                // _toController.text = "";
              });
            },
          ),
        ),
      ],
    );
  }
}

String etherToWei(String text, {int decimal = 18}) {
  String text_ = double.parse(text).toString();
  String a = text_.split(".")[0] ?? "";
  String b = text_.split(".")[1] ?? "";
  int c = int.parse("$a$b");
  BigInt d = BigInt.from(c) * BigInt.from(10).pow(decimal - b.length);
  return d.toString();
}
