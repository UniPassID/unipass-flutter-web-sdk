import 'package:unipass_web_sdk/unipass_web_sdk.dart';

const unipassMessagePrefix = '\x18UniPass Signed Message:\n';

class RpcUrl {
  String polygonMainnet;
  String bscMainnet;
  String rangersMainnet;
  String polygonMumbai;
  String bscTestnet;
  String rangersRobin;

  RpcUrl(this.polygonMainnet, this.bscMainnet, this.rangersMainnet, this.polygonMumbai, this.bscTestnet, this.rangersRobin);
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
  if (env == Environment.testnet) {
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

String getWalletUrl(MessageType type, String? domain, String? protocol, { ConnectType? connectType }) {
  final protocol_ = protocol ?? "https";
  final domain_ = domain ?? upDomain;

  switch (type) {
    case MessageType.upConnect:
      if (connectType == ConnectType.google) {
        return '$protocol_://$domain_/connect?connectType=google';
      }
      if (connectType == ConnectType.email) {
        return '$protocol_://$domain_/connect?connectType=email';
      }
      return '$protocol_://$domain_/connect';
    case MessageType.upSignMessage:
      return '$protocol_://$domain_/sign-message';
    case MessageType.upSendTransaction:
      return '$protocol_://$domain_/send-transaction';
    case MessageType.upReady:
      return '$protocol_://$domain_/connect/loading';
    default:
      return domain_;
  }
}
