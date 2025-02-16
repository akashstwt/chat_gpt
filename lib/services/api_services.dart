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
      Uri.parse("https://openrouter.ai/api/v1/models"),  // Corrected URL
      headers: {
        'Authorization': 'Bearer $API_KEY',
        'HTTP-Referer': 'https://your-app-domain.com',  // Required for OpenRouter
      },
    );

    if (response.statusCode != 200) {
      throw HttpException("Failed to fetch models: ${response.statusCode}");
    }

    Map jsonResponse = jsonDecode(response.body);

    if (jsonResponse['error'] != null) {
      throw HttpException(jsonResponse['error']["message"]);
    }

    List temp = jsonResponse["data"] ?? [];
    return ModelsModel.modelsFromSnapshot(temp);
  } catch (error) {
    log("Error fetching models: $error");
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
      Uri.parse("https://openrouter.ai/api/v1/chat/completions"),  // Corrected URL
      headers: {
        'Authorization': 'Bearer $API_KEY',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://your-app-domain.com',  // Required for OpenRouter
      },
      body: jsonEncode({
        "model": modelId,
        "messages": [
          {"role": "user", "content": message}
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw HttpException("Failed to send message: ${response.statusCode}");
    }

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (jsonResponse['error'] != null) {
      throw HttpException(jsonResponse['error']['message']);
    }

    List<ChatModel> chatList = (jsonResponse['choices'] as List)
        .map((choice) => ChatModel(
              msg: choice['message']['content'],
              chatIndex: 1,
            ))
        .toList();

    return chatList;
  } catch (error) {
    log("Error sending message: $error");
    rethrow;
  }
}

}