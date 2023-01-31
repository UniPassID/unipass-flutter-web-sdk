import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unipass_web_sdk/pages/send_transaction_page.dart';
import 'package:unipass_web_sdk/pages/sign_mseeage_page.dart';
import 'package:unipass_web_sdk/utils/config.dart';
import 'package:unipass_web_sdk/utils/interface.dart';
import 'package:unipass_web_sdk/pages/connect_page.dart';
import 'package:unipass_web_sdk/utils/storage.dart';

Future<UpAccount> pushConnect(BuildContext context, UniPassConfig config) async {
  UpAccount? localAccount = Storage.getUpAccount();
  if (localAccount != null) return localAccount;
  final String url = getWalletUrl(MessageType.upConnect, config.domain, config.protocol, connectType: config.connectType);
  print("[pushConnect: $url]");
  Completer<UpAccount> completer = Completer<UpAccount>();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ConnectPage(
        connectFuture: completer,
        url: url,
        appSetting: config.appSetting,
        returnEmail: config.returnEmail ?? false,
      ),
    ),
  );

  return completer.future;
}

Future<String> pushSignMessage(BuildContext context, String message, UpAccount account, UniPassConfig config) async {
  final String url = getWalletUrl(MessageType.upSignMessage, config.domain, config.protocol);
  print("[pushSignMessage: $url]");
  Completer<String> completer = Completer<String>();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SignMessagePage(
        signFuture: completer,
        url: url,
        from: account.address,
        message: message,
        appSetting: config.appSetting,
      ),
    ),
  );

  return completer.future;
}

Future<String> pushSendTransaction(BuildContext context, TransactionMessage transaction, UniPassConfig config) async {
  final String url = getWalletUrl(MessageType.upSendTransaction, config.domain, config.protocol);
  print("[pushSignMessage: $url]");
  print("[transaction: $transaction]");
  Completer<String> completer = Completer<String>();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SendTransactionPage(
        transactionFuture: completer,
        url: url,
        transaction: transaction,
        appSetting: config.appSetting,
      ),
    ),
  );

  return completer.future;
}

Future<void> disConnect() async {
  await Storage.removeUpAccount();
}
