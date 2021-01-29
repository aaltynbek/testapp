import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static void save(String key, dynamic value) async {
    final sp = await SharedPreferences.getInstance();
    switch (value.runtimeType) {
      case int:
        sp.setInt(key, value);
        break;
      case String:
        sp.setString(key, value);
        break;
      case bool:
        sp.setBool(key, value);
        break;
      default:
        log("Type is not correct", name: "error");
    }
  }

  static Future<dynamic> read(String key) async {
    final sp = await SharedPreferences.getInstance();
    dynamic obj = sp.get(key);
    return obj;
  }

  static Future<bool> delete(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.remove(key);
  }
}