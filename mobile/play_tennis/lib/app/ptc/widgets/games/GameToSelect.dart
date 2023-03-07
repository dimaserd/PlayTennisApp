import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/images/CrocoAppImage.dart';
import 'package:play_tennis/app/ptc/widgets/games/GameDataWidget.dart';
import 'package:play_tennis/app/ptc/widgets/PlayerSetsScoreList.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/PlayerSetScores.dart';
import 'package:play_tennis/logic/ptc/services/GameService.dart';

class GameToSelect extends StatelessWidget {
  final SinglesGameSimpleModel game;
  final CurrentLoginData loginData;
  final Function onChange;
  final GameDataWidgetController gameDataWidgetController =
      GameDataWidgetController();
  GameToSelect({
    super.key,
    required this.game,
    required this.loginData,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    var player1 = game.players![0].player!;
    var player2 = game.players![1].player!;

    var gamePlayer1 = toGameScores(0);
    var gamePlayer2 = toGameScores(1);

    return GestureDetector(
      onTap: () {},
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: 10,
          ),
          child: Column(
            children: [
              Center(
                child: Text(
                  "${player1.surname} ${player1.name} vs ${player2.surname} ${player2.name}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              game.imageFileId != null
                  ? CrocoAppImage(
                      imageFileId: game.imageFileId!,
                    )
                  : const SizedBox.shrink(),
              Container(
                height: 5,
              ),
              PlayerSetsScoreList(
                player: player1,
                gameScores: gamePlayer1,
                onTapped: (p) {},
              ),
              PlayerSetsScoreList(
                player: player2,
                gameScores: gamePlayer2,
                onTapped: (p) {},
              )
            ],
          ),
        ),
      ),
    );
  }

  onTappedHandler() {}

  PlayerSetScores toGameScores(int numberPlayer) {
    var gamePlayer = GameDataWidgetExtensions.getStringValueGames(
        game.scoreData!.sets!, numberPlayer);
    return gamePlayer;
  }
}
