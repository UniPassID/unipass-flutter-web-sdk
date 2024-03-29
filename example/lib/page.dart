import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:unipass_web_sdk/unipass_web_sdk.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:web3dart/crypto.dart';

import 'erc20.g.dart';

const ethUsdcAddress = "0x365E05Fd986245d14c740c139DF8712AD8807874";
const polygonUsdcAddress = "0x87F0E95E11a49f56b329A1c143Fb22430C07332a";
const bscUsdcAddress = "0x64544969ed7EBf5f083679233325356EbE738930";
const rangersUsdcAddress = "0xd6ed1c13914ff1b08737b29de4039f542162cae1";
const arbitrumUsdcAddress = "0x8667Bfb67d4D9fd1e61168dc872e17f637964547";
const avalancheUsdcAddress = "0x5425890298aed601595a70AB815c96711a31Bc65";
const kccUsdcAddress = "0xd6c7e27a598714c2226404eb054e0c074c906fc9";
const platonUsdcAddress = "0xEd5e318045D33611E877C25F7aFE6e98e2c2933C";
const okcUsdcAddress = "0x6b2b3F5a58c4C258f63b948566581787E45D651E";

const ethUsdcDecimal = 6;
const polygonUsdcDecimal = 6;
const bscUsdcDecimal = 18;
const rangersUsdcDecimal = 6;
const arbitrumUsdcDecimal = 6;
const avalancheUsdcDecimal = 6;
const kccUsdcDecimal = 18;
const platonUsdcDecimal = 6;
const okcUsdcDecimal = 6;

class TestPage extends StatefulWidget {
  const TestPage(
      {super.key,
      required this.theme,
      required this.chainType,
      required this.domain,
      this.connectType,
      this.returnEmail = false});

  final String domain;
  final UnipassTheme theme;
  final ChainType chainType;
  final ConnectType? connectType;
  final bool? returnEmail;

  @override
  State<TestPage> createState() => _TestPage();
}

class _TestPage extends State<TestPage> {
  String accountString = "";
  String signedMessage = "";
  String transactionHash = "";
  String erc20TransactionHash = "";
  String isValidSignature = "";

  BigInt balance = BigInt.zero;
  BigInt usdcBalance = BigInt.zero;

  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _sigController = TextEditingController();
  final TextEditingController _verifyMessageController = TextEditingController();
  final TextEditingController _transactionController = TextEditingController();
  final TextEditingController _transactionErc20Controller = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _toErc20Controller = TextEditingController();

  late UniPassWeb uniPassWeb;

