import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/images/PlayerAvatar.dart';
import 'package:play_tennis/logic/ptc/models/PlayerSetScores.dart';
import 'package:play_tennis/logic/ptc/models/games/TennisSetData.dart';
import 'package:play_tennis/logic/ptc/services/GameService.dart';

class PlayerSetsScoreList extends StatelessWidget {
  const PlayerSetsScoreList(
      {super.key,
      required this.player,
      required this.gameScores,
      required this.onTapped,
      required this.sets,
      required this.playerId});

  final Function(PlayerSimpleModel) onTapped;
  final PlayerSimpleModel player;
  final PlayerSetScores gameScores;
  final List<TennisSetData>? sets;
  final int playerId;


  @override
  Widget build(BuildContext context) {
    var childrens = getElements();
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                ),
                child: PlayerAvatar(
                  avatarFileId: player.avatarFileId,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                ),
                child: InkWell(
                  onTap: () => onTapped(player),
                  child: Center(
                    child: Text(
                      "${player.surname} ${player.name}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ...childrens
          ],
        ),
      ),
    );
  }

  List<Widget> getElements() {
    List<Widget> elements = [];
    var setsLengh = sets?.length ?? 0;
    for (var i = 0; i < setsLengh; i++) {
      var setData = sets![i];
      var score = playerId == 0 ? setData.score1 ?? "": setData.score2 ?? "";
      var currentScore = score;
      if (currentScore.isEmpty != true) {
      if (i == setsLengh - 1) {
        elements.add(Expanded(
          flex: 1,
          child: SizedBox(
            height: 50,
            child: Center(
              child: Text(
                currentScore,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ));
      } else {
        elements.add(Expanded(
          flex: 1,
          child: Container(
            height: 50,
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
            ),
            child: Center(
              child: Text(
                currentScore,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ));
      }
      }
    }

    return elements;
  }
}
