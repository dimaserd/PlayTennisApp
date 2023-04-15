import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/main/widgets/TelegramData.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/models/PlayerLocationData.dart';
import 'package:play_tennis/logic/ptc/models/cities/PublicTelegramChatForCityModel.dart';
import 'package:play_tennis/main-services.dart';

class TelegramProfileScreen extends StatefulWidget {
  const TelegramProfileScreen({super.key});

  @override
  TelegramProfileScreenState createState() => TelegramProfileScreenState();
}

class TelegramProfileScreenState extends State<TelegramProfileScreen>
    with SingleTickerProviderStateMixin {
  PlayerLocationData? locationData;
  PublicTelegramChatForCityModel? telegramCityModel;

  @override
  void initState() {
    super.initState();
    loadLocationata();
  }

  void loadLocationata() {
    AppServices.playerService.getLocationData((e) {
      BaseApiResponseUtils.showError(
        context,
        "Произошла ошибка при получении данных о вашей локации. Пожалуйста, обратитесь к администратору портала.",
      );
    }).then((value) {
      if (value == null) {
        BaseApiResponseUtils.showError(context, "Кажется вы были разлогинены");
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => true);
        return;
      }
      if (mounted) {
        setState(() {
          locationData = value;
        });
      }

      if (locationData == null || locationData!.city == null) {
        return;
      }

      loadTelegramData(locationData!.city!.id!);
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
    if (locationData == null || telegramCityModel == null) {
      return const [
        Loading(text: "Загрузка"),
      ];
    }

    return [
      Center(
        child: TelegramData(
          locationData: locationData!,
          telegramCityModel: telegramCityModel!,
        ),
      ),
    ];
  }
}
