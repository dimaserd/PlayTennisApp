import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/images/PlayerAvatar.dart';
import 'package:play_tennis/app/ptc/widgets/profile/PlayerConfirmationWidget.dart';
import 'package:play_tennis/app/ptc/widgets/profile/TelegramLinkTipWidget.dart';
import 'package:play_tennis/logic/ptc/models/PlayerData.dart';

class ProfileData extends StatelessWidget {
  final PlayerData player;

  const ProfileData({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        player.telegramUserId == null
            ? TelegramLinkTipWidget(
                player: player,
              )
            : const SizedBox.shrink(),
        !player.accountConfirmed
            ? PlayerConfirmationWidget(
                player: player,
              )
            : const SizedBox.shrink(),
        EmailConfirmationWidget(
          player: player,
        ),
        Card(
          margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
          elevation: 5,
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PlayerAvatar(
                  avatarFileId: player.avatarFileId,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Имя: ${player.surname!} ${player.name!}",
                ),
                Text("Email: ${player.email}"),
                Text("Номер телефона: ${player.phoneNumber}"),
                Text("Ntrp: ${player.ntrpRating}"),
                Text("Рейтинг силы: ${player.rating}"),
                Text("Пол: ${player.sex ? "Мужской" : "Женский"}")
              ],
            ),
          ),
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
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Обо мне:",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    player.aboutMe!,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
