/// Flutter code sample for Checkbox

// This example shows how you can override the default theme of
// of a [Checkbox] with a [MaterialStateProperty].
// In this example, the checkbox's color will be `Colors.blue` when the [Checkbox]
// is being pressed, hovered, or focused. Otherwise, the checkbox's color will
// be `Colors.red`.

import 'package:flutter/material.dart';
import '../palette.dart';

/// This is the stateful widget that the main application instantiates.
class CheckBoxInput extends StatefulWidget {
  late final bool isChecked;
  final Function(bool) onChangeFunction;

  CheckBoxInput({
    super.key,
    required this.isChecked,
    required this.onChangeFunction,
  });

  static Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return mainColor;
  }

  @override
  State<CheckBoxInput> createState() => _CheckBoxInputState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _CheckBoxInputState extends State<CheckBoxInput> {
  bool isChecked = false;
  _CheckBoxInputState() {
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(CheckBoxInput.getColor),
      value: isChecked,
      onChanged: (bool? value) {
        var val = value!;
        setState(() {
          isChecked = val;
        });
        widget.onChangeFunction(val);
      },
    );
  }
}
