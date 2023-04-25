import 'dart:convert';

enum Environment { testnet, mainnet }

enum ChainType { polygon, eth, bsc, rangers, arbitrum, avalanche, kcc, platon, okc }

enum Protocol { https, http }

enum UnipassTheme { light, dark, mufex }

enum MessageType {
  upReady,
  upSignMessage,
  upSendTransaction,
  upConnect,
}

enum WebViewPageType {
  connect,
  signMessage,
  sendTransaction,
}

enum ConnectType {
  google,
  email,
  both,
}

/// connect success return values
class UpAccount {
  String address;
  String email;
  bool newborn;
  String message;
  String signature;

  UpAccount({
    required this.address,
    this.email = "",
    this.newborn = false,
    this.message = "",
    this.signature = "",
  });

  @override
  String toString() {
    Map<String, dynamic> value = {
      "address": address,
      "email": email,
      "newborn": newborn,
      "message": message,
      "signature": signature,
    };
    return json.encode(value);
  }
}

class TransactionMessage {
  String from;
  String to;
  String value;
  String data;

  TransactionMessage({
    required this.from,
    required this.to,
    required this.value,
    required this.data,
  });
}

class AppSetting {
  String? appName;
  String? appIcon;
  UnipassTheme? theme;
  ChainType? chainType;

  AppSetting({
    this.appName,
    this.appIcon,
    this.theme,
    this.chainType,
  });
}

/// init sdk props
class UniPassOption {
  String? nodeRPC;
  Environment? env;
  String? domain;
  String? protocol;
  AppSetting? appSetting;
  bool? returnEmail;
  ConnectType? connectType;
  bool? authorize;

  UniPassOption({
    this.nodeRPC,
    this.env,
    this.domain,
    this.protocol,
    this.appSetting,
    this.returnEmail,
    this.connectType = ConnectType.both,
    this.authorize,
  });
}

/// sdk config
class UniPassConfig {
  String nodeRPC;
  ChainType chainType;
  Environment env;
  String domain;
  String protocol;
  AppSetting appSetting;
  bool? returnEmail;
  ConnectType? connectType;
  bool authorize;

  UniPassConfig({
    required this.nodeRPC,
    required this.chainType,
    required this.env,
    required this.domain,
    required this.protocol,
    required this.appSetting,
    this.returnEmail,
    this.connectType,
    required this.authorize,
  });
}

