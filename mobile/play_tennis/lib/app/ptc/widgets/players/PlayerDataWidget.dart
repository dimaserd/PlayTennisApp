import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/images/PlayerAvatar.dart';
import 'package:play_tennis/logic/ptc/models/PlayerModel.dart';

class PlayerDataWidget extends StatelessWidget {
  final PlayerModel player;

  const PlayerDataWidget({
    super.key,
    required this.player,
  });

@override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Row(
      children: [
        SizedBox(
          height: 100,
          child: PlayerAvatar(avatarFileId: player.avatarFileId),
        ),
        const SizedBox(width: 15),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => {
                  Navigator.of(context).pushNamed("/player/${player.id}")
                },
                child: Text(
                  "${player.surname!} ${player.name!}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 10),
              Text("Ntrp: ${player.ntrpRating}"),
              Text("Рейтинг силы: ${player.rating}"),
              Text("Пол: ${player.sex ? "Мужской" : "Женский"}"),
            ],
          ),
        )
      ],
    ),
  );
}

}
