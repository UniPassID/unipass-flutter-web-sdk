import 'dart:convert';

import 'package:example/components/custom-button.dart';
import 'package:example/components/custom-card.dart';
import 'package:example/components/custom-input.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:oktoast/oktoast.dart';
import 'package:unipass_web_sdk/pages/unipass_web_page.dart';
import 'package:unipass_web_sdk/unipass_web_sdk.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:web3dart/crypto.dart';

import 'erc20.g.dart';

const polygonUsdcAddress = "0x87F0E95E11a49f56b329A1c143Fb22430C07332a";
const bscUsdcAddress = "0x64544969ed7EBf5f083679233325356EbE738930";
const rangersUsdcAddress = "0xd6Ed1C13914FF1b08737b29De4039F542162cAE1";
const ethUsdcAddress = "0x365E05Fd986245d14c740c139DF8712AD8807874";

const polygonUsdcDecimal = 6;
const bscUsdcDecimal = 18;
const rangersUsdcDecimal = 6;
const ethUsdcDecimal = 6;

const bscExplorerDict = "https://testnet.bscscan.com";
const rangersExplorerDict = "https://robin-rangersscan.rangersprotocol.com";
const ethExplorerDict = "https://goerli.etherscan.io";
const polygonExplorerDict = "https://mumbai.polygonscan.com";

const Color _primaryTextColor = Color(0xFF1F202A);
const Color _mainBackground = Color(0XFFF5F5F5);
const Color _transactionHashText = Color(0XFF4AAC4C);

