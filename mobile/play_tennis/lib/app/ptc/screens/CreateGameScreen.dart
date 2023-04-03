import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/ptc/widgets/game-data/AddGameForm.dart';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/games/CreateSinglesGame.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/logic/ptc/models/PlayerModel.dart';

class CreateGameScreen extends StatefulWidget {
  final PlayerModel? player;
  const CreateGameScreen({Key? key, required this.player}) : super(key: key);

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
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
          ? AddGameForm(
              player: widget.player,
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
      SingleGameData gameData) async {
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

    return AppServices.gameService.create(model);
  }
}
