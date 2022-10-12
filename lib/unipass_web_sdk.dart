library unipass_web_sdk;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:unipass_web_sdk/abi/verifySig.g.dart';
import 'package:unipass_web_sdk/utils/config.dart';
import 'package:unipass_web_sdk/utils/storage.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:unipass_web_sdk/utils/interface.dart';
import 'package:unipass_web_sdk/push.dart';

export 'package:unipass_web_sdk/utils/interface.dart';

class UniPassWeb {
  late UniPassConfig _config;
  UpAccount? _account;
  web3.Web3Client? _provider;
  bool _initialized = false;

  UniPassWeb(UniPassOption option) {
    _init(option);
  }

  void _init(UniPassOption option) {
    ChainType chainType = option.chainType ?? ChainType.polygon;
    Environment env = option.env ?? Environment.testnet;
    String rpcUrl = option.nodeRPC ?? getRpcUrl(env, chainType);
    AppSetting appSetting = option.appSetting ?? AppSetting(theme: UnipassTheme.dark, chainType: chainType);
    _config = UniPassConfig(
      nodeRPC: rpcUrl,
      chainType: chainType,
      env: env,
      domain: option.domain ?? upDomain,
      protocol: option.protocol ?? "https",
      appSetting: appSetting,
    );
    Storage.init();
  }

  Future<UpAccount> connect(BuildContext context) async {
    UpAccount upAccount = await pushConnect(context, _config);
    Storage.saveUpAccount(upAccount);
    _account = upAccount;
    _initialized = true;
    _provider = web3.Web3Client(_config.nodeRPC, Client());
    return upAccount;
  }

  Future<String> signMessage(BuildContext context, String message) async {
    _checkInitialized();
    String signedMessage = await pushSignMessage(context, message, _account!, _config);
    print("[signedMessage:] $signedMessage");
    return signedMessage;
  }

  Future<String> sendTransaction(BuildContext context, TransactionMessage transaction) async {
    _checkInitialized();
    String txHash = await pushSendTransaction(context, transaction, _config);
    print("[txHash:] $txHash");
    return txHash;
  }

  Future<bool> isValidSignature(String message, String sig) async {
    _checkInitialized();
    final hash_ = keccak256(Uint8List.fromList(message.codeUnits));
    Uint8List code = await VerifySig(address: web3.EthereumAddress.fromHex(_account!.address), client: _provider!).isValidSignature(
      hash_,
      hexToBytes(sig),
    );
    return bytesToHex(code, include0x: true) == "0x1626ba7e";
  }

  Future<void> logout() async {
    await disConnect();
  }

  web3.Web3Client getProvider() {
    _checkInitialized();
    return _provider!;
  }

  String getAddress() {
    _checkInitialized();
    return _account!.address;
  }

  void updateConfig({UnipassTheme? theme, ChainType? chainType, String? nodeRPC}) {
    if (theme != null) {
      _config.appSetting.theme = theme;
    }
    if (chainType != null) {
      _config.appSetting.chainType = chainType;
    }
    if (nodeRPC != null) {
      _config.nodeRPC = nodeRPC;
    }
  }

  void _checkInitialized() {
    if (!_initialized) {
      throw Exception("UniPass SDK is not initialized");
    }
  }
}
