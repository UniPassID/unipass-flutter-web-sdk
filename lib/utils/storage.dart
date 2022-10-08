import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:unipass_web_sdk/unipass_web_sdk.dart';

const upAccountKey = "unipass_user_accounts";

class Storage {
  static late SharedPreferences prefs;

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool?> saveUpAccount(UpAccount account) async {
    final value = account.toString();
    return await prefs.setString(upAccountKey, value);
  }

  static UpAccount? getUpAccount() {
    final result = prefs.getString(upAccountKey);
    print("[result] $result");
    if (result == null) return null;
    Map<String, dynamic> account = json.decode(result);
    return UpAccount(address: account["address"], email: account["email"], newborn: account["newborn"]);
  }

  static removeUpAccount() async {
    await prefs.remove(upAccountKey);
  }
}
