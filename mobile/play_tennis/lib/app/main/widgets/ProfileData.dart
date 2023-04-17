import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:play_tennis/app/main/widgets/images/PlayerAvatar.dart';
import 'package:play_tennis/app/ptc/widgets/cities/CityChatAndChannelWidget.dart';
import 'package:play_tennis/app/ptc/widgets/profile/PlayerConfirmationWidget.dart';
import 'package:play_tennis/logic/clt/models/models.dart';
import 'package:play_tennis/app/ptc/widgets/profile/TelegramLinkTipWidget.dart';
import 'package:play_tennis/logic/ptc/models/PlayerData.dart';
import 'package:play_tennis/main-services.dart';

class ProfileData extends StatefulWidget {
  final PlayerData player;
  final CurrentLoginData? loginData;

  const ProfileData({
    super.key,
    required this.player,
    required this.loginData,
  });

  @override
  State<ProfileData> createState() => ProfileDataState();
}

class ProfileDataState extends State<ProfileData> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.player.telegramUserId == null
            ? TelegramLinkTipWidget(
                player: widget.player,
                updateTelegram: (id) {
                  setState(() {
                    widget.player.telegramUserId = id;
                  });
                },
              )
            : const SizedBox.shrink(),
        !widget.player.accountConfirmed
            ? PlayerConfirmationWidget(
                player: widget.player,
              )
            : const SizedBox.shrink(),
        EmailConfirmationWidget(
          player: widget.player,
        ),
        Card(
          margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
          elevation: 5,
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 15,
                ),
                PlayerAvatar(
                  avatarFileId: widget.player.avatarFileId,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Имя: ${widget.player.surname!} ${widget.player.name!}",
                ),
                widget.player.noEmail
                    ? const SizedBox.shrink()
                    : Text("Email: ${widget.player.email}"),
                Text("Номер телефона: ${widget.player.phoneNumber}"),
                Text("Ntrp: ${widget.player.ntrpRating}"),
                Text("Рейтинг силы: ${widget.player.rating}"),
                Text("Пол: ${widget.player.sex ? "Мужской" : "Женский"}")
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
                    widget.player.aboutMe!,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ToTelegramButton(
            text: "Telegram cообщество",
            tapHandler: () {
              Navigator.of(context).pushNamed("/profile/telegram");
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            copyIdHandler(context);
          },
          child: const SizedBox(
            height: 50,
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.only(top: 5, left: 5, right: 5),
              elevation: 5,
              child: Center(
                child: Text(
                  "Скопировать ID",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        GestureDetector(
          onTap: () {
            showDialogHandler(context);
          },
          child: const SizedBox(
            height: 50,
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.only(left: 5, right: 5),
              color: Colors.red,
              elevation: 5,
              child: Center(
                child: Text(
                  "Удалить аккаунт",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }

  Future<void> deleteAccount(context, String userId) async {
    await AppServices.deletePlayerService.delete(userId, (er) {});
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  showDialogHandler(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: const Text('Вы действительно хотите удалить аккаунт?'),
            actions: [
              ElevatedButton(
                child: const Text('Отменить'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('Да'),
                onPressed: () {
                  if (widget.loginData?.userId != null) {
                    final userId = widget.loginData!.userId!;
                    deleteAccount(context, userId);
                  }
                },
              ),
            ],
          );
        });
  }

  copyIdHandler(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.loginData!.userId!)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Ваш ID скопирован в буфер обмена.",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ));
    });
  }
}
