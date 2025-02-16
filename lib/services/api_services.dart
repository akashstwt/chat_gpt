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
      Uri.parse("$BASE_URL/models"),  // Corrected URL
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
      Uri.parse("$BASE_URL/chat/completions"),
      headers: {
        'Authorization': 'Bearer $API_KEY',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://your-app-domain.com',  // Replace with your app domain
      },
      body: jsonEncode({
        "model": modelId,
        "messages": [
          {"role": "user", "content": message}
        ],
        "max_tokens": 100,
      }),
    );

    if (response.statusCode != 200) {
      throw HttpException("Failed to send message: ${response.statusCode}");
    }

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (jsonResponse.containsKey('error')) {
      throw HttpException(jsonResponse['error']['message']);
    }

    // Extract AI response from choices[0]
    String aiResponse = jsonResponse['choices'][0]['message']['content'];

    return [
      ChatModel(msg: message, chatIndex: 0),  // User message
      ChatModel(msg: aiResponse, chatIndex: 1),  // AI response
    ];
  } catch (error) {
    log("Error sending message: $error");
    rethrow;
  }
}
}