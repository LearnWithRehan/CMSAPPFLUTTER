import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/plant_model.dart';
import '../constants/api_constants.dart';

class ApiService {
  static Future<List<PlantModel>> fetchPlants() async {
    final url =
    Uri.parse(ApiConstants.baseUrl + ApiConstants.plantMaster);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['success'] == 1) {
        List list = jsonData['data'];
        return list.map((e) => PlantModel.fromJson(e)).toList();
      } else {
        throw Exception(jsonData['message']);
      }
    } else {
      throw Exception("Server Error");
    }
  }
}
