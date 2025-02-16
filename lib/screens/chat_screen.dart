
import 'package:chat_gpt/constants/constant.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:chat_gpt/providers/models_provider.dart';
import 'package:chat_gpt/services/api_services.dart';
import 'package:chat_gpt/services/assets_manager.dart';
import 'package:chat_gpt/services/services.dart';
import 'package:chat_gpt/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;

  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  List<ChatModel> chatList = [];

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
        title: const Text(
          "ChatGPT",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          Flexible(
            child: ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                return ChatWidget(
                  msg: chatList[index].msg,
                  chatIndex: chatList[index].chatIndex,
                );
              },
            ),
          ),
          if (_isTyping) ...[
            const SpinKitThreeBounce(
              color: Colors.white,
              size: 18,
            ),
          ],
          SizedBox(height: 15),
          Container(
            color: cardColor,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: textEditingController,
                      onSubmitted: (value) async {
                        await sendMessage(
                          modelsProvider: modelsProvider,
                        );
                      },
                      decoration: const InputDecoration.collapsed(
                        hintText: "How can I help you?",
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await sendMessage(
                        modelsProvider: modelsProvider,
                      );
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> sendMessage({required ModelsProvider modelsProvider}) async {
  try {
    final userMessage = textEditingController.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _isTyping = true;
    });

    textEditingController.clear();

    // Get AI response
    List<ChatModel> responseMessages = await ApiService.sendMessage(
      message: userMessage,
      modelId: modelsProvider.currentModel,
    );

    setState(() {
      chatList.addAll(responseMessages);
    });
  } catch (error) {
    print("Error: $error");
  } finally {
    setState(() {
      _isTyping = false;
    });
  }
}

}
