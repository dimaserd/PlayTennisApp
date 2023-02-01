import 'package:flutter/material.dart';

class PasswordInput extends StatelessWidget {
  final String labelText;
  final TextEditingController? textController;
  const PasswordInput({
    super.key,
    this.labelText = "Пароль",
    this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        border: null,
        labelText: labelText,
      ),
      controller: textController,
    );
  }
}
