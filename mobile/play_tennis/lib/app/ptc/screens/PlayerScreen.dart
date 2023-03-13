import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/ptc/widgets/games/SearchGamesWidget.dart';
import 'package:play_tennis/app/ptc/widgets/players/ShowPlayerData.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
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
  CurrentLoginData? loginData;

  @override
  void initState() {
    super.initState();
    getPlayer();
    getLoginData();
  }

  void getPlayer() {
    AppServices.playerService.getById(widget.id).then((value) {
      setState(() {
        loaded = true;
        player = value;
      });
    });
  }

  void getLoginData() {
    AppServices.loginService.getLoginData().then((value) {
      setState(() {
        loginData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            leading: const BackButton(),
            bottom: const TabBar(
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
            padding: const EdgeInsets.all(0.0),
            child: TabBarView(
              children: getWidgets(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getWidgets() {
    if (player == null || loginData == null) {
      return const [
        Loading(text: "Загрузка"),
        Loading(text: "Загрузка"),
      ];
    }

    return [
      ShowPlayerData(player: player!),
      SearchGamesWidget(
        loginData: loginData!,
        playerId: player!.id!,
      )
    ];
  }
}
