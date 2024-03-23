import 'dart:convert';

import 'package:food_app/model/food_model.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  static Future<List<FoodModel>> fetchData() async {
    var response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s='));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('meals') && jsonResponse['meals'] is List) {
        List<dynamic> food = jsonResponse['meals'];
        List<FoodModel> foodModel =
            food.map((item) => FoodModel.fromJson(item)).toList();
        return foodModel;
      } else {
        return [];
      }
    } else {
      throw Exception('error');
    }
  }

  static Future<List<FoodModel>> searchData(name) async {
    var response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/search.php?s=$name'));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('meals') && jsonResponse['meals'] is List) {
        List<dynamic> food = jsonResponse['meals'];
        List<FoodModel> foodModel =
            food.map((item) => FoodModel.fromJson(item)).toList();
        return foodModel;
      } else {
        return [];
      }
    } else {
      throw Exception('error');
    }
  }
}
