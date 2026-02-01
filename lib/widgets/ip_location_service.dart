import 'dart:convert';
import 'package:http/http.dart' as http;

class IpLocationService {
  static Future<Map<String, String>> fetchLocation() async {
    try {
      final response = await http.get(
        Uri.parse('https://ipapi.co/json/'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return {
          "city": data['city'] ?? '',
          "region": data['region'] ?? '',
          "country": data['country_name'] ?? '',
        };
      } else {
        return {"city": "", "region": "", "country": ""};
      }
    } catch (e) {
      return {"city": "", "region": "", "country": ""};
    }
  }
}
