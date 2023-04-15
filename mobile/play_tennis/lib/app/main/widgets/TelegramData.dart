import 'package:flutter/material.dart';
import 'package:play_tennis/logic/clt/models/models.dart';
import 'package:play_tennis/logic/ptc/models/PlayerData.dart';
import 'package:play_tennis/main-settings.dart';

class TelegramData extends StatelessWidget {
  final PlayerData player;
  final CurrentLoginData? loginData;

  const TelegramData({
    super.key,
    required this.player,
    required this.loginData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                const Image(
                  image: NetworkImage(
                      "${MainSettings.domain}/images/telegram/TelegramLogo.png"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Ваше местоположение:",
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Страна: Россия",
                ),
                Text(
                  "Город: Москва",
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            //copyIdHandler(context);
          },
          child: const SizedBox(
            height: 50,
            width: double.infinity,
            child: Card(
              color: Color.fromRGBO(36, 168, 235, 1),
              margin: EdgeInsets.only(top: 5, left: 5, right: 5),
              elevation: 5,
              child: Center(
                child: Text(
                  "Канал города ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            //copyIdHandler(context);
          },
          child: const SizedBox(
            height: 50,
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.only(top: 5, left: 5, right: 5),
              elevation: 5,
              color: Color.fromRGBO(36, 168, 235, 1),
              child: Center(
                child: Text(
                  "Чат города ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
