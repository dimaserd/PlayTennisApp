import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/images/PlayerAvatar.dart';
import '../../../../logic/ptc/models/PlayerModel.dart';

class PlayerDataWidget extends StatelessWidget {
  PlayerModel player;
  PlayerDataWidget({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: PlayerAvatar(avatarFileId: player.avatarFileId),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "${player.surname!} ${player.name!}",
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("Ntrp: ${player.ntrpRating}"),
          Text("Рейтинг силы: ${player.rating}"),
          Text("Пол: ${player.sex ? "Мужской" : "Женский"}"),
        ],
      ),
    );
  }
}
