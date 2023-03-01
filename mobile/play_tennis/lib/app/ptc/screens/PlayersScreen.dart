import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/PlayerTabBar.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import '../../../logic/ptc/models/PlayerLocationData.dart';
import '../../../main-services.dart';
import '../../main/widgets/side_drawer.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  PlayerLocationData? locationData;
  String title = "Игроки";
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    AppServices.playerService.getLocationData().then((value) {
      if (value == null) {
        BaseApiResponseUtils.showError(context, "Кажется вы были разлогинены");
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => true);
        return;
      }
      setState(() {
        locationData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: MyTabbedPage(
            selectedIndex: selectedIndex,
            locationData: locationData,
            onItemTapped: (index) {
              _onItemTapped(index);
            },
          )),
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: Text(title),
      ),
    );
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
