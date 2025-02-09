import 'package:chat_gpt/models/models_model.dart';
import 'package:chat_gpt/services/api_services.dart';
import 'package:flutter/material.dart';

class ModelsProvider with ChangeNotifier {
 
  String currentModel = "deepseek-chat";
  
  String get getCurrentModel {
    return currentModel;
  }
  void setCurrentModel(String newModels) {
    currentModel = newModels;
    notifyListeners();
  }

  List<ModelsModel> modelsList = [];

  List<ModelsModel> get getmodelsList {
    return modelsList;
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiService.getModels();
    return modelsList;
  }
}
