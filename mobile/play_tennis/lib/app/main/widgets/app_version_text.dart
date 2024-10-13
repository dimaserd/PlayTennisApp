import 'package:flutter/material.dart';

class AppVersionText extends StatefulWidget {
  const AppVersionText({super.key});

  @override
  State<AppVersionText> createState() => _AppVersionTextState();
}

class _AppVersionTextState extends State<AppVersionText> {
  String? appVersion;

  @override
  void initState() {
    super.initState();
    appVersion = '1.0.0';
  }

  @override
  Widget build(BuildContext context) => Text(
        'V $appVersion',
        style: const TextStyle().copyWith(
            fontSize: 9, fontStyle: FontStyle.italic, color: Colors.black),
      );
}
