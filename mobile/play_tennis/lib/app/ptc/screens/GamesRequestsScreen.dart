import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import '../../../logic/ptc/models/PlayerLocationData.dart';
import '../../../main.dart';
import '../../main/widgets/Loading.dart';
import '../../main/widgets/side_drawer.dart';
import '../widgets/CountryAndCitySelectWidget.dart';
import '../widgets/game-requests/SearchGameRequestsForm.dart';

class GamesRequestsScreen extends StatefulWidget {
  final bool showMine;
  const GamesRequestsScreen({super.key, required this.showMine});

  @override
  State<GamesRequestsScreen> createState() => _GamesRequestsScreenState();
}

class _GamesRequestsScreenState extends State<GamesRequestsScreen> {
  PlayerLocationData? locationData;
  final CountryAndCitySelectController countryAndCitySelectController =
      CountryAndCitySelectController();
  @override
  void initState() {
    super.initState();
    getData();
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
            ? SearchGameRequestsForm(
                countryAndCitySelectController: countryAndCitySelectController,
                showMine: widget.showMine,
              )
            : const Loading(text: "Получение профиля"),
      ),
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: widget.showMine
            ? const Text("Мои заявки")
            : const Text("Заявки на игру"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/game-requests/add");
            },
            icon: const Icon(Icons.add_circle),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
