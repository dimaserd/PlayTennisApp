import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/game-data/GameFormExtensions.dart';
import 'package:play_tennis/app/ptc/widgets/games/GameDataWidget.dart';
import 'package:play_tennis/logic/ptc/models/PlayerModel.dart';

class GameFormMatchInfoWidget extends StatelessWidget {
  const GameFormMatchInfoWidget({
    Key? key,
    required this.context,
    required this.opponent,
    required this.gameDataWidgetController,
    required this.backBtnHandler,
    required this.showCourtType,
    required this.courtType,
    required this.customWidgets,
  }) : super(key: key);

  final VoidCallback backBtnHandler;
  final BuildContext context;
  final PlayerModel opponent;
  final GameDataWidgetController gameDataWidgetController;
  final bool showCourtType;
  final String courtType;
  final List<Widget> customWidgets;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ...GameFormExtensions.getMatchText(
              context,
              opponent,
              gameDataWidgetController.isWinning(),
              gameDataWidgetController.getStringValue(),
              customWidgets,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size.fromHeight(36),
              ),
              onPressed: () {
                backBtnHandler();
              },
              child: const Text(
                "Назад",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
