import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/images/CrocoAppImage.dart';
import 'package:play_tennis/app/ptc/widgets/games/GameDataWidget.dart';
import 'package:play_tennis/app/ptc/widgets/games/GameSetScores.dart';
import 'package:play_tennis/logic/ptc/models/PlayerSetScores.dart';
import 'package:play_tennis/logic/ptc/services/GameService.dart';
import 'package:play_tennis/logic/ptc/services/TournamentService.dart';

class TournamentGameToSelect extends StatelessWidget {
  final TournamentEventModel game;
  final TournamentDetailedModel tournament;

  final VoidCallback onChange;
  final GameDataWidgetController gameDataWidgetController =
      GameDataWidgetController();

  TournamentGameToSelect({
    super.key,
    required this.game,
    required this.tournament,
    required this.onChange,
  });

  GameSetScoresModel getScoresModel() {
    var player1Id = game.players![0].userId!;
    var player2Id = game.players![1].userId!;

    var player1 = tournament.players!.firstWhere((e) => e.id! == player1Id);
    var player2 = tournament.players!.firstWhere((e) => e.id! == player2Id);

    var player1Scores = toGameScores(0);
    var player2Scores = toGameScores(1);

    var winner = game.players!.firstWhere(
      (e) => e.isWinner,
      orElse: () => GamePlayerModel(userId: "default", isWinner: true),
    );

    var sets = game.scoreData!.sets;

    return GameSetScoresModel(
      player1: player1,
      player2: player2,
      sets: sets!,
      player1Scores: player1Scores,
      player2Scores: player2Scores,
      winnerId: winner.userId!,
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
    Navigator.of(context).pushNamed("/tournament-game/${tournament.id!}");
  }

  PlayerSetScores toGameScores(int numberPlayer) {
    var gamePlayer = GameDataWidgetExtensions.getStringValueGames(
        game.scoreData!.sets!, numberPlayer);
    return gamePlayer;
  }
}
