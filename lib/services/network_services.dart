import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:testapp/models/item_model.dart';

abstract class ItemsRepository {
  Future<List<Item>> getItemList();
}

class NetworkServices implements ItemsRepository {
  static const BASE_SERVER_URL = 'http://test.php-cd.attractgroup.com';
  static const String _GET_ITEMS = '/test.json';
  var url = '$BASE_SERVER_URL$_GET_ITEMS';

  @override
  Future<List<Item>> getItemList() async {

    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response);
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      List<Item> items = itemFromJson(jsonResponse);
      return items;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }
}