import 'package:flutter/material.dart';
import '../../../main-settings.dart';

class Loading extends StatelessWidget {
  final String text;
  const Loading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text),
        Center(
          child: Image.asset(
            MainSettings.loadingPath,
            height: 150,
            width: 150,
          ),
        ),
      ],
    );
  }
}
