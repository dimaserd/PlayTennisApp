import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import '../../../logic/ptc/models/PlayerData.dart';
import '../../../main-services.dart';
import '../widgets/Loading.dart';
import '../widgets/profile_data.dart';
import '../widgets/side_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
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
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Center(
          child: loginData != null
              ? ProfileData(player: loginData!)
              : const Loading(text: "Получение профиля"),
        ),
      ),
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: const Text("Профиль"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/profile-edit");
            },
            icon: const Icon(Icons.edit),
          )
        ],
      ),
    );
  }
}
