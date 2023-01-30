import 'package:example/components/custom-button.dart';
import 'package:example/components/custom-card.dart';
import 'package:example/components/custom-input.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:oktoast/oktoast.dart';
import 'package:unipass_web_sdk/unipass_web_sdk.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:web3dart/crypto.dart';

import 'erc20.g.dart';

const polygonUsdcAddress = "0x87F0E95E11a49f56b329A1c143Fb22430C07332a";
const bscUsdcAddress = "0x64544969ed7EBf5f083679233325356EbE738930";
const rangersUsdcAddress = "0xd6ed1c13914ff1b08737b29de4039f542162cae1";
const polygonUsdcDecimal = 6;
const bscUsdcDecimal = 18;
const rangersUsdcDecimal = 6;
const Color _primaryTextColor = Color(0xFF1F202A);
const Color _mainBackground = Color(0XFFF5F5F5);

class TestPage extends StatefulWidget {
  const TestPage({super.key,
    required this.theme,
    required this.chainType,
    required this.domain,
    this.connectType,
    this.returnEmail = false,
    this.address,
    this.email,
    this.newborn,
    this.balance,
    this.usdcBalance,
  });

  final String domain;
  final UnipassTheme theme;
  final ChainType chainType;
  final ConnectType? connectType;
  final bool? returnEmail;
  final bool? newborn;
  final String? address;
  final String? email;
  final BigInt? balance;
  final BigInt? usdcBalance;


  @override
  _TestPage createState() => _TestPage();
}

class _TestPage extends State<TestPage> {
  String accountString = "";
  String signedMessage = "";
  String transactionHash = "";
  String erc20TransactionHash = "";
  String isValidSignature = "";

  BigInt balance = BigInt.zero;
  BigInt usdcBalance = BigInt.zero;

  String _messageController = "";
  String _sigController = "";
  String _verifyMessageController = "";
  String _transactionController = "";
  String _transactionErc20Controller = "";
  String? _addressController = "";
  String _toErc20Controller = "";

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
      ),
    );
    _addressController = widget.address;
    _toErc20Controller = "0x2B6c74b4e8631854051B1A821029005476C3AF06";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _mainBackground,
      appBar: AppBar(
        title: Text('demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 32.0,
        ),
        child: ListBody(
          children: [
            //
            const Text(
              'UniPass Demo (Polygon-mumbai)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _primaryTextColor,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 40.0),
            CustomCard(
                child: Column(
                  children: [
                    CustomButton(
                        onPressed: () {}, title: 'Continue with Google'),
                    const SizedBox(height: 20.0),
                    CustomInput(
                      title: 'Your address 2',
                      enabled: false,
                      controller: widget.address,
                    ),
                    const SizedBox(height: 20.0),
                    CustomInput(
                      title: 'Your email',
                      enabled: false,
                      controller: widget.email,
                    ),
                    const SizedBox(height: 20.0),
                    CustomInput(
                      title: 'New born',
                      enabled: false,
                      controller: widget.newborn.toString(),
                    ),
                    const SizedBox(height: 40.0),
                    CustomButton(
                        onPressed: () async {
                          await uniPassWeb.logout();
                          setState(() {
                            accountString = "";
                            signedMessage = "";
                            transactionHash = "";
                            erc20TransactionHash = "";
                            isValidSignature = "";
                            _messageController = "";
                            _sigController = "";
                            _verifyMessageController = "";
                            _transactionController = "";
                            _transactionErc20Controller = "";
                            _addressController = "";
                            // _toErc20Controller.text = "";
                            balance = BigInt.zero;
                            usdcBalance = BigInt.zero;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyApp()),
                          );
                        },
                        title: 'Disconnect'),
                  ],
                )),
            CustomCard(
                child: Column(
                  children: [
                    const Text(
                      'Send ETH',
                      style: TextStyle(
                          color: _primaryTextColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40.0),
                    CustomInput(
                      title: 'Your balance',
                      enabled: false,
                      controller: widget.balance.toString(),
                    ),
                    const SizedBox(height: 20.0),
                    CustomInput(
                      title: 'Transfer to',
                      controller: widget.address,
                    ),
                    const SizedBox(height: 20.0),
                    CustomInput(
                      title: 'Amount',
                    ),
                    const SizedBox(height: 40.0),
                    CustomButton(onPressed: () {}, title: 'Send'),
                  ],
                )),
            CustomCard(
                child: Column(
                  children: [
                    const Text(
                      'Send ERC20',
                      style: TextStyle(
                          color: _primaryTextColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40.0),
                    CustomInput(
                      title: 'Your balance',
                      enabled: false,
                      controller: widget.usdcBalance.toString(),
                    ),
                    const SizedBox(height: 20.0),
                    CustomInput(
                      title: 'Transfer to',
                      controller: widget.address,
                    ),
                    const SizedBox(height: 20.0),
                    CustomInput(
                      title: 'Amount',
                    ),
                    const SizedBox(height: 40.0),
                    CustomButton(onPressed: () {}, title: 'Send'),
                  ],
                )),
            CustomCard(
                child: Column(
                  children: [
                    const Text(
                      'Sign Message',
                      style: TextStyle(
                          color: _primaryTextColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40.0),
                    CustomInput(
                      title: 'Message',
                      controller: "Welcome to UniPass!",
                    ),
                    const SizedBox(height: 40.0),
                    CustomButton(onPressed: () {}, title: 'Sign Message'),
                  ],
                )),
            CustomCard(
                child: Column(
                  children: [
                    const Text(
                      'Sign Typed Data V4',
                      style: TextStyle(
                          color: _primaryTextColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40.0),
                    JsonView.string(
                      '{"AccountPending":"Wallet is recovering...","AccountStatus":"Wallet Status:","ActionNotCommitted":"There is a pending action, are you sure you want to exit?","Add":"Add guardians","AddGuardian":"Add Guardian Email","AddGuardianFailed":"Add Guardian Email Failed","AddSuccess":"Add success","AmountOutOfRange":"Your balance is insufficient, the transfer amount will be changed","ApprovalTo":"Approval to","BackToHome":"Return to homepage","Balance":"Balance","Cancel":"Cancel","CastingSuccess":"Verification successful!"}',
                      theme: const JsonViewTheme(
                        keyStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        doubleStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        intStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        stringStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        boolStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    CustomButton(onPressed: () {}, title: 'Sign Typed Data'),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void _showToast(String msg) {
    showToast(msg);
  }

  String _formatNativeTokenName(ChainType chainType) {
    if (chainType == ChainType.polygon) return "Matic";
    if (chainType == ChainType.bsc) return "BNB";
    if (chainType == ChainType.rangers) return "RPG";
    return "";
  }

  String _formatUsdcAddress(ChainType chainType) {
    if (chainType == ChainType.polygon) return polygonUsdcAddress;
    if (chainType == ChainType.bsc) return bscUsdcAddress;
    if (chainType == ChainType.rangers) return rangersUsdcAddress;
    return "";
  }

  int _formatUsdcDecimal(ChainType chainType) {
    if (chainType == ChainType.polygon) return polygonUsdcDecimal;
    if (chainType == ChainType.bsc) return bscUsdcDecimal;
    if (chainType == ChainType.rangers) return rangersUsdcDecimal;
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
