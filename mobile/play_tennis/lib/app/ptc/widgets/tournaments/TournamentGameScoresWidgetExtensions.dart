import 'package:play_tennis/app/ptc/widgets/games/GameDataWidget.dart';
import 'package:play_tennis/app/ptc/widgets/games/GameSetScores.dart';
import 'package:play_tennis/app/ptc/widgets/tournaments/TournamentGameToSelect.dart';
import 'package:play_tennis/logic/ptc/models/PlayerSetScores.dart';
import 'package:play_tennis/logic/ptc/services/GameService.dart';
import 'package:play_tennis/logic/ptc/services/TournamentService.dart';

class TournamentGameScoresWidgetExtensions {
  static GameSetScoresModelSafe getScoresModelSafe(
      TournamentEventModel game, List<PlayerSimpleModel> players) {
    if (game.players!.isEmpty) {
      return GameSetScoresModelSafe(
        succeeded: false,
        model: null,
      );
    }

    return GameSetScoresModelSafe(
      succeeded: true,
      model: getScoresModel(game, players),
    );
  }

  static GameSetScoresModel getScoresModel(
      TournamentEventModel game, List<PlayerSimpleModel> players) {
    var player1Id = game.players![0].userId!;
    var player2Id = game.players![1].userId!;

    var player1 = players.firstWhere((e) => e.id! == player1Id);
    var player2 = players.firstWhere((e) => e.id! == player2Id);

    var player1Scores = toGameScores(game, 0);
    var player2Scores = toGameScores(game, 1);

    var winner = game.players!.firstWhere(
      (e) => e.isWinner,
      orElse: () => GamePlayerModel(
        userId: "default",
        isWinner: true,
      ),
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

  static PlayerSetScores toGameScores(
      TournamentEventModel game, int numberPlayer) {
    var gamePlayer = GameDataWidgetExtensions.getStringValueGames(
        game.scoreData!.sets!, numberPlayer);
    return gamePlayer;
  }
}
