import 'dart:convert';
import 'package:http/http.dart' as http;

class IpLocationService {
  static Future<Map<String, dynamic>> fetchLocation() async {
    final response = await http
        .get(Uri.parse("http://ip-api.com/json"))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch location");
    }
  }
}
