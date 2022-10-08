import 'dart:convert';

enum Environment { dev, test, prod }

enum ChainType { polygon, bsc, rangers }

enum Protocol { https, http }

enum MessageType {
  UP_READY,
  UP_RESPONSE,
  UP_CLOSE,
  UP_SIGN_MESSAGE,
  UP_TRANSACTION,
  UP_LOGIN,
  UP_EVENT,
  UP_ERROR,
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

/// init sdk props
class UniPassOption {
  String? nodeRPC;
  ChainType? chainType;
  Environment? env;
  String? domain;
  String? protocol;

  UniPassOption({this.nodeRPC, this.chainType, this.env, this.domain, this.protocol});
}

/// sdk config
class UniPassConfig {
  String nodeRPC;
  ChainType chainType;
  Environment env;
  String domain;
  String protocol;

  UniPassConfig({
    required this.nodeRPC,
    required this.chainType,
    required this.env,
    required this.domain,
    required this.protocol,
  });
}

// class BasePayload {
//   MessageType type;
//   String payload;
// }
