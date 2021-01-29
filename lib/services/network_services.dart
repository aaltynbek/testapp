import 'package:http/http.dart' as http;

class NetworkServices {
  
  static Future<http.Response> getUsers() {
    var url = 'http://test.php-cd.attractgroup.com/test.json';
    return http.get(
      url, 
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      }
    );
  }
}