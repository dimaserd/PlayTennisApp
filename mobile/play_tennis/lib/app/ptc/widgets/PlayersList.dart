import 'package:flutter/material.dart';
import '../../../logic/ptc/models/PlayerModel.dart';
import 'PlayerToSelect.dart';

class PlayersList extends StatelessWidget {
  final List<PlayerModel> players;
  double height;
  void Function(PlayerModel player) onTapHandler;
  PlayersList({
    super.key,
    required this.height,
    required this.onTapHandler,
    required this.players,
  });

  Widget getChild() {
    return players.isEmpty
        ? Column(children: const [
            Center(
              child: Text("Игроки не найдены"),
            ),
          ])
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return PlayerToSelect(
                player: players[index],
                onTapHandler: (p) {
                  onTapHandler(p);
                },
              );
            },
            itemCount: players.length,
          );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: getChild(),
    );
  }
}
