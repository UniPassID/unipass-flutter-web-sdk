import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unipass_web_sdk/utils/interface.dart';
import 'package:unipass_web_sdk/connect_page.dart';
import 'package:unipass_web_sdk/utils/storage.dart';

Future<UpAccount> pushConnect(BuildContext context, String email, UniPassConfig config) async {
  // UpAccount? localAccount = Storage.getUpAccount();
  // if (localAccount != null) return localAccount;

  Completer<UpAccount> completer = Completer<UpAccount>();
  Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectPage(connectFuture: completer)));

  return completer.future;
}

Future<bool> disConnect() async {
  return await Storage.removeUpAccount();
}
