import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/models/PlayerLocationData.dart';
import 'package:play_tennis/logic/ptc/models/cities/PublicTelegramChatForCityModel.dart';
import 'package:play_tennis/main-extensions.dart';
import 'package:play_tennis/main-settings.dart';

class TelegramData extends StatelessWidget {
  final PlayerLocationData locationData;
  final PublicTelegramChatForCityModel telegramCityModel;

  const TelegramData({
    super.key,
    required this.locationData,
    required this.telegramCityModel,
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
                const Text(
                  "Ваше местоположение:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Страна: ${locationData.country!.name}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Город: ${locationData.city!.name}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Все заявки и новости вашего города попадают в специальный чат, где вы можете обсуждать свои достижения и знакомиться с другими участниками.",
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Если вы не хотите участвовать в обсуждениях и устали от возможного флуда в чате, вы можете подписаться только на канал. Туда также попадают заявки, результаты игр и важные новости.",
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
        telegramCityModel.channelLink != null
            ? GestureDetector(
                onTap: () {
                  MainAppExtensions.launchUrlInBrowser(
                      telegramCityModel.channelLink!, (e) {
                    BaseApiResponseUtils.showError(
                      context,
                      "Произошла ошибка при открытии телеграм-канала. Обратитесь к админстратору портала.",
                    );
                  });
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
              )
            : const SizedBox.shrink(),
        telegramCityModel.chatLink != null
            ? GestureDetector(
                onTap: () {
                  MainAppExtensions.launchUrlInBrowser(
                      telegramCityModel.chatLink!, (e) {
                    BaseApiResponseUtils.showError(
                      context,
                      "Произошла ошибка при открытии телеграм-чата. Обратитесь к админстратору портала.",
                    );
                  });
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
              )
            : const SizedBox.shrink(),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
