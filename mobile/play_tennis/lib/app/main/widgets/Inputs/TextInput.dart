import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  late String labelText;
  TextEditingController? textController;
  TextInput({
    super.key,
    required this.labelText,
    this.textController,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
      child: TextField(
        obscureText: false,
        decoration: InputDecoration(
          border: null,
          labelText: labelText,
        ),
        controller: textController,
      ),
    );
  }
}

class TextAreaInput extends StatelessWidget {
  final String labelText;
  final TextEditingController? textController;
  final int maxLines;
  const TextAreaInput({
    super.key,
    required this.labelText,
    this.textController,
    required this.maxLines,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
      child: TextField(
        maxLines: maxLines,
        minLines: 2,
        obscureText: false,
        decoration: InputDecoration(
          border: null,
          labelText: labelText,
        ),
        controller: textController,
      ),
    );
  }
}
