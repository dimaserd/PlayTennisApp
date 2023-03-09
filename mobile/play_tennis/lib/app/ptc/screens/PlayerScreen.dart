import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/ptc/widgets/players/ShowPlayerData.dart';
import 'package:play_tennis/logic/ptc/models/PlayerModel.dart';
import 'package:play_tennis/main-services.dart';

class PlayerScreen extends StatefulWidget {
  final String id;
  const PlayerScreen({super.key, required this.id});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  PlayerModel? player;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    AppServices.playerService.getById(widget.id).then((value) {
      setState(() {
        loaded = true;
        player = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                text: "Профиль",
              ),
              Tab(
                text: "Игры",
              ),
            ],
          ),
          title: loaded && player != null
              ? Text("${player!.surname!} ${player!.name!}")
              : const Text("Загрузка игрока..."),
        ),
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
    if (player == null) {
      return const [
        Loading(text: "Загрузка"),
        Loading(text: "Загрузка"),
      ];
    }

    return [
      ShowPlayerData(player: player!),
      const Loading(text: "Игры пока не реализованы"),
    ];
  }
}
