import 'dart:convert';

enum Environment { testnet, mainnet }

enum ChainType { polygon, eth, bsc, rangers }

enum Protocol { https, http }

enum UnipassTheme { light, dark }

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

  UpAccount({required this.address, this.email = "", this.newborn = false});

  @override
  String toString() {
    Map<String, dynamic> value = {
      "address": address,
      "email": email,
      "newborn": newborn,
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

  UniPassOption({
    this.nodeRPC,
    this.env,
    this.domain,
    this.protocol,
    this.appSetting,
    this.returnEmail,
    this.connectType = ConnectType.both,
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

  UniPassConfig({
    required this.nodeRPC,
    required this.chainType,
    required this.env,
    required this.domain,
    required this.protocol,
    required this.appSetting,
    this.returnEmail,
    this.connectType,
  });
}