class TestPage extends StatefulWidget {
  const TestPage({
    super.key,
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

  String _typeData =
      '{"types":{"EIP712Domain":[{"name":"name","type":"string"},{"name":"version","type":"string"},{"name":"chainId","type":"uint256"},{"name":"verifyingContract","type":"address"}],"Person":[{"name":"name","type":"string"},{"name":"wallet","type":"address"}],"Mail":[{"name":"from","type":"Person"},{"name":"to","type":"Person"},{"name":"contents","type":"string"}]},"primaryType":"Mail","domain":{"name":"Ether Mail","version":"1","chainId":1,"verifyingContract":"0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC"},"message":{"from":{"name":"Cow","wallet":"0xCD2a3d9F938E13CD947Ec05AbC7FE734Df8DD826"},"to":{"name":"Bob","wallet":"0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB"},"contents":"Hello, Bob!"}}';
  String _sendMessage =
      '{"from":{"name":"Cow","wallet":"0xCD2a3d9F938E13CD947Ec05AbC7FE734Df8DD826"},"to":{"name":"Bob","wallet":"0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB"},"contents":"Hello, Bob!"}';
  String _messageController = 'Welcome to UniPass!';
  String _verifyMessageController = "";
  String _transactionController = "";
  String _transactionErc20Controller = "";
  String _addressController = "";
  String _toErc20Controller = "";

  late UniPassWeb uniPassWeb;

  initPage() async {
    UpAccount upAccount = await uniPassWeb.connect(context);
  }

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
    initPage();
    _addressController = "0x61E428AaB6347765eFc549eae7bd740aA886A707";
    _toErc20Controller = "0x61E428AaB6347765eFc549eae7bd740aA886A707";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _mainBackground,
      appBar: AppBar(
        title: const Text('demo'),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UnipassWebPage(
                            url: 'https://testnet.wallet.unipass.id/',
                          ),
                        ),
                      );
                    },
                    title: 'Open Wallet'),
                const SizedBox(height: 20.0),
                CustomInput(
                  title: 'Your address',
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
                        _typeData = "";
                        _verifyMessageController = "";
                        _transactionController = "";
                        _transactionErc20Controller = "";
                        _addressController = "";
                        _toErc20Controller = "";
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                      );
                    },
                    title: 'Disconnect'),
              ],
            )),
            CustomCard(
                child: Column(
              children: [
                Text(
                  'Send ${_formatNativeTokenName(widget.chainType)}',
                  style: const TextStyle(
                      color: _primaryTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40.0),
                CustomInput(
                  title: 'Your balance',
                  enabled: false,
                  controller: '${(widget.balance! / BigInt.from(10).pow(18)).toString()} ${_formatNativeTokenName(widget.chainType)}',
                ),
                const SizedBox(height: 20.0),
                CustomInput(
                  title: 'Transfer to',
                  controller: _addressController,
                ),
                const SizedBox(height: 20.0),
                CustomInput(
                  title: 'Amount',
                  controller: _transactionController,
                  onChanged: (v) {
                    _transactionController = v;
                  },
                ),
                const SizedBox(height: 40.0),
                CustomButton(
                    onPressed: () async {
                      if (widget.balance == BigInt.zero) {
                        _showToast("balance is zero");
                        return;
                      }
                      if (_transactionController.isEmpty ||
                          _addressController.isEmpty) {
                        _showToast("input is empty");
                        return;
                      }
                      try {
                        String txHash = await uniPassWeb.sendTransaction(
                          context,
                          TransactionMessage(
                            from: uniPassWeb.getAddress(),
                            to: _addressController,
                            value:
                                etherToWei(_transactionController, decimal: 18),
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
                    title: 'Send'),
                transactionHash == '' ? Container() : Column(
                  children: [
                    const SizedBox(height: 40.0),
                    const Text(
                      'Transaction hash',
                      style: TextStyle(
                          color: _primaryTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UnipassWebPage(
                              url: '${_formatHashUrl(widget.chainType)}/tx/${transactionHash}',
                              title: '',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        transactionHash,
                        style: TextStyle(color: _transactionHashText,decoration: TextDecoration.underline,),
                      ),
                    ),
                  ],
                ),
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
                  controller: '${(widget.usdcBalance! / BigInt.from(10).pow(widget.chainType == ChainType.bsc ? 18 : 6)).toString()} USDC',
                ),
                const SizedBox(height: 20.0),
                CustomInput(
                  title: 'Transfer to',
                  controller: _toErc20Controller,
                ),
                const SizedBox(height: 20.0),
                CustomInput(
                  title: 'Amount',
                  controller: _transactionErc20Controller,
                  onChanged: (v) {
                    _transactionErc20Controller = v;
                  },
                ),
                const SizedBox(height: 40.0),
                CustomButton(
                    onPressed: () async {
                      if (widget.usdcBalance == BigInt.zero) {
                        _showToast("usdc balance is zero");
                        return;
                      }
                      if (_transactionErc20Controller.isEmpty ||
                          _toErc20Controller.isEmpty) {
                        _showToast("input is empty");
                        return;
                      }
                      try {
                        final erc20TokenData = Erc20(
                          address: web3.EthereumAddress.fromHex(
                              _formatUsdcAddress(widget.chainType)),
                          client: uniPassWeb.getProvider(),
                        ).self.function("transfer").encodeCall(
                          [
                            web3.EthereumAddress.fromHex(_toErc20Controller),
                            etherToWei(_transactionErc20Controller,
                                decimal: _formatUsdcDecimal(widget.chainType),
                                toString: false),
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
                      } catch (err) {
                        setState(() {
                          erc20TransactionHash = err.toString();
                        });
                      }
                    },
                    title: 'Send'),
                erc20TransactionHash == '' ? Container() : Column(
                  children: [
                    const SizedBox(height: 40.0),
                    const Text(
                      'Transaction hash',
                      style: TextStyle(
                          color: _primaryTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UnipassWebPage(
                              url: '${_formatHashUrl(widget.chainType)}/tx/${erc20TransactionHash}',
                              title: '',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        erc20TransactionHash,
                        style: TextStyle(color: _transactionHashText,decoration: TextDecoration.underline,),
                      ),
                    ),
                  ],
                ),
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
                    maxLines: 10,
                    controller: _messageController,
                    onChanged: (v) {
                      _messageController = v;
                    }),
                const SizedBox(height: 40.0),
                CustomButton(
                    onPressed: () async {
                      String signMessage = await uniPassWeb.signMessage(context, _messageController);
                      print('signMessage: ${signMessage}');
                      setState(() {
                        _verifyMessageController = signMessage;
                      });
                    },
                    title: 'Sign Message'),
                _verifyMessageController == '' ? Container() : Column(
                  children: [
                    const SizedBox(height: 40.0),
                    CustomInput(
                      title: 'Signature',
                      maxLines: 10,
                      controller: _verifyMessageController,
                      enabled: false,
                    ),
                    const SizedBox(height: 40.0),
                    CustomButton(
                        onPressed: () async {
                          try {
                            await Clipboard.setData(ClipboardData(text: _verifyMessageController));
                          } catch (err) {}
                        },
                        title: 'Verify'),
                  ],
                ),
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
                  _typeData,
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
                CustomButton(
                    onPressed: () async {
                      String signedMessage_ =
                          await uniPassWeb.signMessage(context, _sendMessage);
                      setState(() {
                        signedMessage = signedMessage_;
                      });
                    },
                    title: 'Sign Typed Data'),
                signedMessage == '' ? Container() : Column(
                  children: [
                    const SizedBox(height: 40.0),
                    CustomInput(
                      title: 'Signature',
                      maxLines: 10,
                      controller: signedMessage,
                      enabled: false,
                    ),
                    const SizedBox(height: 40.0),
                    CustomButton(
                        onPressed: () async {
                          try {
                            await Clipboard.setData(ClipboardData(text: signedMessage));
                          } catch (err) {}
                        },
                        title: 'Verify'),
                  ],
                ),
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
    if (chainType == ChainType.eth) return "ETH";
    return "";
  }

  String _formatUsdcAddress(ChainType chainType) {
    if (chainType == ChainType.polygon) return polygonUsdcAddress;
    if (chainType == ChainType.bsc) return bscUsdcAddress;
    if (chainType == ChainType.rangers) return rangersUsdcAddress;
    if (chainType == ChainType.eth) return ethUsdcAddress;
    return "";
  }

  String _formatHashUrl(ChainType chainType) {
    if (chainType == ChainType.polygon) return polygonExplorerDict;
    if (chainType == ChainType.bsc) return bscExplorerDict;
    if (chainType == ChainType.rangers) return rangersExplorerDict;
    if (chainType == ChainType.eth) return ethExplorerDict;
    return "";
  }

  int _formatUsdcDecimal(ChainType chainType) {
    if (chainType == ChainType.polygon) return polygonUsdcDecimal;
    if (chainType == ChainType.bsc) return bscUsdcDecimal;
    if (chainType == ChainType.rangers) return rangersUsdcDecimal;
    if (chainType == ChainType.eth) return ethUsdcDecimal;
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
