import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/game-requests/GameRequestExtensions.dart';
import 'package:play_tennis/app/ptc/widgets/players/PlayerDataWidget.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestSimpleModel.dart';

class GameRequestToSelect extends StatelessWidget {
  final GameRequestSimpleModel request;
  final CurrentLoginData loginData;
  const GameRequestToSelect({
    super.key,
    required this.request,
    required this.loginData,
  });

  @override
  Widget build(BuildContext context) {
    var player = request.author!;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed("/game-request/${request.id}");
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
        elevation: 5,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  GameRequestExtensions.getDateString(request.matchDateUtc),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            PlayerDataWidget(
              player: player,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  request.description!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
