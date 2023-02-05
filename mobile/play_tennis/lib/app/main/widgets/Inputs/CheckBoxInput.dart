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
  final bool isChecked;
  final Function(bool) onChangeFunction;

  const CheckBoxInput({
    super.key,
    required this.isChecked,
    required this.onChangeFunction,
  });

  @override
  State<CheckBoxInput> createState() => _CheckBoxInputState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _CheckBoxInputState extends State<CheckBoxInput> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(_getColor),
      value: isChecked,
      onChanged: (bool? value) {
        final bool newValue = value!;
        setState(() {
          isChecked = newValue;
        });
        widget.onChangeFunction(newValue);
      },
    );
  }

  static Color _getColor(Set<MaterialState> states) {
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
}
