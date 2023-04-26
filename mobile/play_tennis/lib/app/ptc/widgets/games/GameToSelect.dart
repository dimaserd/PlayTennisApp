import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/images/CrocoAppImage.dart';
import 'package:play_tennis/app/ptc/widgets/games/GameDataWidget.dart';
import 'package:play_tennis/app/ptc/widgets/PlayerSetsScoreList.dart';
import 'package:play_tennis/logic/ptc/models/PlayerSetScores.dart';
import 'package:play_tennis/logic/ptc/services/GameService.dart';

class GameToSelect extends StatelessWidget {
  final SinglesGameSimpleModel game;

  final Function onChange;
  final List<String> ignorePlayerIds;
  final GameDataWidgetController gameDataWidgetController =
      GameDataWidgetController();
  GameToSelect({
    super.key,
    required this.game,
    required this.ignorePlayerIds,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    PlayerSetsScoreList(
                      sets: game.scoreData!.sets,
                      player: player1,
                      gameScores: gamePlayer1,
                      playerId: 0,
                      onTapped: (p) {
                        onTappedHandler(p, context);
                      },
                      isWinner: game.players!
                              .firstWhere((e) => e.isWinner)
                              .player!
                              .id ==
                          player1.id,
                    ),
                    PlayerSetsScoreList(
                      sets: game.scoreData!.sets,
                      player: player2,
                      gameScores: gamePlayer2,
                      playerId: 1,
                      onTapped: (p) {
                        onTappedHandler(p, context);
                      },
                      isWinner: game.players!
                              .firstWhere((e) => e.isWinner)
                              .player!
                              .id ==
                          player2.id,
                    )
                  ],
                ),
              )
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
