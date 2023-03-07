import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/profile/EditPlayerAvatarWidget.dart';
import '../../../baseApiResponseUtils.dart';
import '../../../logic/ptc/models/PlayerData.dart';
import '../../../main-services.dart';
import '../widgets/Loading.dart';

class ChangeAvatarScreen extends StatefulWidget {
  const ChangeAvatarScreen({Key? key}) : super(key: key);

  @override
  State<ChangeAvatarScreen> createState() => _ChangeAvatarScreenState();
}

class _ChangeAvatarScreenState extends State<ChangeAvatarScreen> {
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
              ? Column(
                  children: [
                    EditPlayerAvatarWidget(
                      avatarFileId: loginData!.avatarFileId,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 0, left: 20, right: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          minimumSize: const Size.fromHeight(30), // NEW
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Поменяю потом",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : const Loading(text: "Получение профиля"),
        ),
      ),
      appBar: AppBar(
        title: const Text("Редактировать аватар"),
      ),
    );
  }
}
