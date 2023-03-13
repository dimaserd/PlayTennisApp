import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/main/widgets/side_drawer.dart';
import 'package:play_tennis/app/ptc/widgets/CountryAndCitySelectWidget.dart';
import 'package:play_tennis/app/ptc/widgets/tabbed-pages/PlayTabbedPage.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/models/PlayerLocationData.dart';
import 'package:play_tennis/main-services.dart';

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

  String title = "Игроки";
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    AppServices.playerService.getLocationData().then((value) {
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
    return getWidget(context);
  }

  Widget buildOld(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(20),
          child: locationData != null
              ? PlayTabbedPage(
                  locationData: locationData!,
                  onItemTapped: _onItemTapped,
                  selectedIndex: selectedIndex,
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
      ),
    );
  }

  Widget getWidget(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/game-requests/add");
              },
              icon: const Icon(Icons.add_circle),
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.directions_car),
                text: "Заявки",
              ),
              Tab(
                icon: Icon(Icons.directions_transit),
                text: "Корты",
              ),
              Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
          title: const Text('Tabs Demo'),
        ),
        drawer: const SideDrawer(),
        body: const TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      if (index == 0) {
        title = "Игроки";
      } else if (index == 1) {
        title = "Сообщества";
      } else if (index == 2) {
        title = "Тренеры";
      } else if (index == 3) {
        title = "Корты";
      }
    });
  }
}
