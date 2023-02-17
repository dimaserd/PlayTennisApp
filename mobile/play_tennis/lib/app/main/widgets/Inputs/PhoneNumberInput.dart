import 'package:flutter/material.dart';
import 'package:masked_text/masked_text.dart';

class PhoneNumberInput extends StatelessWidget {
  final String labelText;
  final TextEditingController? textController;
  const PhoneNumberInput({
    super.key,
    required this.labelText,
    this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return MaskedTextField(
      controller: textController,
      mask: "+7(###)-(###)-##-##",
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }
}
