import 'package:unipass_web_sdk/unipass_web_sdk.dart';

const unipassMessagePrefix = '\x18UniPass Signed Message:\n';

class RpcUrl {
  String polygonMainnet;
  String ethMainnet;
  String bscMainnet;
  String rangersMainnet;
  String arbitrumMainnet;
  String avalancheMainnet;
  String kccMainnet;
  String platonMainnet;
  String okcMainnet;

  String polygonMumbai;
  String ethGoerli;
  String bscTestnet;
  String rangersRobin;
  String arbitrumTestnet;
  String avalancheTestnet;
  String kccTestnet;
  String platonTestnet;
  String okcTestnet;

  RpcUrl(
    this.polygonMainnet,
    this.ethMainnet,
    this.bscMainnet,
    this.rangersMainnet,
    this.arbitrumMainnet,
    this.avalancheMainnet,
    this.kccMainnet,
    this.platonMainnet,
    this.okcMainnet,
    this.polygonMumbai,
    this.bscTestnet,
    this.ethGoerli,
    this.rangersRobin,
    this.arbitrumTestnet,
    this.avalancheTestnet,
    this.kccTestnet,
    this.platonTestnet,
    this.okcTestnet,
  );
}

RpcUrl rpcUrl = RpcUrl(
  "https://node.wallet.unipass.id/polygon-mainnet",
  "https://node.wallet.unipass.id/eth-mainnet",
  "https://node.wallet.unipass.id/bsc-mainnet",
  "https://node.wallet.unipass.id/rangers-mainnet",
  "https://node.wallet.unipass.id/arbitrum-mainnet",
  "https://node.wallet.unipass.id/avalanche-mainnet",
  "https://node.wallet.unipass.id/kcc-mainnet",
  "https://node.wallet.unipass.id/platon-mainnet",
  "https://node.wallet.unipass.id/okc-mainnet",
  "https://node.wallet.unipass.id/polygon-mumbai",
  "https://node.wallet.unipass.id/eth-goerli",
  "https://node.wallet.unipass.id/bsc-testnet",
  "https://node.wallet.unipass.id/rangers-robin",
  "https://node.wallet.unipass.id/arbitrum-testnet",
  "https://node.wallet.unipass.id/avalanche-testnet",
  "https://node.wallet.unipass.id/kcc-testnet",
  "https://node.wallet.unipass.id/platon-testnet",
  "https://node.wallet.unipass.id/okc-testnet",
);

String getRpcUrl(Environment env, ChainType chainType) {
  if (env == Environment.testnet) {
    switch (chainType) {
      case ChainType.polygon:
        return rpcUrl.polygonMumbai;
      case ChainType.eth:
        return rpcUrl.ethGoerli;
      case ChainType.bsc:
        return rpcUrl.bscTestnet;
      case ChainType.rangers:
        return rpcUrl.rangersRobin;
      case ChainType.arbitrum:
        return rpcUrl.arbitrumTestnet;
      case ChainType.avalanche:
        return rpcUrl.avalancheTestnet;
      case ChainType.kcc:
        return rpcUrl.kccTestnet;
      case ChainType.platon:
        return rpcUrl.platonTestnet;
      case ChainType.okc:
        return rpcUrl.okcTestnet;
    }
  } else {
    switch (chainType) {
      case ChainType.polygon:
        return rpcUrl.polygonMainnet;
      case ChainType.eth:
        return rpcUrl.ethMainnet;
      case ChainType.bsc:
        return rpcUrl.bscMainnet;
      case ChainType.rangers:
        return rpcUrl.rangersMainnet;
      case ChainType.arbitrum:
        return rpcUrl.arbitrumMainnet;
      case ChainType.avalanche:
        return rpcUrl.avalancheMainnet;
      case ChainType.kcc:
        return rpcUrl.kccMainnet;
      case ChainType.platon:
        return rpcUrl.platonMainnet;
      case ChainType.okc:
        return rpcUrl.okcMainnet;
    }
  }
}

const String upDomain = "wallet.unipass.id";

String getWalletUrl(MessageType type, String domain, String? protocol, {ConnectType? connectType}) {
  final protocol_ = protocol ?? "https";
  final domain_ = domain;

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
