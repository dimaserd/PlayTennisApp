import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/images/PlayerAvatar.dart';
import 'package:play_tennis/logic/ptc/models/GamePlayers.dart';
import '../../../../logic/ptc/services/GameService.dart';

class PlayerGamesList extends StatelessWidget {
 const  PlayerGamesList(
      {super.key, required this.game, required this.numberPlayer, required this.gamePlayer});

  final int numberPlayer;
  final SinglesGameSimpleModel game;
  final GamePlayers gamePlayer;

  @override
  Widget build(BuildContext context) {
    var player = game.players![numberPlayer];
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
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
                  avatarFileId: player.player!.avatarFileId,
                )                
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
                child: Center(
                  child: Text(
                      "${player.player!.surname} ${player.player!.name}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                ),
              ),
            ),
            Expanded(
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
                  child: Text(gamePlayer.firstGame,
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                ),
              ),
            ),
            Expanded(
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
                  child: Text(gamePlayer.secondGame,
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 50,
                child: Center(
                  child: Text(gamePlayer.thirdGame,
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
