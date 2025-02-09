import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chat_gpt/models/models_model.dart';
import 'package:chat_gpt/secrets.dart';
import 'package:http/http.dart' as http;
import 'package:chat_gpt/models/chat_model.dart';

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$BASE_URL/v1/models"),
        headers: {'Authorization': 'Bearer $API_KEY'},
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      print("jsonResponse $jsonResponse");
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
        // log("temp ${value["id"]}");
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  // Send Message fct
  static Future<List<ChatModel>> sendMessage({
  required String message,
  required String modelId,
}) async {
  try {
    var response = await http.post(
      Uri.parse("$BASE_URL/v1/chat/completions"), // Update the endpoint if necessary
      headers: {
        'Authorization': 'Bearer $API_KEY',
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
          "model": modelId,
          "messages": [
            {
              "role": "user",
              "content": message,
            }
          ],
          "max_tokens": 100,
        },
      ),
    );

    // Check if the response status code is 200 (OK)
    if (response.statusCode != 200) {
      throw HttpException("Failed to send message: ${response.statusCode}");
    }

    // Decode the JSON response
    Map<String, dynamic> jsonResponse;
    try {
      jsonResponse = jsonDecode(response.body);
    } catch (e) {
      throw HttpException("Invalid JSON response: ${response.body}");
    }

    // Check if the response contains an error message
    if (jsonResponse['error'] != null) {
      throw HttpException(jsonResponse['error']['message']);
    }

    // Ensure that the 'choices' field is present and is a List
    if (jsonResponse['choices'] == null || jsonResponse['choices'] is! List) {
      throw HttpException("Invalid response format: 'choices' field is missing or not a list");
    }

    // Parse the response and create a list of ChatModel objects
    List<ChatModel> chatList = [];
    if (jsonResponse['choices'].length > 0) {
      chatList = List.generate(
        jsonResponse['choices'].length,
        (index) => ChatModel(
          msg: jsonResponse['choices'][index]['message']['content'],
          chatIndex: 1,
        ),
      );
    }
    return chatList;
  } catch (error) {
    log("error $error");
    rethrow;
  }
}
}