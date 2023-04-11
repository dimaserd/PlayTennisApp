import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/profile/TelegramLinkWidget.dart';

class TelegramLinkScreen extends StatelessWidget {
  const TelegramLinkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Привязать Telegram'),
        ),
        drawer: null,
        body: const Padding(
          padding: EdgeInsets.all(20.0),
          child: TelegramLinkWidget(),
        ),
      ),
    );
  }
}
