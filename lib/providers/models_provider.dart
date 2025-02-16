import 'package:chat_gpt/models/models_model.dart';
import 'package:chat_gpt/services/api_services.dart';
import 'package:flutter/material.dart';

class ModelsProvider with ChangeNotifier {
  String _currentModel = "";

  String get currentModel => _currentModel;

  void setCurrentModel(String newModel) {
    _currentModel = newModel;
    notifyListeners();
  }

  List<ModelsModel> _modelsList = [];

  List<ModelsModel> get modelsList => _modelsList;

  Future<void> initializeModel() async {
    try {
      List<ModelsModel> models = await ApiService.getModels();
      if (models.isNotEmpty) {
        _modelsList = models;
        setCurrentModel(models.first.id); // Set the first available model
      }
    } catch (error) {
      debugPrint("Error fetching models: $error");
    }
  }
}
