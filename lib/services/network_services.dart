import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:testapp/models/item_model.dart';

class NetworkServices {
  
  static Future<http.Response> getUsers() {
    var url = "http://test.php-cd.attractgroup.com/test.json";
    var myUrl = "http://sxdm.kz/new.json";
    log("Get request is called for url $myUrl");
    return http.get(
      myUrl, 
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      }
    );
  }

  static Future<http.Response> addItem(Item item) {
    return http.post(
      'http://sxdm.kz/test.php',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: {
        'itemId': item.itemId,
        'name': item.name,
        'description': item.description,
        'image': item.image,
        'time': item.time,
      },
    );
  }

  static Future<String> uploadFile(path) async {
    var uri = Uri.parse('http://sxdm.kz/upload.php');
    var request = http.MultipartRequest('POST', uri)
      ..fields['token'] = 'token123'
      ..files.add(
        await http.MultipartFile.fromPath(
          'uploadedFile', path,
        )
      );
    var response = await request.send();
    if (response.statusCode == 200) print('Uploaded!');
    return response.stream.bytesToString();
  }
}