import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/images/PlayerAvatar.dart';
import 'package:play_tennis/logic/ptc/models/PlayerSetScores.dart';
import 'package:play_tennis/logic/ptc/models/games/TennisSetData.dart';
import 'package:play_tennis/logic/ptc/services/GameService.dart';

class PlayerSetsScoreList extends StatelessWidget {
  const PlayerSetsScoreList({
    super.key,
    required this.player,
    required this.gameScores,
    required this.onTapped,
    required this.sets,
    required this.playerId,
    required this.isWinner,
  });

  final Function(PlayerSimpleModel) onTapped;
  final PlayerSimpleModel player;
  final PlayerSetScores gameScores;
  final List<TennisSetData>? sets;
  final int playerId;
  final bool isWinner;

  @override
  Widget build(BuildContext context) {
    var childrens = getElements();
    return Padding(
      padding: const EdgeInsets.only(
        top: 4,
        bottom: 4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ), // Замените "radius" на значение радиуса
                child: Container(
                  color: const Color(0xFFECECEC),
                  child: PlayerAvatar(
                    avatarFileId: player.avatarFileId,
                  ),
                ),
              )),
          Expanded(
            flex: 6,
            child: InkWell(
              onTap: () => onTapped(player),
              child: Container(
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFECECEC),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(3),
                    bottomRight: Radius.circular(3),
                  ), // Задаем радиус закругления углов
                ),
                child: Align(
                  alignment: Alignment
                      .centerLeft, // выравнивание по вертикали по центру и горизонтали слева
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      "${player.surname} ${player.name}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight:
                            isWinner ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ...childrens
        ],
      ),
    );
  }

  List<Widget> getElements() {
    List<Widget> elements = [];
    var setsLengh = sets?.length ?? 0;
    for (var i = 0; i < setsLengh; i++) {
      var setData = sets![i];
      var score = playerId == 0 ? setData.score1 ?? "" : setData.score2 ?? "";
      var enemyScore =
          playerId == 0 ? setData.score2 ?? "" : setData.score1 ?? "";
      var currentScore = score;
      if (currentScore.isEmpty != true) {
        if (i == setsLengh - 1) {
          elements.add(Expanded(
            flex: 1,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFECECEC),
                borderRadius:
                    BorderRadius.circular(3), // Задаем радиус закругления углов
              ),
              child: Center(
                child: Text(
                  currentScore,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: int.parse(currentScore) >= int.parse(enemyScore)
                        ? "QuickSand-bold"
                        : "QuickSand",
                  ),
                ),
              ),
            ),
          ));
        } else {
          elements.add(
            Expanded(
                flex: 1,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECECEC),
                    borderRadius: BorderRadius.circular(
                      3,
                    ), // Задаем радиус закругления углов
                  ),
                  child: Center(
                    child: Text(
                      currentScore,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontFamily:
                            int.parse(currentScore) >= int.parse(enemyScore)
                                ? "QuickSand-bold"
                                : "QuickSand",
                      ),
                    ),
                  ),
                )),
          );
          elements.add(const SizedBox(
            width: 5,
          ));
        }
      }
    }

    return elements;
  }
}
