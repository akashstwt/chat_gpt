class ChatModel {
  final String msg;
  final int chatIndex;

  ChatModel({
    required this.msg,
    required this.chatIndex,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      msg: json['msg'],
      chatIndex: json['chatIndex'],
    );
  }

  // static List<ChatModel> chatFromSnapshot(List<dynamic> chatSnapshot) {
  //   return chatSnapshot.map((choices) => ChatModel.fromJson(choices)).toList();
  // }
}
