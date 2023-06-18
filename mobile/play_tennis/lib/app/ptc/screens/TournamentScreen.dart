import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/ptc/widgets/games/SearchGamesWidget.dart';
import 'package:play_tennis/app/ptc/widgets/players/ShowPlayerData.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/PlayerModel.dart';
import 'package:play_tennis/logic/ptc/services/TournamentService.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/main-state.dart';

class TournamentScreen extends StatefulWidget {
  final String id;
  const TournamentScreen({super.key, required this.id});

  @override
  State<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  PlayerModel? player;
  TournamentDetailedModel? tournament;
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
        MainState.isAuthorized = player != null;
        player = value;
      });
    });
  }

  void getTournament() {
    AppServices.tournamentService.getById(widget.id, (e) {
      BaseApiResponseUtils.showError(
        (context),
        "Произошла ошибка при загрузке турнира",
      );
    }).then((value) {
      setState(() {
        loaded = true;
        tournament = value;
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
                  text: "Главная",
                ),
                Tab(
                  text: "Игры",
                ),
              ],
            ),
            title: loaded && player != null
                ? Text("${player!.surname!} ${player!.name!}")
                : const Text("Загрузка турнира..."),
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
      ShowPlayerData(
        player: player!,
        loginData: loginData!,
      ),
      SearchGamesWidget(
        loginData: loginData!,
        playerId: player!.id!,
      )
    ];
  }
}
