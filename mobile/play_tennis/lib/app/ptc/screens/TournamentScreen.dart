import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/ptc/widgets/html/HtmlViewWidget.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/PlayerModel.dart';
import 'package:play_tennis/logic/ptc/services/TournamentService.dart';
import 'package:play_tennis/main-extensions.dart';
import 'package:play_tennis/main-services.dart';

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
    getLoginData();
    getTournament();
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
            title: loaded && tournament != null
                ? Text(tournament!.name!)
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
    if (tournament == null || loginData == null) {
      return const [
        Loading(text: "Загрузка"),
        Loading(text: "Загрузка"),
      ];
    }

    return [
      Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        elevation: 4,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  tournament!.name!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 5,
                ),
                tournament!.description != null
                    ? HtmlViewWidget(html: tournament!.description!)
                    : const SizedBox.shrink(),
                const SizedBox(
                  height: 5,
                ),
                ...getActions(),
              ],
            )
          ],
        ),
      ),
      const Loading(text: "Список игр"),
    ];
  }

  List<Widget> getActions() {
    List<Widget> result = [];

    if (!tournament!.isInTournament && tournament!.openForParticipantsJoining) {
      result.add(
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              minimumSize: const Size.fromHeight(36),
            ),
            onPressed: () {},
            child: Text(
              "Записаться ${tournament!.participationCostRub}₽",
            ),
          ),
        ),
      );
    }

    result.add(
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size.fromHeight(36),
          ),
          onPressed: () {
            _launchUrl();
          },
          child: const Text(
            "Турнирная сетка",
          ),
        ),
      ),
    );

    return result;
  }

  void _launchUrl() async {
    var url = "ptc/tournament/${tournament!.id}";
    MainAppExtensions.trylaunchAppUrl(url, (p0) => null);
  }
}
