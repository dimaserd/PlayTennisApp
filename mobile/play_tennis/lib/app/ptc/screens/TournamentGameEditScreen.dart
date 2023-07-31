import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/ptc/widgets/tournaments/EditTournamentGameForm.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/games/TennisSetData.dart';
import 'package:play_tennis/logic/ptc/services/TournamentGameService.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/main.dart';

class TournamentGameEditScreen extends StatefulWidget {
  final TournamentGameDetailedModel game;
  const TournamentGameEditScreen({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  State<TournamentGameEditScreen> createState() =>
      _TournamentGameEditScreenState();
}

class _TournamentGameEditScreenState extends State<TournamentGameEditScreen> {
  CurrentLoginData? loginData;

  @override
  void initState() {
    AppServices.loginService.getLoginData().then((value) {
      if (mounted) {
        setState(() {
          loginData = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: getBody(context),
      appBar: AppBar(
        title: const Text("Указать счёт"),
      ),
    );
  }

  Widget getBody(BuildContext context) {
    return loginData != null
        ? EditTournamentGameForm(
            game: widget.game,
            createGameClick: _createGameClickHandler,
            onSuccess: () {
              Navigator.of(context).pop();
            },
          )
        : const Loading(text: "Загрузка");
  }

  Future<BaseApiResponse> _createGameClickHandler(
      TournamentGameData gameData) async {
    if (MyApp.inProccess) {
      return BaseApiResponse(isSucceeded: false, message: "Игра уже создается");
    }

    MyApp.inProccess = true;

    var matchData = TennisMatchData(
      sets: gameData.score,
      winnerPlayerId: gameData.gameScores.winnerId,
    );

    var model = UpdateGameScoreData(
      imageFileId: gameData.imageFileId,
      gameId: widget.game.game!.id!,
      gameData: matchData,
    );

    var result =
        await AppServices.tournamentGameService.updateScore(model, (e) {
      BaseApiResponseUtils.showError(
        context,
        "Произошла ошибка при создании игры. Пожалуйста, попробуйте еще раз.",
      );
    });
    MyApp.inProccess = false;
    return result;
  }
}
