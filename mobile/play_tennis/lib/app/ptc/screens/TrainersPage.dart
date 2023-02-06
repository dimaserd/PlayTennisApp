import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/side_drawer.dart';
import '../../../main-extensions.dart';

class TrainersPage extends StatelessWidget {
  const TrainersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Тренеры"),
      ),
      drawer: const SideDrawer(),
      body: Center(
        child: RichText(
          text: TextSpan(
            text: 'Перейти на сайт',
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 18,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => MainAppExtensions.trylaunchAppUrl(context, "ptc/trainers"),
          ),
        ),
      ),
    );
  }
}
