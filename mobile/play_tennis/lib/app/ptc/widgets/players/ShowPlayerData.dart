import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/images/PlayerAvatar.dart';
import 'package:play_tennis/app/ptc/widgets/profile/PlayerActions.dart';
import 'package:play_tennis/logic/ptc/models/PlayerModel.dart';

class ShowPlayerData extends StatelessWidget {
  final PlayerModel player;
  const ShowPlayerData({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlayerCard(
          player: player,
          margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
        ),
        SizedBox(
          width: double.infinity,
          child: Card(
            margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text("Обо мне:"),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(player.aboutMe!),
                ),
              ],
            ),
          ),
        ),
        PlayerActions(player: player)
      ],
    );
  }
}

class PlayerCard extends StatelessWidget {
  const PlayerCard({
    Key? key,
    required this.player,
    required this.margin,
  }) : super(key: key);

  final EdgeInsetsGeometry margin;
  final PlayerModel player;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      elevation: 5,
      child: ListTile(
        leading: PlayerAvatar(avatarFileId: player.avatarFileId),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "${player.surname!} ${player.name!}",
              style: Theme.of(context).textTheme.titleLarge,
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
      ),
    );
  }
}
