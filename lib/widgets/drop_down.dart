import 'package:chat_gpt/constants/constant.dart';
import 'package:chat_gpt/providers/models_provider.dart';
import 'package:chat_gpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModelsDropdownWidget extends StatefulWidget {
  const ModelsDropdownWidget({super.key});

  @override
  State<ModelsDropdownWidget> createState() => _ModelsDropdownWidgetState();
}

class _ModelsDropdownWidgetState extends State<ModelsDropdownWidget> {
  String? currentModel;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final modelsProvider =
          Provider.of<ModelsProvider>(context, listen: false);
      await modelsProvider.initializeModel();
      setState(() {
        currentModel = modelsProvider.currentModel;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);

    return modelsProvider.modelsList.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : FittedBox(
            child: DropdownButton<String>(
              dropdownColor: scaffoldBackgroundColor,
              iconEnabledColor: Colors.white,
              items: modelsProvider.modelsList
                  .map((model) => DropdownMenuItem(
                        value: model.id,
                        child: TextWidget(
                          label: model.id,
                          fontSize: 15,
                        ),
                      ))
                  .toList(),
              value: currentModel ?? modelsProvider.currentModel,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    currentModel = value;
                  });
                  modelsProvider.setCurrentModel(value);
                }
              },
            ),
          );
  }
}
