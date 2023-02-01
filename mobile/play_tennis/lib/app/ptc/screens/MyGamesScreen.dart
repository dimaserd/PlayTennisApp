import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/CountryAndCitySelectWidget.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import '../../../baseApiResponseUtils.dart';
import '../../../logic/ptc/models/PlayerLocationData.dart';
import '../../../main.dart';
import '../../main/widgets/Loading.dart';
import '../../main/widgets/side_drawer.dart';
import '../widgets/games/SearchGamesWidget.dart';

class MyGamesScreen extends StatefulWidget {
  const MyGamesScreen({super.key});

  @override
  State<MyGamesScreen> createState() => _MyGamesScreenState();
}

class _MyGamesScreenState extends State<MyGamesScreen> {
  PlayerLocationData? locationData;
  CurrentLoginData? loginData;
  CountryAndCitySelectController countryAndCitySelectController =
      CountryAndCitySelectController();

  @override
  void initState() {
    super.initState();
    getLoginData();
  }

  getLoginData() {
    MyApp.loginService.getLoginData().then((value) {
      loginData = value;
      getData();
    });
  }

  getData() {
    MyApp.playerService.getLocationData().then((value) {
      if (value == null) {
        BaseApiResponseUtils.showError(context, "Кажется вы были разлогинены");
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => true);
        return;
      }

      countryAndCitySelectController.setLocationData(value);
      setState(() {
        locationData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(20),
        child: locationData != null
            ? SearchGamesWidget(
                loginData: loginData!,
              )
            : const Loading(text: "Загрузка"),
      ),
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: const Text("Мои игры"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/games/add");
            },
            icon: const Icon(Icons.add_circle),
          )
        ],
      ),
    );
  }
}
