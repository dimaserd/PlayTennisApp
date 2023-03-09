import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/main/widgets/side_drawer.dart';
import 'package:play_tennis/app/ptc/widgets/communities/SearchCommunityForm.dart';
import 'package:play_tennis/app/ptc/widgets/courts/SearchCourtsForm.dart';
import 'package:play_tennis/app/ptc/widgets/players/SearchPlayersForm.dart';
import 'package:play_tennis/app/ptc/widgets/trainers/SearchTrainersForm.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/models/PlayerLocationData.dart';
import 'package:play_tennis/main-services.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  PlayerLocationData? locationData;

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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                text: "Игроки",
              ),
              Tab(
                text: "Сообщества",
              ),
              Tab(
                text: "Тренеры",
              ),
              Tab(
                text: "Корты",
              ),
            ],
          ),
          title: const Text('Главная'),
        ),
        drawer: const SideDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: TabBarView(
            children: getWidgets(),
          ),
        ),
      ),
    );
  }

  List<Widget> getWidgets() {
    if (locationData == null) {
      return const [
        Loading(text: "Загрузка"),
        Loading(text: "Загрузка"),
        Loading(text: "Загрузка"),
        Loading(text: "Загрузка"),
      ];
    }

    return [
      SearchPlayersForm(
        locationData: locationData!,
        onTapHandler: (p) {
          Navigator.of(context).pushNamed("/player/${p.id!}");
        },
      ),
      SearchCommunityForm(
        locationData: locationData!,
        onTapHandler: (p) {
          // Navigator.of(context).pushNamed("/player/${p.id!}");
        },
      ),
      SearchTrainersForm(
        locationData: locationData!,
        onTapHandler: (p) {
          // Navigator.of(context).pushNamed("/player/${p.id!}");
        },
      ),
      SearchCourtsForm(
        locationData: locationData!,
        onTapHandler: (p) {
          // Navigator.of(context).pushNamed("/player/${p.id!}");
        },
      )
    ];
  }
}
