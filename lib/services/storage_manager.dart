import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static void save(String key, dynamic value) async {
    // final sp = await SharedPreferences.getInstance();
    final storage = new FlutterSecureStorage();
    await storage.write(key: key, value: value);

    // switch (value.runtimeType) {
    //   case int:
    //     sp.setInt(key, value);
    //     break;
    //   case String:
    //     sp.setString(key, value);
    //     break;
    //   case bool:
    //     sp.setBool(key, value);
    //     break;
    //   default:
    //     log("Type is not correct", name: "error");
    // }
  }

  static Future<dynamic> read(String key) async {
    // final sp = await SharedPreferences.getInstance();
    final storage = new FlutterSecureStorage();
    dynamic value = await storage.read(key: key);

    // dynamic obj = sp.get(key);
    return value;
  }

  static Future<bool> delete(String key) async {
    // final sp = await SharedPreferences.getInstance();
    final storage = new FlutterSecureStorage();
    // return sp.remove(key);
    await storage.delete(key: key);

    return true;
  }
}