import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/images/PlayerAvatar.dart';
import 'package:play_tennis/logic/ptc/models/PlayerModel.dart';

class PlayerToSelect extends StatelessWidget {
  final PlayerModel player;
  void Function(PlayerModel player) onTapHandler;
  PlayerToSelect({
    super.key,
    required this.player,
    required this.onTapHandler,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapHandler(player);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
        elevation: 5,
        child: ListTile(
          leading: PlayerAvatar(avatarFileId: player.avatarFileId),
          title: Text(
            "${player.surname!} ${player.name!}",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Ntrp: ${player.ntrpRating}"),
              Text("Рейтинг силы: ${player.rating}")
            ],
          ),
        ),
      ),
    );
  }
}
