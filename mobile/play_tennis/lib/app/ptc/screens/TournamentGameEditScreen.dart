import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/ptc/widgets/tournaments/EditTournamentGameForm.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/games/CreateSinglesGame.dart';
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
      body: loginData != null
          ? EditTournamentGameForm(
              game: widget.game,
              createGameClick: _createGameClickHandler,
              onSuccess: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/profile', (route) => true);
              },
            )
          : const Loading(text: "Загрузка"),
      appBar: AppBar(
        title: const Text("Создать игру"),
      ),
    );
  }

  Future<BaseApiResponse> _createGameClickHandler(
      TournamentGameData gameData) async {
    if (MyApp.inProccess) {
      return BaseApiResponse(isSucceeded: false, message: "Игра уже создается");
    }

    MyApp.inProccess = true;

    var matchData = TennisMatchData(
      sets: gameData.score,
      winnerPlayerId:
          gameData.isWinning ? loginData!.userId : gameData.opponent.id!,
    );

    var model = CreateSinglesGame(
      opponentPlayerId: gameData.opponent.id,
      imageFileId: gameData.imageFileId,
      cityId: gameData.courtCity.id!,
      court: gameData.courtName,
      courtType: gameData.courtType,
      playedOnUtc: gameData.gameDate,
      gameData: matchData,
    );

    var result = await AppServices.gameService.create(model, (e) {
      BaseApiResponseUtils.showError(
        context,
        "Произошла ошибка при создании игры. Пожалуйста, попробуйте еще раз.",
      );
    });
    MyApp.inProccess = false;
    return result;
  }
}