  @override
  void initState() {
    super.initState();
    print('current domain: ${widget.domain}');
    uniPassWeb = UniPassWeb(
      UniPassOption(
        domain: widget.domain,
        protocol: "https",
        appSetting: AppSetting(
          appName: "demo dapp",
          theme: widget.theme,
          chainType: widget.chainType,
        ),
        returnEmail: widget.returnEmail,
        connectType: widget.connectType,
        authorize: true,
      ),
    );
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
            OutlinedButton(
              onPressed: () async {
                try {
                  UpAccount upAccount = await uniPassWeb.connect(context);
                  setState(() {
                    accountString = "address: ${upAccount.address} \n email: ${upAccount.email} \n newborn: ${upAccount.newborn} \n message: ${upAccount.message} signature: ${upAccount.signature}";
                  });
                  web3.Web3Client client = uniPassWeb.getProvider();
                  web3.EthereumAddress address = web3.EthereumAddress.fromHex(uniPassWeb.getAddress());
                  print("address.toString()");
                  print(address.toString().toLowerCase());
                  print(web3.EthereumAddress.fromHex(address.toString().toLowerCase()));
                  web3.EtherAmount balance_ =
                      await client.getBalance(web3.EthereumAddress.fromHex(address.toString().toLowerCase()));
                  print('balance_');
                  Erc20 contract =
                      Erc20(address: web3.EthereumAddress.fromHex(_formatUsdcAddress(widget.chainType).toLowerCase()), client: client);

                  print('balance_2');

                  BigInt usdcBalance_ = await contract.balanceOf(web3.EthereumAddress.fromHex(address.toString().toLowerCase()));

                  print("${widget.chainType.name} balance: ${balance_.getInWei.toString()}");
                  print("usdcBalance: ${usdcBalance_.toString()}");
                  setState(() {
                    balance = balance_.getInWei;
                    usdcBalance = usdcBalance_;
                  });
                } catch (err, s) {
                  print(s);
                  setState(() {
                    accountString = err.toString();
                  });
                }
              },
              child: const Text("connect"),
            ),
            Text(
              "[account] \n $accountString",
              textAlign: TextAlign.center,
            ),
            OutlinedButton(
              onPressed: () async {
                try {
                  await Clipboard.setData(ClipboardData(text: accountString));
                } catch (err) {}
              },
              child: const Text("copy account"),
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
                } catch (err, s) {
                  print(s);
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
            Text("${_formatNativeTokenName(widget.chainType)} balance: ${(balance / BigInt.from(10).pow(18)).toString()}"),
            const SizedBox(height: 20),
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
                if (balance == BigInt.zero) {
                  _showToast("balance is zero");
                  return;
                }
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
                      data: "0x",
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
        const SizedBox(height: 30),
        Column(
          children: [
            Text("USDC balance: ${(usdcBalance / BigInt.from(10).pow(widget.chainType == ChainType.bsc ? 18 : 6)).toString()}"),
            const SizedBox(height: 20),
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
                if (usdcBalance == BigInt.zero) {
                  _showToast("usdc balance is zero");
                  return;
                }
                if (_transactionErc20Controller.text.isEmpty || _toErc20Controller.text.isEmpty) {
                  _showToast("input is empty");
                  return;
                }
                try {
                  final erc20TokenData = Erc20(
                    address: web3.EthereumAddress.fromHex(_formatUsdcAddress(widget.chainType)),
                    client: uniPassWeb.getProvider(),
                  ).self.function("transfer").encodeCall(
                    [
                      web3.EthereumAddress.fromHex(_toErc20Controller.text),
                      etherToWei(_transactionErc20Controller.text,
                          decimal: _formatUsdcDecimal(widget.chainType), toString: false),
                    ],
                  );

                  String txHash = await uniPassWeb.sendTransaction(
                    context,
                    TransactionMessage(
                      from: uniPassWeb.getAddress(),
                      to: _formatUsdcAddress(widget.chainType),
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
                erc20TransactionHash = "";
                isValidSignature = "";
                _messageController.text = "";
                _sigController.text = "";
                _verifyMessageController.text = "";
                _transactionController.text = "";
                _transactionErc20Controller.text = "";
                // _toController.text = "";
                // _toErc20Controller.text = "";
                balance = BigInt.zero;
                usdcBalance = BigInt.zero;
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

  String _formatNativeTokenName(ChainType chainType) {
    if (chainType == ChainType.eth) return "ETH";
    if (chainType == ChainType.polygon) return "Matic";
    if (chainType == ChainType.bsc) return "BNB";
    if (chainType == ChainType.rangers) return "RPG";
    if (chainType == ChainType.arbitrum) return "ETH";
    if (chainType == ChainType.avalanche) return "AVAX";
    if (chainType == ChainType.kcc) return "KCS";
    if (chainType == ChainType.platon) return "LAT";
    if (chainType == ChainType.okc) return "OKT";
    return "";
  }

  String _formatUsdcAddress(ChainType chainType) {
    if (chainType == ChainType.eth) return ethUsdcAddress;
    if (chainType == ChainType.polygon) return polygonUsdcAddress;
    if (chainType == ChainType.bsc) return bscUsdcAddress;
    if (chainType == ChainType.rangers) return rangersUsdcAddress;
    if (chainType == ChainType.arbitrum) return arbitrumUsdcAddress;
    if (chainType == ChainType.avalanche) return avalancheUsdcAddress;
    if (chainType == ChainType.kcc) return kccUsdcAddress;
    if (chainType == ChainType.platon) return platonUsdcAddress;
    if (chainType == ChainType.okc) return okcUsdcAddress;
    return "";
  }

  int _formatUsdcDecimal(ChainType chainType) {
    if (chainType == ChainType.eth) return ethUsdcDecimal;
    if (chainType == ChainType.polygon) return polygonUsdcDecimal;
    if (chainType == ChainType.bsc) return bscUsdcDecimal;
    if (chainType == ChainType.rangers) return rangersUsdcDecimal;
    if (chainType == ChainType.arbitrum) return arbitrumUsdcDecimal;
    if (chainType == ChainType.avalanche) return avalancheUsdcDecimal;
    if (chainType == ChainType.kcc) return kccUsdcDecimal;
    if (chainType == ChainType.platon) return platonUsdcDecimal;
    if (chainType == ChainType.okc) return okcUsdcDecimal;
    return 18;
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
