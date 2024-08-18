import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/images/CrocoAppImage.dart';
import 'package:play_tennis/app/ptc/widgets/games/GameDataWidget.dart';
import 'package:play_tennis/app/ptc/widgets/games/GameSetScores.dart';
import 'package:play_tennis/logic/ptc/services/GameService.dart';
import 'package:play_tennis/logic/ptc/services/TournamentService.dart';
import 'package:play_tennis/main-routes.dart';

import 'TournamentGameScoresWidgetExtensions.dart';

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

  @override
  Widget build(BuildContext context) {
    var gameModelSafe = TournamentGameScoresWidgetExtensions.getScoresModelSafe(
      game,
      tournament.players!,
    );
    return GestureDetector(
      onTap: () {
        MainRoutes.toTournamentGameCard(context, game.id!);
      },
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
              Text(
                game.description!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              game.imageFileId != null
                  ? CrocoAppImage(
                      imageFileId: game.imageFileId!,
                      fromTournamentGameToSelect: true,
                    )
                  : const SizedBox.shrink(),
              Container(
                height: 10,
              ),
              gameModelSafe.succeeded && gameModelSafe.model != null
                  ? GameSetScores(
                      model: gameModelSafe.model!,
                      onTapped: (p) {
                        onTappedHandler(p, context);
                      },
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  onTappedHandler(PlayerSimpleModel player, BuildContext context) {
    MainRoutes.toTournamentGameCard(context, game.id!);
  }
}

class GameSetScoresModelSafe {
  final bool succeeded;
  final GameSetScoresModel? model;

  GameSetScoresModelSafe({
    required this.succeeded,
    required this.model,
  });
}
