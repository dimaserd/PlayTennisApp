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
    return Padding(
      padding: const EdgeInsets.only(
        top: 4,
        bottom: 4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
              height: 60,
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
          const SizedBox(width: 5),
          ...getElements()
        ],
      ),
    );
  }

  List<Widget> getElements() {
    print("getElements()");

    var setsLength = sets?.length ?? 0;
    List<Widget> elements = [];
    for (var i = 0; i < setsLength; i++) {
      var setData = sets![i];
      var score1 = playerId == 0 ? setData.score1 ?? "" : setData.score2 ?? "";
      var score2 = playerId == 0 ? setData.score2 ?? "" : setData.score1 ?? "";

      var str = "i = ${i.toString()} setsLength = $setsLength ";

      if (score1.isNotEmpty && score2.isNotEmpty) {
        elements.add(
          getScoreContainer(score1, score2),
        );
        if (i != setsLength - 1) {
          elements.add(
            const SizedBox(
              width: 5,
            ),
          );
          str += "sizedBox";
        }
        print(str);
      }
    }

    return elements;
  }

  Widget getScoreContainer(String score1, String score2) {
    return Container(
      width: 24,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFECECEC),
        borderRadius: BorderRadius.circular(
          3,
        ), // Задаем радиус закругления углов
      ),
      child: Center(
        child: Text(
          score1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontFamily: int.parse(score1) >= int.parse(score2)
                ? "QuickSand-bold"
                : "QuickSand",
          ),
        ),
      ),
    );
  }
}
