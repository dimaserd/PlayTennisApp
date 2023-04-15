import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/main/widgets/TelegramData.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/PlayerData.dart';
import 'package:play_tennis/logic/ptc/models/cities/PublicTelegramChatForCityModel.dart';
import 'package:play_tennis/main-services.dart';

class TelegramProfileScreen extends StatefulWidget {
  const TelegramProfileScreen({super.key});

  @override
  TelegramProfileScreenState createState() => TelegramProfileScreenState();
}

class TelegramProfileScreenState extends State<TelegramProfileScreen>
    with SingleTickerProviderStateMixin {
  PlayerData? playerData;
  CurrentLoginData? loginData;
  PublicTelegramChatForCityModel? telegramCityModel;

  @override
  void initState() {
    super.initState();
    getPlayerData();
    getLoginData();
  }

  void getPlayerData() {
    AppServices.playerService.getData().then((value) {
      if (value == null) {
        BaseApiResponseUtils.showError(context, "Кажется вы были разлогинены");
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => true);
        return;
      }
      if (mounted) {
        setState(() {
          playerData = value;
        });
      }

      if (playerData == null) {
        return;
      }

      loadTelegramData(playerData!.cityId!);
    });
  }

  void getLoginData() {
    AppServices.loginService.getLoginData().then((value) {
      if (mounted) {
        setState(() {
          loginData = value;
        });
      }
    });
  }

  void loadTelegramData(String cityId) {
    AppServices.cityService.getTelegramDataById(cityId, (p0) {}).then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        telegramCityModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Telegram сообщество"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: getWidgets(),
        ),
      ),
    );
  }

  List<Widget> getWidgets() {
    if (playerData == null || loginData == null) {
      return const [
        Loading(text: "Загрузка"),
      ];
    }

    return [
      Center(
        child: TelegramData(
          player: playerData!,
          loginData: loginData,
          telegramCityModel: telegramCityModel!,
        ),
      ),
    ];
  }
}
