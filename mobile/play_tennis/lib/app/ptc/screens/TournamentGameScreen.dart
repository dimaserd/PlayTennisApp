import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/main/widgets/images/CrocoAppImage.dart';
import 'package:play_tennis/app/ptc/widgets/games/GameSetScores.dart';
import 'package:play_tennis/app/ptc/widgets/tournaments/TournamentGameScoresWidgetExtensions.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/services/TournamentGameService.dart';
import 'package:play_tennis/main-routes.dart';
import 'package:play_tennis/main-services.dart';

class TournamentGameScreen extends StatefulWidget {
  final String id;
  const TournamentGameScreen({super.key, required this.id});

  @override
  State<TournamentGameScreen> createState() => _TournamentGameScreenState();
}

class _TournamentGameScreenState extends State<TournamentGameScreen> {
  TournamentGameDetailedModel? game;
  bool loaded = false;
  CurrentLoginData? loginData;

  @override
  void initState() {
    super.initState();
    getLoginData();
    getTournament();
  }

  void getTournament() {
    AppServices.tournamentGameService.getByIdDetailed(widget.id, (e) {
      BaseApiResponseUtils.showError(
        (context),
        "Произошла ошибка при загрузке игры для турнира",
      );
    }).then((value) {
      setState(() {
        loaded = true;
        game = value;
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
                  text: "Игра",
                ),
                Tab(
                  text: "Дополнительно",
                ),
              ],
            ),
            title: loaded && game != null
                ? Text(
                    game!.game!.description!,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  )
                : const Text(
                    "Загрузка игры",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
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
    if (game == null || loginData == null) {
      return const [
        Loading(text: "Загрузка"),
        Loading(text: "Загрузка"),
      ];
    }

    var scoresSafe = TournamentGameScoresWidgetExtensions.getScoresModelSafe(
      game!.game!,
      game!.players!,
    );

    return [
      Expanded(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
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
                          game!.game!.description!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    game!.game!.imageFileId != null
                        ? CrocoAppImage(
                            imageFileId: game!.game!.imageFileId!,
                          )
                        : const SizedBox.shrink(),
                    Container(
                      height: 10,
                    ),
                    scoresSafe.succeeded
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GameSetScores(
                              model: scoresSafe.model!,
                              onTapped: (p) {
                                MainRoutes.toPlayerCard(context, p.id!);
                              },
                            ),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 5,
                    ),
                    ...getActions(),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: const [
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox.shrink()
    ];
  }

  List<Widget> getActions() {
    List<Widget> result = [];

    result.add(
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size.fromHeight(36),
        ),
        onPressed: () {},
        child: const Text(
          "Редактировать счет",
        ),
      ),
    );
    return result;
  }
}
