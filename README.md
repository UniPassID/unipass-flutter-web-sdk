A Flutter plugin that allows you using unipass with webview page.

## Requirements

- Dart sdk: '>=2.18.1 <3.0.0'
- Flutter: flutter: ">=2.5.0"

## Installation

Add `unipass_webview` as a [dependency in your pubspec.yaml file](https://flutter.io/using-packages/).

## Usage

### interface
```dart
/// interface declare
enum Environment { testnet, mainnet }

enum ChainType { polygon, bsc, rangers }

enum Protocol { https, http }

enum UnipassTheme { light, dark }

class AppSetting {
  String? appName;
  String? appIcon;
  UnipassTheme theme;
  ChainType chainType;

  AppSetting({this.appName, this.appIcon, required this.theme, required this.chainType});
}

class UniPassOption {
  String? nodeRPC;
  ChainType? chainType;
  Environment? env;
  String? domain;
  String? protocol;
  AppSetting? appSetting;

  UniPassOption({this.nodeRPC, this.chainType, this.env, this.domain, this.protocol, this.appSetting});
}
```

### full creation example
```dart
  UniPassWeb uniPassWeb = UniPassWeb(
    UniPassOption(
      dev: Environment.testnet,
      nodeRPC: "https://node.wallet.unipass.id/polygon-mumbai",
      domain: "testnet.wallet.unipass.id",
      protocol: "https",
      appSetting: AppSetting(
        appName: "demo dapp",
        appIcon: "",
        theme: UnipassTheme.dark,
        chainType: ChainType.polygon,
      ),
    ),
  );
```
