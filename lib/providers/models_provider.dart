import 'package:chat_gpt/models/models_model.dart';
import 'package:chat_gpt/services/api_services.dart';
import 'package:flutter/material.dart';

// class ModelsProvider with ChangeNotifier {
//   List<ModelsModel> _models = [];
//   List<ModelsModel> get models => _models;

//   Future<void> getModels() async {
//     try {
//       _models = await ApiServices.getModels();
//       notifyListeners();
//     } catch (error) {
//       log("error $error");
//       rethrow;
//     }
//   }
// }

class ModelsProvider with ChangeNotifier {
 
  String currentModel = "gpt-4o-mini";
  
  String get getCurrentModel {
    return currentModel;
  }
  void setcurrentModel(String newModels) {
    currentModel = newModels;
    notifyListeners();
  }

  List<ModelsModel> modelsList = [];

  List<ModelsModel> get getmodelsList {
    return modelsList;
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiServices.getModels();
    return modelsList;
  }
}
