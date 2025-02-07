import 'package:chat_gpt/constants/constant.dart';
import 'package:chat_gpt/models/models_model.dart';
import 'package:chat_gpt/providers/models_provider.dart';
import 'package:chat_gpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModalsDropDownWidget extends StatefulWidget {
  const ModalsDropDownWidget({super.key});

  @override
  State<ModalsDropDownWidget> createState() => _ModalsDropDownWidgetState();
}

class _ModalsDropDownWidgetState extends State<ModalsDropDownWidget> {
  String? currentModel;

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    currentModel = modelsProvider.getCurrentModel;
    return FutureBuilder<List<ModelsModel>>(
      future: modelsProvider.getAllModels(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: TextWidget(label: snapshot.error.toString()),
          );
        }

        return snapshot.connectionState == ConnectionState.waiting
            ? const CircularProgressIndicator()
            : snapshot.data == null || snapshot.data!.isEmpty
                ? const SizedBox.shrink()
                : DropdownButton<String>(
                    dropdownColor: scaffoldBackgroundColor,
                    iconEnabledColor: Colors.white,
                    items: snapshot.data!.map((model) {
                      return DropdownMenuItem(
                        value: model.id,
                        child: TextWidget(
                          color: Colors.white,
                          label: model.id,
                          fontSize: 15,
                        ),
                      );
                    }).toList(),
                    value: currentModel,
                    onChanged: (value) {
                      setState(() {
                        currentModel = value!;
                      });
                      modelsProvider.setcurrentModel(value.toString(),);
                    },
                  );
      },
    );
  }
}
