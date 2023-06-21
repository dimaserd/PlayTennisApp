import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/images/CrocoAppImage.dart';
import 'package:play_tennis/app/ptc/widgets/games/GameDataWidget.dart';
import 'package:play_tennis/app/ptc/widgets/games/GameSetScores.dart';
import 'package:play_tennis/logic/ptc/models/PlayerSetScores.dart';
import 'package:play_tennis/logic/ptc/services/GameService.dart';

class GameToSelect extends StatelessWidget {
  final SinglesGameSimpleModel game;

  final VoidCallback onChange;
  final List<String> ignorePlayerIds;
  final GameDataWidgetController gameDataWidgetController =
      GameDataWidgetController();
  GameToSelect({
    super.key,
    required this.game,
    required this.ignorePlayerIds,
    required this.onChange,
  });

  GameSetScoresModel getScoresModel() {
    var player1 = game.players![0].player!;
    var player2 = game.players![1].player!;

    var player1Scores = toGameScores(0);
    var player2Scores = toGameScores(1);

    var winner = game.players!.firstWhere((e) => e.isWinner).player!;

    var sets = game.scoreData!.sets;

    return GameSetScoresModel(
      player1: player1,
      player2: player2,
      sets: sets!,
      player1Scores: player1Scores,
      player2Scores: player2Scores,
      winnerId: winner.id!,
    );
  }

  @override
  Widget build(BuildContext context) {
    var gameModel = getScoresModel();
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
            top: 15,
            bottom: 10,
          ),
          child: Column(
            children: [
              game.imageFileId != null
                  ? CrocoAppImage(
                      imageFileId: game.imageFileId!,
                    )
                  : const SizedBox.shrink(),
              Container(
                height: 10,
              ),
              GameSetScores(
                model: gameModel,
                onTapped: (p) {
                  onTappedHandler(p, context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  onTappedHandler(PlayerSimpleModel player, BuildContext context) {
    if (ignorePlayerIds.any((x) => x == player.id)) {
      return;
    }

    Navigator.of(context).pushNamed("/player/${player.id!}");
  }

  PlayerSetScores toGameScores(int numberPlayer) {
    var gamePlayer = GameDataWidgetExtensions.getStringValueGames(
        game.scoreData!.sets!, numberPlayer);
    return gamePlayer;
  }
}
