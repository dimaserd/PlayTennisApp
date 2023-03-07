import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import '../../../logic/ptc/models/PlayerData.dart';
import '../../../main-services.dart';
import '../../main/widgets/Loading.dart';
import '../../main/widgets/side_drawer.dart';
import '../widgets/profile/EditProfileWidget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  PlayerData? loginData;

  @override
  void initState() {
    super.initState();
    AppServices.playerService.getData().then((value) {
      if (value == null) {
        BaseApiResponseUtils.showError(context, "Кажется вы были разлогинены");
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => true);
        return;
      }
      setState(() {
        loginData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginData != null
          ? EditProfileWidget(playerData: loginData!)
          : const Loading(text: "Получение профиля"),
      drawer: const SideDrawer(),
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Редактирование профиля"),
      ),
    );
  }
}
