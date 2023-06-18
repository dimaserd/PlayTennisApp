import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/PlayerSetsScoreList.dart';
import 'package:play_tennis/logic/ptc/models/PlayerSetScores.dart';
import 'package:play_tennis/logic/ptc/models/games/TennisSetData.dart';
import 'package:play_tennis/logic/ptc/services/GameService.dart';

class GameSetScoresModel {
  final List<TennisSetData> sets;
  final PlayerSimpleModel player1;
  final PlayerSimpleModel player2;
  final PlayerSetScores player1Scores;
  final PlayerSetScores player2Scores;
  final String winnerId;

  GameSetScoresModel({
    required this.sets,
    required this.player1,
    required this.player2,
    required this.player1Scores,
    required this.player2Scores,
    required this.winnerId,
  });
}

class GameSetScores extends StatelessWidget {
  final GameSetScoresModel model;
  final Function(PlayerSimpleModel) onTapped;

  const GameSetScores({
    super.key,
    required this.model,
    required this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlayerSetsScoreList(
          sets: model.sets,
          player: model.player1,
          gameScores: model.player1Scores,
          playerId: 0,
          onTapped: (p) {
            onTapped(p);
          },
          isWinner: model.winnerId == model.player1.id,
        ),
        PlayerSetsScoreList(
          sets: model.sets,
          player: model.player2,
          gameScores: model.player2Scores,
          playerId: 1,
          onTapped: (p) {
            onTapped(p);
          },
          isWinner: model.winnerId == model.player2.id,
        )
      ],
    );
  }
}
