import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/games/GameDataWidget.dart';
import 'package:play_tennis/app/ptc/widgets/PlayerGamesList.dart';
import 'package:play_tennis/logic/ptc/models/GamePlayers.dart';
import '../../../../logic/clt/models/CurrentLoginData.dart';
import '../../../../logic/ptc/services/GameService.dart';
import '../../../main/widgets/images/CrocoAppImage.dart';

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
    var player1 = game.players![0];
    var player2 = game.players![1];

    var gamePlayer1 = gameScores(0);
    var gamePlayer2 = gameScores(1);

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
                  "${player1.player!.surname} ${player1.player!.name} vs ${player2.player!.surname} ${player2.player!.name}",
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
              // Text(
              //   GameDataWidgetExtensions.getStringValue(game.scoreData!.sets!
              //       .where((e) => e.score1 != "" && e.score2 != "")
              //       .toList()),
              //   style: const TextStyle(
              //     fontSize: 20,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              game.imageFileId != null
                  ? CrocoAppImage(
                      imageFileId: game.imageFileId!,
                    )
                  : const SizedBox.shrink(),
              Container(
                height: 5,
              ),
              PlayerGamesList(
                  game: game, numberPlayer: 0, gamePlayer: gamePlayer1),
              PlayerGamesList(
                  game: game, numberPlayer: 1, gamePlayer: gamePlayer2)
            ],
          ),
        ),
      ),
    );
  }

  GamePlayers gameScores(int numberPlayer) {
    var gamePlayer = GameDataWidgetExtensions.getStringValueGames(
        game.scoreData!.sets!, numberPlayer);
    return gamePlayer;
  }
}
