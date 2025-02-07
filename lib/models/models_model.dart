class ModelsModel {
  final String id;
  final int created;
  final String object;

  ModelsModel({
    required this.id,
    required this.created,
    required this.object,
  });

  factory ModelsModel.fromJson(Map<String, dynamic> json) {
    return ModelsModel(
      id: json['id'],
      created: json['created'],
      object: json['object'], 
    );
  }

  static List<ModelsModel> modelsFromSnapshot(List<dynamic> modelSnapshot) {
    return modelSnapshot.map((data) => ModelsModel.fromJson(data)).toList();
  }
}
