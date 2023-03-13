import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/side_drawer.dart';
import 'package:play_tennis/app/ptc/widgets/game-requests/AddGameRequestForm.dart';

class AddGameRequestScreen extends StatelessWidget {
  const AddGameRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: const AddGameRequestForm(),
        drawer: const SideDrawer(),
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text("Создать заявку"),
        ),
      ),
    );
  }
}
