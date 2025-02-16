import 'package:chat_gpt/constants/constant.dart';
import 'package:chat_gpt/widgets/drop_down.dart';
import 'package:chat_gpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class Services {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(0),
        ),
      ),
      backgroundColor: scaffoldBackgroundColor,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: TextWidget(
                  label: "Choosen Model",
                  fontSize: 16,
                ),
              ),
              Flexible(
                flex: 2,
                child: ModelsDropdownWidget(),
              ),
            ],
          ),
        );
      },
    );
  }
}
