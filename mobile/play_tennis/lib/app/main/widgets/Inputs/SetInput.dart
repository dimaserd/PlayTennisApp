import 'package:flutter/material.dart';
import 'package:masked_text/masked_text.dart';

class SetInput extends StatelessWidget {
  late String labelText;
  TextEditingController? textController;
  SetInput({
    super.key,
    required this.labelText,
    this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return MaskedTextField(
      controller: textController,
      mask: "#:#",
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.done,
      style: const TextStyle(
        fontSize: 24,
      ),
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }
}
