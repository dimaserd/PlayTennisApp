import 'package:flutter/material.dart';
import '../../main/widgets/side_drawer.dart';
import '../widgets/AddGameRequestForm.dart';

class AddGameRequestScreen extends StatelessWidget {
  const AddGameRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AddGameRequestForm(),
      drawer: const SideDrawer(),
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Создать заявку"),
      ),
    );
  }
}
