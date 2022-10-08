library unipass_web_sdk;

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:unipass_web_sdk/utils/config.dart';
import 'package:unipass_web_sdk/utils/storage.dart';
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
    Environment env = option.env ?? Environment.dev;
    String rpcUrl = option.nodeRPC ?? getRpcUrl(env, chainType);
    _config = UniPassConfig(
      nodeRPC: rpcUrl,
      chainType: chainType,
      env: env,
      domain: option.domain ?? upDomain,
      protocol: option.protocol ?? "https",
    );
    Storage.init();
  }

  Future<UpAccount> login(BuildContext context, String email) async {
    UpAccount upAccount = await pushConnect(context, email, _config);
    Storage.saveUpAccount(upAccount);
    _account = upAccount;
    _initialized = true;
    _provider = web3.Web3Client(_config.nodeRPC, Client());
    return upAccount;
  }

  Future<bool> logout() async {
    return await disConnect();
  }

  web3.Web3Client getProvider() {
    _checkInitialized();
    return _provider!;
  }

  String getAddress() {
    _checkInitialized();
    return _account!.address;
  }

  void _checkInitialized() {
    if (!_initialized) {
      throw Exception("UniPass SDK is not initialized");
    }
  }
}
