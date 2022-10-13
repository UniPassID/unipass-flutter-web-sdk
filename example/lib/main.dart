import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:unipass_web_sdk/unipass_web_sdk.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:web3dart/crypto.dart';

import 'erc20.g.dart';

const usdcAddress = "0xd6Ed1C13914FF1b08737b29De4039F542162cAE1";
const usdcDecimal = 6;

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
    return OKToast(
      textStyle: const TextStyle(fontSize: 19.0, color: Colors.white),
      backgroundColor: Colors.grey,
      animationCurve: Curves.easeIn,
      animationDuration: const Duration(milliseconds: 300),
      duration: const Duration(seconds: 3),
      child: MaterialApp(
        builder: (context, child) => Scaffold(
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
  String signedMessage = "";
  String transactionHash = "";
  String erc20TransactionHash = "";
  String isValidSignature = "";

  UnipassTheme theme = UnipassTheme.light;
  ChainType chainType = ChainType.polygon;

  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _sigController = TextEditingController();
  final TextEditingController _verifyMessageController = TextEditingController();
  final TextEditingController _transactionController = TextEditingController();
  final TextEditingController _transactionErc20Controller = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _toErc20Controller = TextEditingController();

  UniPassWeb uniPassWeb = UniPassWeb(
    UniPassOption(
      domain: "d.wallet.unipass.vip",
      protocol: "https",
      appSetting: AppSetting(
        appName: "demo dapp",
        theme: UnipassTheme.light,
        chainType: ChainType.polygon,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    _toController.text = "0x2B6c74b4e8631854051B1A821029005476C3AF06";
    _toErc20Controller.text = "0x2B6c74b4e8631854051B1A821029005476C3AF06";
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 20),
        const Text(
          "Unipass flutter web sdk",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 20),
        const Divider(color: Colors.blueAccent, thickness: 3.0),
        const SizedBox(height: 10),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("light"),
                Radio<UnipassTheme>(
                  value: UnipassTheme.light,
                  groupValue: theme,
                  onChanged: (UnipassTheme? value) {
                    setState(() {
                      theme = value!;
                    });
                    uniPassWeb.updateConfig(theme: value);
                  },
                ),
                const Text("dark"),
                Radio<UnipassTheme>(
                  value: UnipassTheme.dark,
                  groupValue: theme,
                  onChanged: (UnipassTheme? value) {
                    setState(() {
                      theme = value!;
                    });
                    uniPassWeb.updateConfig(theme: value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("polygon"),
                Radio<ChainType>(
                  value: ChainType.polygon,
                  groupValue: chainType,
                  onChanged: (ChainType? value) {
                    setState(() {
                      chainType = value!;
                    });
                    uniPassWeb.updateConfig(chainType: value);
                  },
                ),
                const Text("bsc"),
                Radio<ChainType>(
                  value: ChainType.bsc,
                  groupValue: chainType,
                  onChanged: (ChainType? value) {
                    setState(() {
                      chainType = value!;
                    });
                    uniPassWeb.updateConfig(chainType: value);
                  },
                ),
                const Text("rangers"),
                Radio<ChainType>(
                  value: ChainType.rangers,
                  groupValue: chainType,
                  onChanged: (ChainType? value) {
                    setState(() {
                      chainType = value!;
                    });
                    uniPassWeb.updateConfig(chainType: value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () async {
                try {
                  UpAccount upAccount = await uniPassWeb.connect(context);
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
                  if (_messageController.text.isEmpty) {
                    _showToast("sign message is empty");
                    return;
                  }
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
                  if (_sigController.text.isEmpty || _verifyMessageController.text.isEmpty) {
                    _showToast("input is empty");
                    return;
                  }
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
              child: const Text("verify message"),
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
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                if (_transactionController.text.isEmpty || _toController.text.isEmpty) {
                  _showToast("input is empty");
                  return;
                }
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
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: TextFormField(
                controller: _transactionErc20Controller,
                decoration: const InputDecoration(
                  labelText: 'value',
                  border: OutlineInputBorder(),
                ),
                autofocus: false,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: _toErc20Controller,
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
                if (_transactionErc20Controller.text.isEmpty || _toErc20Controller.text.isEmpty) {
                  _showToast("input is empty");
                  return;
                }
                try {
                  final erc20TokenData = Erc20(
                    address: web3.EthereumAddress.fromHex(usdcAddress),
                    client: uniPassWeb.getProvider(),
                  ).self.function("transfer").encodeCall(
                    [
                      web3.EthereumAddress.fromHex(_toErc20Controller.text),
                      etherToWei(_transactionErc20Controller.text, decimal: usdcDecimal, toString: false),
                    ],
                  );

                  String txHash = await uniPassWeb.sendTransaction(
                    context,
                    TransactionMessage(
                      from: uniPassWeb.getAddress(),
                      to: usdcAddress,
                      value: "0x",
                      data: bytesToHex(erc20TokenData, include0x: true),
                    ),
                  );
                  setState(() {
                    erc20TransactionHash = txHash;
                  });
                } catch (err, s) {
                  print(err);
                  print(s);
                  setState(() {
                    erc20TransactionHash = err.toString();
                  });
                }
              },
              child: const Text("send USDC transaction"),
            ),
            Text(
              "txHash: $erc20TransactionHash",
              textAlign: TextAlign.center,
            ),
            OutlinedButton(
              onPressed: () async {
                try {
                  await Clipboard.setData(ClipboardData(text: erc20TransactionHash));
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
        const SizedBox(height: 50),
      ],
    );
  }

  void _showToast(String msg) {
    showToast(msg);
  }
}

dynamic etherToWei(String text, {int decimal = 18, bool toString = true}) {
  String text_ = double.parse(text).toString();
  String a = text_.split(".")[0] ?? "";
  String b = text_.split(".")[1] ?? "";
  int c = int.parse("$a$b");
  BigInt d = BigInt.from(c) * BigInt.from(10).pow(decimal - b.length);
  print("d.toString() ${d.toString()}");
  return toString ? d.toString() : d;
}
