import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/extensions/AppUtils.dart';
import 'package:play_tennis/app/main/widgets/images/PlayerAvatar.dart';
import 'package:play_tennis/app/ptc/widgets/profile/PlayerActions.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/PlayerModel.dart';
import 'package:play_tennis/main-settings.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowPlayerData extends StatelessWidget {
  final PlayerModel player;
  final CurrentLoginData loginData;
  const ShowPlayerData({
    super.key,
    required this.player,
    required this.loginData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlayerCard(
          player: player,
          margin: const EdgeInsets.only(
            top: 5,
            left: 5,
            right: 5,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Card(
            margin: const EdgeInsets.only(
              top: 5,
              left: 5,
              right: 5,
            ),
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
        player.id != loginData.userId
            ? PlayerActions(
                player: player,
                loginData: loginData,
              )
            : const SizedBox.shrink()
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
            Text(
              "Ntrp: ${player.ntrpRating}",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            Text(
              "Рейтинг силы: ${player.rating}",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            Text(
              "Пол: ${player.sex ? "Мужской" : "Женский"}",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            ...getTelegramWidgets(context),
          ],
        ),
      ),
    );
  }

  List<Widget> getTelegramWidgets(BuildContext context) {
    if (player.telegramUserId != null && player.telegramUserName != null) {
      return [
        Row(
          children: [
            const Text(
              "Telegram: ",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            InkWell(
              child: Text(
                "@${player.telegramUserName!}",
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                AppUtils.tryAndShowMessageIfError(
                  () {
                    var uri = Uri.parse(
                      TelegramRoutesProvider.resolve(player.telegramUserName!),
                    );
                    launchUrl(uri);
                  },
                  context,
                  "Произошла ошибка при переходе на Telegram игрока. Пожалуйста, обратитесь к администратору портала.",
                );
              },
            )
          ],
        )
      ];
    }
    return [];
  }
}
