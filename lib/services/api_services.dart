import 'dart:io';
import 'package:chat_gpt/constants/api_const.dart';
import 'package:chat_gpt/models/models_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiServices {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$BASE_URL/models"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
        },
      );
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']['message']}");
        throw HttpException(jsonResponse['error']['message']);
      }
      // print("jsonResponse $jsonResponse");
      List<ModelsModel> models = ModelsModel.modelsFromSnapshot(jsonResponse['data']);

      // Sort the models by ID before returning
      models.sort((a, b) => a.id.compareTo(b.id));

      return models;
    } catch (error) {
      print("error $error");
      throw Exception("Failed to load models");
    }
  }
}
