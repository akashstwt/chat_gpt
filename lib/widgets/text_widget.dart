import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
  {super.key,
  required this.label,
  this.fontSize = 16,
  this.color,
  this.fontWeight});

final String label;
final double fontSize;
final Color? color;
final FontWeight? fontWeight;


  @override
  Widget build(BuildContext context) {
  return Text(
    label,
    style: TextStyle(
      fontSize: fontSize,
      color: color ?? Colors.white,
      fontWeight: fontWeight ?? FontWeight.w500,
    ),
  );
}
}
