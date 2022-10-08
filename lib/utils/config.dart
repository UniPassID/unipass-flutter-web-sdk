import 'package:unipass_web_sdk/unipass_web_sdk.dart';

class RpcUrl {
  String polygonMainnet;
  String bscMainnet;
  String rangersMainnet;
  String polygonMumbai;
  String bscTestnet;
  String rangersRobin;

  RpcUrl(this.polygonMainnet, this.bscMainnet, this.rangersMainnet,
      this.polygonMumbai, this.bscTestnet, this.rangersRobin);
}

RpcUrl rpcUrl = RpcUrl(
  "https://node.wallet.unipass.id/polygon-mainnet",
  "https://node.wallet.unipass.id/bsc-mainnet",
  "https://node.wallet.unipass.id/rangers-mainnet",
  "https://node.wallet.unipass.id/polygon-mumbai",
  "https://node.wallet.unipass.id/bsc-testnet",
  "https://node.wallet.unipass.id/rangers-robin",
);

String getRpcUrl(Environment env, ChainType chainType) {
  if (env == Environment.dev || env == Environment.test) {
    switch (chainType) {
      case ChainType.polygon:
        return rpcUrl.polygonMumbai;
      case ChainType.bsc:
        return rpcUrl.bscTestnet;
      case ChainType.rangers:
        return rpcUrl.rangersRobin;
    }
  } else {
    switch (chainType) {
      case ChainType.polygon:
        return rpcUrl.polygonMainnet;
      case ChainType.bsc:
        return rpcUrl.bscMainnet;
      case ChainType.rangers:
        return rpcUrl.rangersMainnet;
    }
  }
}

const String upDomain = "wallet.unipass.id";

String getWalletUrl(MessageType type, String? domain, String? protocol) {
  final protocol_ = protocol ?? "https";
  final domain_ = domain ?? upDomain;

  switch (type) {
    case MessageType.UP_LOGIN:
      return '$protocol_://$domain_/connect';
    case MessageType.UP_SIGN_MESSAGE:
      return '$protocol_://$domain_/sign-message';
    case MessageType.UP_TRANSACTION:
      return '$protocol_://$domain_/send-transaction';
    case MessageType.UP_READY:
      return '$protocol_://$domain_/connect/loading';
    default:
      return domain_;
  }
}
